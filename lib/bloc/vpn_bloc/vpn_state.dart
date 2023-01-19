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

class VpnSubscriptionPaidState extends VpnState {}

class VpnLoadingState extends VpnState {}

class VpnReturnState extends VpnState {}

class VpnExitAppState extends VpnState{
  final bool isConnected;

  VpnExitAppState({required this.isConnected});}

class VpnErrorState extends VpnState {}
