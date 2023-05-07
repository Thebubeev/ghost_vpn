import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_vpn/bloc/VPN_AUTH/vpn_auth_bloc.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/widgets/loader_widget.dart';
import 'package:ghost_vpn/widgets/widget.dart';

class PromoScreen extends StatefulWidget {
  final String? email;
  const PromoScreen({Key? key, this.email}) : super(key: key);

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  dynamic chatDocId;

  bool _isLoading = false;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  @override
  void dispose() {
    if (!mounted) return;
    super.dispose();
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
        print('-------chatDocId: $chatDocId');
      } else {
        await users.add({'isPromo': '1'}).then((value) {
          chatDocId = value;
        });
      }
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VpnAuthBloc, VpnAuthState>(
      listener: (context, state) {
        if (state is VpnAuthPromoDataState) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamed(context, RoutesGenerator.VPN_MAIN_SCREEN);
        }

        if (state is VpnAuthErrorState) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isLoading
            ? LoaderWidget()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, bottom: 20),
                        child: Text(
                          'Привет, друг!\nРады привествовать тебя на нашем VPN сервисе.\nПредлагаем в качестве маленького подарка: бесплатное использование нашего сервиса на протяжение 5 дней.\nУдачного дня!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLoading = true;
                            });
                            BlocProvider.of<VpnAuthBloc>(context).add(
                                VpnSendPromoData(
                                    chatDocId: chatDocId, collection: users));
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
      ),
    );
  }
}
