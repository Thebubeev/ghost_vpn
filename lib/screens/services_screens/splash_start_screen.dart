import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ghost_vpn/screens/services_screens/policy_screen.dart';
import 'package:ghost_vpn/screens/services_screens/toggle_screen.dart';
import 'package:ghost_vpn/services/shared_preferences_storage.dart';

class SplashStartScreen extends StatefulWidget {
  const SplashStartScreen({Key? key}) : super(key: key);

  @override
  State<SplashStartScreen> createState() => _SplashStartScreenState();
}

class _SplashStartScreenState extends State<SplashStartScreen> {
  final prefs = SharedPreferenceStorage();
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/ghostvpn-ea207.appspot.com/o/documents%2F%D0%B2%D0%B5%D0%B1%20%D0%B8%D0%BA%D0%BE%D0%BD%D0%BA%D0%B0.jpg?alt=media&token=212b0652-12fb-428a-83a6-1697608d4da4',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 3)).then((_) async {
      if (await prefs.getWelcome() == false ||
          await prefs.getWelcome() == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => PolicyScreen()));
      } else if (await prefs.getWelcome() == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ToggleScreen()));
      }
    });
  }
}
