import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

part 'vpn_event.dart';
part 'vpn_state.dart';

class VpnBloc extends Bloc<VpnEvent, VpnState> {
  VpnBloc() : super(VpnInitialState()) {
    on<VpnDisconnect>((event, emit) async {
      event.openVPN.disconnect();
      emit(VpnDisconnectedState(isConnected: false));
    });

    on<VpnConnect>((event, emit) async {
      final config = await rootBundle.loadString('assets/__Admin2.txt');

      event.openVPN.connect(
        config,
        'GhostVPN',
        username: 'admin',
        password: 'admin',
        bypassPackages: [],
        certIsRequired: false,
      );

      emit(VpnConnectedState(isConnected: true));
    });
  }
}
