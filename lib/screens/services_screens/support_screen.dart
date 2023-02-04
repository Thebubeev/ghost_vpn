import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ghost_vpn/config/launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton(
          child: Text(
            'Telegram',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          onPressed: () async {
            await Launcher.launch('');
          },
        ),
        Text(
          'Email',
          style: TextStyle(color: Colors.white, fontSize: 25),
        )
      ]),
    );
  }
}
