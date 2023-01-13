part of 'vpn_auth_bloc.dart';

@immutable
abstract class VpnAuthState {}

class VpnAuthInitial extends VpnAuthState {}

class VpnAuthNavigatorState extends VpnAuthState {
  final String route;
  VpnAuthNavigatorState({required this.route});
}

class VpnAuthLoginToastState extends VpnAuthState {}

class VpnAuthRegisterToastState extends VpnAuthState {}

class VpnAuthRecoveryPasswordState extends VpnAuthState {}


class VpnAuthPromoDataState extends VpnAuthState {}

class VpnAuthErrorState extends VpnAuthState {
  final String warning;
  VpnAuthErrorState({required this.warning});
}
