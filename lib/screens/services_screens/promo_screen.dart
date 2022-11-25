import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/models/firestore_user.dart';

class PromoScreen extends StatefulWidget {
  final String email;
  const PromoScreen({Key key, this.email}) : super(key: key);

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  dynamic chatDocId;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  Future<void> checkUser() async {
    await users
        .where('email', isEqualTo: widget.email)
        .limit(1)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          chatDocId = snapshot.docs.single.id;
        });
        DateTime promoTime = DateTime.now();
        final expDay = promoTime.day + 5;
        final expMonth = promoTime.month;
        final expYear = promoTime.year;
        DateTime expTime = DateTime(expYear, expMonth, expDay);
        await users.doc(chatDocId).update({
          'isPromo': true,
          'promoStartedTime': Utils.fromDateTimeToJson(DateTime.now()),
          'promoExpirationTime': Utils.fromDateTimeToJson(expTime),
        });
        print('-------chatDocId: $chatDocId');
      } else {
        await users.add({'isPromo': true}).then((value) {
          chatDocId = value;
        });
      }
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Привет, друг.\t Рады привествовать вас на нашем VPN сервисе.\tПредлагаем в качестве маленького подарка: бесплатное пользование нашего сервиса на протяжение 5 дней.\n\nУдачного дня.',
                  style: TextStyle(color: Colors.white, fontSize: 19),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, RoutesGenerator.VPN_MAIN_SCREEN);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: Colors.white,
                    ),
                    height: 70,
                    width: 300,
                    child: Center(
                        child: Text('Перейти дальше',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.w300,
                            ))),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
