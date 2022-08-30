import 'package:flutter/material.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:flutter_vpn/state.dart';

class VpnMainScreen extends StatefulWidget {
  const VpnMainScreen({Key key}) : super(key: key);

  @override
  State<VpnMainScreen> createState() => _VpnMainScreenState();
}

class _VpnMainScreenState extends State<VpnMainScreen> {
  var state = FlutterVpnState.disconnected;
  @override
  void initState() {
    FlutterVpn.prepare();
    FlutterVpn.onStateChanged.listen((s) {
      setState(() {
        state = s;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Ghost VPN',
            style: TextStyle(color: Colors.white, fontSize: 24),
          )),
      body: const Center(
        
      ),
    );
  }
}
