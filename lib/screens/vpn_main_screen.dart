import 'package:flutter/material.dart';

class VpnMainScreen extends StatefulWidget {
  const VpnMainScreen({Key? key}) : super(key: key);

  @override
  State<VpnMainScreen> createState() => _VpnMainScreenState();
}

class _VpnMainScreenState extends State<VpnMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('this is vpn main screen'),
      ),
    );
  }
}
