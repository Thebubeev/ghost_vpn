import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'vpn_auth_event.dart';
part 'vpn_auth_state.dart';

class VpnAuthBloc extends Bloc<VpnAuthEvent, VpnAuthState> {
  VpnAuthBloc() : super(VpnAuthInitial()) {
    on<VpnAuthEvent>((event, emit) {
      // TODO: implement event handler
    });

  }
}
