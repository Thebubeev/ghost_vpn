import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_vpn/bloc/VPN_AUTH/vpn_auth_bloc.dart';
import 'package:ghost_vpn/bloc/vpn_bloc/vpn_bloc.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/screens/services_screens/splash_start_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VpnBloc>(create: (_) => VpnBloc()),
        BlocProvider<VpnAuthBloc>(create: (_) => VpnAuthBloc())
      ],
      child: const MaterialApp(
          onGenerateRoute: RoutesGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
          home: SplashStartScreen()),
    );
  }
}
