import 'package:bloc/bloc.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:flutter_vpn/state.dart';
import 'package:meta/meta.dart';

part 'vpn_event.dart';
part 'vpn_state.dart';

class VpnBloc extends Bloc<VpnEvent, VpnState> {
  VpnBloc() : super(VpnInitialState()) {
    on<VpnInitialize>((event, emit) async{
     await FlutterVpn.prepare();
      FlutterVpn.onStateChanged.listen((currentState) {
        emit(VpnDataState(flutterVpnState: currentState));
      });
    });

    on<VpnDisconnect>((event, emit) async {
      //    await FlutterVpn.disconnect();
      emit(VpnDisconnectedState(isConnected: false));
    });

    on<VpnConnect>((event, emit) async {
      //  await FlutterVpn.connectIkev2EAP(server: '', username: '', password: '');
      emit(VpnConnectedState(isConnected: true));
    });
  }
}
