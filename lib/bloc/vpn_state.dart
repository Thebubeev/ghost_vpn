part of 'vpn_bloc.dart';

@immutable
abstract class VpnState {}

class VpnInitialState extends VpnState {}

class VpnDataState extends VpnState {
  final FlutterVpnState flutterVpnState;
  VpnDataState({this.flutterVpnState});
}

class VpnConnectedState extends VpnState {
  final bool isConnected;
  VpnConnectedState({this.isConnected});
}

class VpnDisconnectedState extends VpnState {
  final bool isConnected;
  VpnDisconnectedState({this.isConnected});
}

class VpnLoadingState extends VpnState {}

class VpnErrorState extends VpnState {}
