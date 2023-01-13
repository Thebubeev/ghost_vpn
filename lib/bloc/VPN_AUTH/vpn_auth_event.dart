part of 'vpn_auth_bloc.dart';

@immutable
abstract class VpnAuthEvent {}

class VpnLoginEvent extends VpnAuthEvent {
  final String login;
  final String password;
  VpnLoginEvent({required this.login, required this.password});
}

class VpnSendPromoData extends VpnAuthEvent {
  final dynamic chatDocId;
  final CollectionReference collection;
  VpnSendPromoData({required this.chatDocId, required this.collection});
}

class VpnRegisterEvent extends VpnAuthEvent {
  final String login;
  final String password;
  VpnRegisterEvent({required this.login, required this.password});
}

class VpnLoginWithGoogleEvent extends VpnAuthEvent {}

class VpnForgotPasswordEvent extends VpnAuthEvent {
  final String login;
  VpnForgotPasswordEvent({required this.login});
}
