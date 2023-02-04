import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_vpn/bloc/vpn_bloc/vpn_bloc.dart';

class SubscriptionCardBuyWidget extends StatelessWidget {
  final String title;
  final int value;
  final String subtitle;
  final String imagePath;
  const SubscriptionCardBuyWidget({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.imagePath,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w300),
            ),
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<VpnBloc>(context)
                    .add(VpnSubscriptionPay(title: title, value: value));
              },
              child: Text(
                'Оформить подписку',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
