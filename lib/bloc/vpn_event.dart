part of 'vpn_bloc.dart';

@immutable
abstract class VpnEvent {}

class VpnInitialize extends VpnEvent {}

class VpnConnect extends VpnEvent {}

class VpnDisconnect extends VpnEvent {}
