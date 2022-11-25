import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ghost_vpn/models/firestore_user.dart';
import 'package:ghost_vpn/screens/authentication/wrapper_screen.dart';
import 'package:ghost_vpn/screens/services_screens/expiration_screen.dart';
import 'package:ghost_vpn/screens/services_screens/promo_screen.dart';
import 'package:ghost_vpn/screens/vpn_main_screen.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';

class ToggleScreen extends StatefulWidget {
  @override
  State<ToggleScreen> createState() => _ToggleScreenState();
}

class _ToggleScreenState extends State<ToggleScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final auth = Auth();
  final _firebaseAuth = FirebaseAuth.instance;
  Timer timer;
  bool isEmailVerified;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  dynamic chatDocId;

  bool isPromo;
  bool isPaid;
  bool isTimetoPay = false;

  bool isEmptyData;

  Timestamp promoExpirationTime;

  @override
  void initState() {
    super.initState();
    checkFields();
    isEmailVerified = _firebaseAuth.currentUser?.emailVerified;
    if (isEmailVerified == null) {
      return null;
    } else if (!isEmailVerified) {
      timer = Timer.periodic(Duration(seconds: 5), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkFields() async {
    await users.snapshots().listen((event) {
      if (event.docs.isEmpty) {
        setState(() {
          isEmptyData = true;
        });
      } else {
        print('data is not empty');
      }
    });
    await users
        .where('email', isEqualTo: 'bubeevm@gmail.com')
        .limit(1)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          promoExpirationTime = snapshot.docs.single.get('promoExpirationTime');
          isPaid = snapshot.docs.single.get('isPaid');
          isPromo = snapshot.docs.single.get('isPromo');
          isTimetoPay = getTimetoPay();
        });
      }
    }).catchError((error) {});
  }

  bool getTimetoPay() {
    DateTime expTime = Utils.toDateTime(promoExpirationTime);
    return expTime.isAfter(DateTime.now());
  }

  Future checkEmailVerified() async {
    await _firebaseAuth.currentUser?.reload();
    isEmailVerified = _firebaseAuth.currentUser?.emailVerified;
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Text('Error ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final email = snapshot.data?.email;
                  if (isEmailVerified == false || isEmailVerified == null) {
                    return Wrapper();
                  } else if (isEmailVerified &&
                      isPromo == false &&
                      isTimetoPay == false) {
                    return PromoScreen(
                      email: email,
                    );
                  } else if (isPromo == null) {
                    return Center(child: CircularProgressIndicator());
                  } else if (isEmptyData == true) {
                    return Center(child: CircularProgressIndicator());
                  } else if (isTimetoPay && isEmailVerified && isPromo) {
                    return ExpirationScreen();
                  } else if (isEmailVerified && isPromo) {
                    return VpnMainScreen();
                  }
                }
                return Center(child: CircularProgressIndicator());
              });
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
