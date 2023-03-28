part of 'vpn_bloc.dart';

@immutable
abstract class VpnState {}

class VpnInitialState extends VpnState {}

class VpnConnectedState extends VpnState {
  final bool isConnected;
  final dynamic chatDocId;
  VpnConnectedState({required this.isConnected, required this.chatDocId});
}

class VpnDisconnectedState extends VpnState {}

class VpnSubscriptionPaidState extends VpnState {}

class VpnLoadingVpnState extends VpnState {}

class VpnLoadingSubscriptionState extends VpnState {}

class VpnReturnState extends VpnState {}

class VpnErrorState extends VpnState {}
