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
  VpnDisconnect({required this.openVPN});
}
