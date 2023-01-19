import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ghost_vpn/models/firestore_user.dart';
import 'package:ghost_vpn/screens/services_screens/expiration_screen.dart';
import 'package:ghost_vpn/screens/services_screens/toggle_screen.dart';
import 'package:ghost_vpn/services/shared_preferences_storage.dart';

class SplashStartScreen extends StatefulWidget {
  const SplashStartScreen({Key? key}) : super(key: key);

  @override
  State<SplashStartScreen> createState() => _SplashStartScreenState();
}

class _SplashStartScreenState extends State<SplashStartScreen> {
  final prefs = SharedPreferenceStorage();
  Timer? timer;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Timestamp? promoExpirationTime;
  bool isTimetoPay = false;
  @override
  void initState() {
    init();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkFields();
    });
    super.initState();
  }

  Future checkFields() async {
    await users
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .limit(1)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        setState(() async {
          if (!mounted) return;
          promoExpirationTime = snapshot.docs.single.get('promoExpirationTime');
          isTimetoPay = await getTimeToPay(snapshot.docs.single.id);
          if (isTimetoPay) {
            timer?.cancel();
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => ExpirationScreen())));
          }
        });
      }
    }).catchError((error) {});
  }

  Future<bool> getTimeToPay(dynamic doc) async {
    final expTime = Utils.toDateTime(promoExpirationTime);
    final isInnerTimeToPay = expTime!.isBefore(DateTime.now());
    return isInnerTimeToPay;
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
