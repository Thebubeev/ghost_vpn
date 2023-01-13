import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:ghost_vpn/api/yokassa_api.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:yookassa_payments_flutter/yookassa_payments_flutter.dart';

part 'vpn_event.dart';
part 'vpn_state.dart';

class VpnBloc extends Bloc<VpnEvent, VpnState> {
  final auth = Auth();
  VpnBloc() : super(VpnInitialState()) {
    on<VpnSubscriptionPay>((event, emit) async {
      try {
        final payment = await makePayment(event.title, event.value);
        if (payment != null) {
          emit(VpnLoadingState());
          final yokassaPayment = await YokassaApi().makeYokassaPayment(
              payment.token, event.title, event.value.toString());
          if (yokassaPayment != null && yokassaPayment.confirmation != null) {
            final confirmUrl =
                Uri.parse(yokassaPayment.confirmation!.confirmationUrl!);
            await YookassaPaymentsFlutter.confirmation(
                    confirmUrl.toString(), PaymentMethod.bankCard)
                .then((_) async {
              final currentPayment =
                  await YokassaApi().checkYokassaPayment(yokassaPayment.id!);
              if (currentPayment?.status == 'succeeded') {
                await auth.completePayment();
                emit(VpnSubscriptionPaidState());
              } else {
                emit(VpnReturnState());
              }
            });
          } else {
            emit(VpnReturnState());
          }
        } else {
          emit(VpnReturnState());
        }
      } catch (e) {
        print(e);
        emit(VpnReturnState());
      }
    });

    on<VpnDisconnect>((event, emit) async {
      event.openVPN.disconnect();
      emit(VpnDisconnectedState(isConnected: false));
    });

    on<VpnConnect>((event, emit) async {
      final config = await rootBundle.loadString('assets/__Admin2.txt');
      try {
        event.openVPN.connect(
          config,
          'GhostVPN',
          username: '',
          password: '',
          bypassPackages: [],
          certIsRequired: true,
        );
      } catch (e) {
        print(e);
        emit(VpnErrorState());
      }

      emit(VpnConnectedState(isConnected: true));
    });
  }
  Future makePayment(String title, int value) async {
    final inputData = TokenizationModuleInputData(
        returnUrl: 'https://ddpub.ru/success',
        moneyAuthClientId: Constants.clientId,
        tokenizationSettings: TokenizationSettings(PaymentMethodTypes.all),
        clientApplicationKey: Constants.secretMobileKey,
        title: 'GhostVPN',
        applicationScheme: 'ghostvpn_scheme',
        subtitle: title,
        amount: Amount(value: value.toDouble(), currency: Currency.rub),
        savePaymentMethod: SavePaymentMethod.userSelects,
        shopId: Constants.shopId);

    try {
      var result = await YookassaPaymentsFlutter.tokenization(inputData);
      return result;
    } catch (e) {
      print(e.toString());
    }
  }
}
