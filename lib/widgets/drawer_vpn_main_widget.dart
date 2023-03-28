import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:ghost_vpn/config/launcher.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/models/firestore_user.dart';
import 'package:ghost_vpn/screens/services_screens/about_us_screen.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

class DrawerVpnMainWidget extends StatefulWidget {
  const DrawerVpnMainWidget({
    Key? key,
    required this.promoExpirationTime,
    required this.auth,
  }) : super(key: key);

  final Timestamp? promoExpirationTime;
  final Auth auth;

  @override
  State<DrawerVpnMainWidget> createState() => _DrawerVpnMainWidgetState();
}

class _DrawerVpnMainWidgetState extends State<DrawerVpnMainWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : Drawer(
            backgroundColor: Colors.white,
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                children: [
                  ListTile(
                    title: Text(
                      FirebaseAuth.instance.currentUser?.email ?? '',
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  widget.promoExpirationTime != null
                      ? ListTile(
                          title: Text(
                            'Дата окончания подписки: ${DateFormat.yMMMMd('ru').format(Utils.toDateTime(widget.promoExpirationTime)!)}',
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.w300),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 8,
                  ),
                  Divider(
                    thickness: 0.7,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ListTile(
                    title: Text('Поделиться'),
                    minLeadingWidth: 30,
                    leading: Icon(Icons.share),
                    onTap: () async {
                      await FlutterShare.share(
                        title: 'Поделиться',
                        linkUrl:
                            'https://play.google.com/store/apps/details?id=ghost.vpn.com',
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Тарифы'),
                    onTap: () async {
                      await Navigator.pushNamed(
                          context, RoutesGenerator.SUBCRIPTION_SCREEN);
                    },
                    minLeadingWidth: 30,
                    leading: Icon(Icons.align_horizontal_right_outlined),
                  ),
                  ListTile(
                    title: Text('Условия использования'),
                    minLeadingWidth: 30,
                    leading: Icon(Icons.book),
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await openFile();
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('О нас'),
                    minLeadingWidth: 30,
                    leading: Icon(Icons.info),
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutUsScreen()));
                    },
                  ),
                  ListTile(
                    title: Text('Поддержка'),
                    minLeadingWidth: 30,
                    onTap: () async {
                      await Launcher.launch(Uri(
                        path: 'ghostcaspervpn0001@gmail.com',
                        scheme: 'mailto',
                      ));
                    },
                    leading: Icon(Icons.help_outline_outlined),
                  ),
                ],
              ),
            ),
          );
  }

  Future openFile() async {
    final path = await widget.auth.getFirebaseDocuments(
        'пользовательское_соглашение', 'pdf', 'documents');
    await OpenFilex.open(path);
  }
}
