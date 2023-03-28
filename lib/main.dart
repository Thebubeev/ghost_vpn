import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghost_vpn/bloc/VPN_AUTH/vpn_auth_bloc.dart';
import 'package:ghost_vpn/bloc/vpn_bloc/vpn_bloc.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/screens/services_screens/splash_start_screen.dart';
import 'package:ghost_vpn/services/local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications().initNotification();
  await Firebase.initializeApp();
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'ghost_vpn_group_key',
        channelKey: 'ghost_vpn_key',
        channelName: 'GhostVPN',
        channelDescription: 'GhostVPN',
        importance: NotificationImportance.Max,
      )
    ],
    debug: true,
  );
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
      child: MaterialApp(
          title: 'GhostVPN',
          builder: EasyLoading.init(),
          theme: ThemeData(
              primaryColor: Colors.white,
              scaffoldBackgroundColor: Colors.white54),
          onGenerateRoute: RoutesGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
          home: SplashStartScreen()),
    );
  }
}
