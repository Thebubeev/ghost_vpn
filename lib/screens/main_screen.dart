import 'package:flutter/material.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/services/shared_preferences_storage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final prefs = SharedPreferenceStorage();
  @override
  void initState() {
    prefs.getWelcome().then((value) {
        Navigator.pushReplacementNamed(context, RoutesGenerator.SPLASH_SCREEN);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
