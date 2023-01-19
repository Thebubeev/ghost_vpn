import 'package:flutter/material.dart';
import 'package:ghost_vpn/main.dart';
import 'package:ghost_vpn/screens/authentication/forget_screen.dart';
import 'package:ghost_vpn/screens/authentication/login_screen.dart';
import 'package:ghost_vpn/screens/authentication/register_screen.dart';
import 'package:ghost_vpn/screens/authentication/wrapper_screen.dart';
import 'package:ghost_vpn/screens/services_screens/promo_screen.dart';
import 'package:ghost_vpn/screens/services_screens/splash_start_screen.dart';
import 'package:ghost_vpn/screens/services_screens/toggle_screen.dart';
import 'package:ghost_vpn/screens/services_screens/subscription_screen.dart';
import 'package:ghost_vpn/screens/vpn_main_screen.dart';

class RoutesGenerator {
  static const MAIN = '/';
  static const SPLASH_SCREEN = 'splash_screen';
  static const VPN_MAIN_SCREEN = 'vpn_main_screen';
  static const TOGGLE_SCREEN = 'toggle_screen';
  static const WRAPPER = 'wrapper_screen';
  static const LOGIN = 'login_screen';
  static const REGISTER = 'register_screen';
  static const PROMO_SCREEN = 'promo_screen';
  static const SUBCRIPTION_SCREEN = 'subscription_screen';
  static const FORGET_SCREEN = 'forget_screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {
      case SPLASH_SCREEN:
        return MaterialPageRoute(builder: (_) => SplashStartScreen());

      case VPN_MAIN_SCREEN:
        return MaterialPageRoute(builder: (_) => VpnMainScreen());

      case TOGGLE_SCREEN:
        return MaterialPageRoute(builder: (_) => ToggleScreen());

      case WRAPPER:
        return MaterialPageRoute(builder: (_) => Wrapper());

      case LOGIN:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case FORGET_SCREEN:
        return MaterialPageRoute(builder: (_) => ForgetScreen());

      case PROMO_SCREEN:
        return MaterialPageRoute(
            builder: (_) => PromoScreen(
                  email: arg as String,
                ));

      case SUBCRIPTION_SCREEN:
        return MaterialPageRoute(builder: (_) => SubscriptionScreen());

      case REGISTER:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
    }
    return MaterialPageRoute(builder: (_) => MyApp());
  }
}
