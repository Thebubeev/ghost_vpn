import 'package:flutter/material.dart';
import 'package:ghost_vpn/screens/services_screens/toggle_screen.dart';
import 'package:ghost_vpn/services/shared_preferences_storage.dart';

class SplashStartScreen extends StatefulWidget {
  const SplashStartScreen({Key key}) : super(key: key);

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
    return Center(
      child: Image.network(
        'https://sun9-11.userapi.com/impg/W9sRZAbJXfNiqtttTLXDt_BHo-iUcrPNVyrPww/VZMibi2CG1s.jpg?size=1077x1077&quality=95&sign=f4b2f1445e1ae54c1600dae1fe8d1f22&type=album',
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 3)).then((_) {
      prefs.setWelcome(true);
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => ToggleScreen())));
    });
  }
}
