part of 'vpn_bloc.dart';

@immutable
abstract class VpnState {}

class VpnInitialState extends VpnState {}

class VpnConnectedState extends VpnState {
  final bool isConnected;
  VpnConnectedState({required this.isConnected});
}

class VpnDisconnectedState extends VpnState {
  final bool isConnected;
  VpnDisconnectedState({required this.isConnected});
}

class VpnLoadingState extends VpnState {}

class VpnErrorState extends VpnState {}
