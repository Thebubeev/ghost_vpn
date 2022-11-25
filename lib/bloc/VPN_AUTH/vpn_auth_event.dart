part of 'vpn_auth_bloc.dart';

@immutable
abstract class VpnAuthEvent {}

class VpnLoginEvent extends VpnAuthEvent {}

class VpnRegisterEvent extends VpnAuthEvent {}

class VpnLoginWithGoogleEvent extends VpnAuthEvent {}

class VpnForgotPassEvent extends VpnAuthEvent {}
