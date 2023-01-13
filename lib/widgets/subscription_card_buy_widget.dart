import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_vpn/bloc/vpn_bloc/vpn_bloc.dart';

class SubscriptionCardBuyWidget extends StatelessWidget {
  final String title;
  final int value;
  final String subtitle;
  final String imagePath;
  final String text;
  final String textButton;
  final bool isBackButton;
  const SubscriptionCardBuyWidget({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.imagePath,
    required this.text,
    required this.textButton,
    required this.isBackButton,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isBackButton
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subtitle,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w300),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                            size: 26,
                          )),
                    ],
                  )
                : Text(
                    subtitle,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w300),
                  ),
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 200,
              width: 200,
            ),
            Text(
              text,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.white),
                onPressed: () {
                  BlocProvider.of<VpnBloc>(context)
                      .add(VpnSubscriptionPay(title: title, value: value));
                  
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.black,
                ),
                label: Text(
                  textButton,
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
