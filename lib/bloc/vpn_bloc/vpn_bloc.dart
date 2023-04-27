import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ghost_vpn/api/yokassa_api.dart';
import 'package:ghost_vpn/models/firebase_config.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:yookassa_payments_flutter/yookassa_payments_flutter.dart';

part 'vpn_event.dart';
part 'vpn_state.dart';

class VpnBloc extends Bloc<VpnEvent, VpnState> {
  CollectionReference collectionReference_configs =
      FirebaseFirestore.instance.collection('configs');
  AuthBase auth = Auth();

  VpnBloc() : super(VpnInitialState()) {
    on<VpnSubscriptionPay>((event, emit) async {
      try {
        final payment = await makePayment(event.title, event.value);
        if (payment != null) {
          emit(VpnLoadingSubscriptionState());
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
                await Auth().completePayment(currentPayment!.description!);
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

    on<VpnConnect>((event, emit) async {
      emit(VpnLoadingVpnState());

      await collectionReference_configs.get().then((snapshots) async {
        List<FirebaseConfig> configs = [];
        if (snapshots.docs.isNotEmpty) {
          snapshots.docs.forEach((element) {
            configs.add(FirebaseConfig(
                name: element.get('name'), active: element.get('active')));
          });

          String configName = configs[0].name;
          int min = configs[0].active;
          for (int i = 0; i < configs.length; i++) {
            if (configs[i].active < min) {
              configName = configs[i].name;
            }
          }
          final path =
              await auth.getFirebaseDocuments(configName, 'txt', 'configs');
          final remoteConfig = await File(path).readAsString();
          print(configName);
          print(path);

          dynamic chatDocId;

          await collectionReference_configs
              .where('name', isEqualTo: configName)
              .limit(1)
              .get()
              .then((snapshot) async {
            if (snapshots.docs.isNotEmpty) {
              chatDocId = snapshot.docs.single.id;
              // await collectionReference_configs
              //     .doc(chatDocId)
              //     .update({'active': FieldValue.increment(2)});

              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('configs')
                  .doc(chatDocId);
              FirebaseFirestore.instance.runTransaction((transaction) async {
                final snapshot = await transaction.get(documentReference);
                final newActive = snapshot.get('active') + 1;
                await transaction
                    .update(documentReference, {'active': newActive});
              }).catchError((e) {
                print(e);
              });
            }
          });

          try {
            event.openVPN.connect(
              remoteConfig,
              'GhostVPN',
              username: '',
              password: '',
              bypassPackages: [],
              certIsRequired: true,
            );
            emit(VpnConnectedState(isConnected: true, chatDocId: chatDocId));
          } catch (e) {
            print(e);
            emit(VpnErrorState());
          }
        }
      });
    });

    on<VpnDisconnect>((event, emit) async {
      event.openVPN.disconnect();
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('configs').doc(event.chatDocId);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(documentReference);
        final newActive = snapshot.get('active') - 1;
        await transaction.update(documentReference, {'active': newActive});
      });
      emit(VpnDisconnectedState());
    });
  }

  Future makePayment(String title, int value) async {
    final inputData = TokenizationModuleInputData(
        returnUrl: 'https://ddpub.ru/success',
        moneyAuthClientId: Constants.clientId,
        tokenizationSettings: TokenizationSettings(PaymentMethodTypes.bankCard),
        clientApplicationKey: Constants.secretMobileKey,
        title: 'GhostVPN',
        applicationScheme: 'ghostvpn_scheme',
        subtitle: title,
        amount: Amount(value: value.toDouble(), currency: Currency.rub),
        savePaymentMethod: SavePaymentMethod.off,
        shopId: Constants.shopId);

    try {
      var result = await YookassaPaymentsFlutter.tokenization(inputData);
      return result;
    } catch (e) {
      print(e.toString());
    }
  }
}
