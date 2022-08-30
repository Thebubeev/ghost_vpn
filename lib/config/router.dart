import 'package:flutter/material.dart';
import 'package:ghost_vpn/screens/main_screen.dart';
import 'package:ghost_vpn/screens/splash_start_screen.dart';
import 'package:ghost_vpn/screens/vpn_main_screen.dart';

class RoutesGenerator {
  static const MAIN = '/';
  static const SPLASH_SCREEN = 'splash_screen';
  static const VPN_MAIN_SCREEN = 'vpn_main_screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {
      case MAIN:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case SPLASH_SCREEN:
        return MaterialPageRoute(builder: (_) => const SplashStartScreen());

      case VPN_MAIN_SCREEN:
        return MaterialPageRoute(builder: (_) => const VpnMainScreen());
    }
    return MaterialPageRoute(builder: (_) => const MainScreen());
  }
}
