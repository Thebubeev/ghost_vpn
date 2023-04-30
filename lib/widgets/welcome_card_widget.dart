import 'package:flutter/material.dart';
import 'package:ghost_vpn/models/welcome_option.dart';

class WelcomeCardWidget extends StatelessWidget {
  const WelcomeCardWidget({
    Key? key,
    required this.index,
    required this.options,
  }) : super(key: key);
  final int index;

  final List<WelcomeOption> options;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          options[index].imageUrl,
          width: 200,
          height: 300,
        ),
        SizedBox(
          height: 14,
        ),
        Text(
          options[index].title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 24),
        ),
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 7, right: 7),
          child: Text(options[index].subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 16)),
        ),
      ],
    );
  }
}
