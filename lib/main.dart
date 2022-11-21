import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_vpn/bloc/vpn_bloc.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VpnBloc>(create: (_)=> VpnBloc())
      ],
      child: const MaterialApp(
          onGenerateRoute: RoutesGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
          home: MainScreen()),
    );
  }
}
