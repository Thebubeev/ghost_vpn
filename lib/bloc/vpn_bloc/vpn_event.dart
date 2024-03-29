part of 'vpn_bloc.dart';

@immutable
abstract class VpnEvent {}

class VpnInitialize extends VpnEvent {}

class VpnConnect extends VpnEvent {
  final OpenVPN openVPN;
  
  VpnConnect({required this.openVPN});
}

class VpnDisconnect extends VpnEvent {
  final OpenVPN openVPN;
  final dynamic chatDocId;
  VpnDisconnect(
      {required this.openVPN, required this.chatDocId});
}



class VpnSubscriptionPay extends VpnEvent {
  final String title;
  final int value;
  VpnSubscriptionPay({required this.title, required this.value});
}
