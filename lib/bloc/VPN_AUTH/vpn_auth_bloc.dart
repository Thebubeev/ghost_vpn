import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/models/firestore_user.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';

part 'vpn_auth_event.dart';
part 'vpn_auth_state.dart';

class VpnAuthBloc extends Bloc<VpnAuthEvent, VpnAuthState> {
  final _firebaseAuth = FirebaseAuth.instance;
  final auth = Auth();
  VpnAuthBloc() : super(VpnAuthInitial()) {
    on<VpnSendPromoData>((event, emit) async {
      try {
        DateTime promoTime = DateTime.now();
        final expDay = promoTime.day + 6;
        final expMonth = promoTime.month;
        final expYear = promoTime.year;
        DateTime expTime = DateTime(expYear, expMonth, expDay);
        await event.collection.doc(event.chatDocId).update({
          'isPromo': '2',
          'promoStartedTime': Utils.fromDateTimeToJson(promoTime),
          'promoExpirationTime': Utils.fromDateTimeToJson(expTime),
        });
        emit(VpnAuthPromoDataState());
      } catch (e) {
        print(e.toString());
        emit(VpnAuthErrorState(warning: 'Что-то прошло не так...'));
      }
    });
    on<VpnLoginWithGoogleEvent>((event, emit) async {
      try {
        await auth.signInWithGoogle().then((value) {
          if (value.uid != null) {
            emit(VpnAuthNavigatorState(route: RoutesGenerator.SPLASH_SCREEN));
          }
        });
      } catch (e) {
        print(e.toString());
        emit(VpnAuthErrorState(warning: 'Что-то прошло не так...'));
      }
    });
    on<VpnForgotPasswordEvent>((event, emit) async {
      try {
        await auth.resetPasswordUsingEmail(event.login.trim());
        emit(VpnAuthRecoveryPasswordState());
      } catch (error) {
        String _warning = 'Что-то прошло не так...';
        switch (error.toString()) {
          case "[firebase_auth/invalid-email] The email address is badly formatted.":
            _warning = "Ваша почта недоступна.";
            break;
          case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
            _warning = "Такого пользователя не существует!";
            break;
          case "[firebase_auth/invalid-email] The email address is badly formatted.":
            _warning = "Ваша почта недоступна.";
            break;
          case "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.":
            _warning = "Слишком много запросов. Попробуйте позже.";
            break;
          case "[firebase_auth/unknown] Given String is empty or null":
            _warning = '[firebase_auth/unknown] Given String is empty or null';
            break;
        }
        print(error);
        emit(VpnAuthErrorState(warning: _warning));
      }
    });
    on<VpnRegisterEvent>((event, emit) async {
      try {
        await auth.createUserWithEmailAndPassword(
          event.login.trim(),
          event.password.trim(),
        );
        emit(VpnAuthRegisterToastState());
      } catch (error) {
        String _warning = 'Что-то прошло не так...';
        switch (error.toString()) {
          case "[firebase_auth/invalid-email] The email address is badly formatted.":
            _warning = "Ваша почта недоступна.";

            break;
          case "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.":
            _warning = "Слишком много запросов. Попробуйте позже.";

            break;
          case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
            _warning = "Данная почта уже зарегистрирована.";

            break;
          case "[firebase_auth/unknown] Given String is empty or null":
            _warning = '[firebase_auth/unknown] Given String is empty or null';

            break;
        }
        print(error);
        emit(VpnAuthErrorState(warning: _warning));
      }
    });
    on<VpnLoginEvent>((event, emit) async {
      try {
        await auth
            .signInWithEmailAndPassword(
                event.login.trim(), event.password.trim())
            .then((_) async => _firebaseAuth.currentUser!.emailVerified
                ? emit(
                    VpnAuthNavigatorState(route: RoutesGenerator.SPLASH_SCREEN))
                : {emit(VpnAuthLoginToastState())});
      } catch (error) {
        String _warning = 'Что-то прошло не так...';
        switch (error.toString()) {
          case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
            _warning = "Такого пользователя не существует!";

            break;
          case "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.":
            _warning = "Слишком много запросов. Попробуйте позже!";

            break;
          case "[firebase_auth/invalid-email] The email address is badly formatted.":
            _warning = _firebaseAuth.currentUser!.emailVerified
                ? "Почта недоступна."
                : 'Мы отправили письмо . Пожалуйста, подтвердите вашу почту.';

            _firebaseAuth.currentUser!.emailVerified
                ? null
                : await auth.sendVerificationEmail();
            break;
          case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
            _warning = "Логин или пароль неверный.";

            break;
          case "[firebase_auth/unknown] Given String is empty or null":
            _warning = '[firebase_auth/unknown] Given String is empty or null';
            break;
        }
        print(error);
        emit(VpnAuthErrorState(warning: _warning));
      }
    });
  }
}
