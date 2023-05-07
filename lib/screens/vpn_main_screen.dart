import 'dart:async';
import 'package:cladvpn_service/openvpn_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ghost_vpn/bloc/vpn_bloc/vpn_bloc.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/models/firestore_user.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';
import 'package:ghost_vpn/services/local_notifications.dart';
import 'package:ghost_vpn/widgets/container_speed_widget.dart';
import 'package:ghost_vpn/widgets/drawer_vpn_main_widget.dart';
import 'package:intl/date_symbol_data_local.dart';

class VpnMainScreen extends StatefulWidget {
  const VpnMainScreen({Key? key}) : super(key: key);

  @override
  State<VpnMainScreen> createState() => _VpnMainScreenState();
}

class _VpnMainScreenState extends State<VpnMainScreen> {
  final auth = Auth();
  bool isConnected = false;

  late OpenVPN openvpn;
  late VpnStatus? status;
  late VPNStage stage;

  String stringStage = 'СТАРТ';
  dynamic chatDocConfigId;

  Timer? timer;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Timestamp? promoExpirationTime;
  bool isTimetoPay = false;
  CollectionReference collectionReference_configs =
      FirebaseFirestore.instance.collection('configs');

  bool isLoading = false;

  @override
  void initState() {
    initializeDateFormatting();
    checkPromoExpirationTime();
    timer = Timer.periodic(Duration(seconds: 50), (timer) async {
      await checkFields();
    });
    openvpn = OpenVPN(
        onVpnStatusChanged: _onVpnStatusChanged,
        onVpnStageChanged: _onVpnStageChanged);
    openvpn.initialize(
        groupIdentifier: "group.com.ghost.vpn",
        providerBundleIdentifier: "id.ghost.openvpnFlutterExample.VPNExtension",
        localizedDescription: "Ghost VPN");

    super.initState();
  }

  Future checkPromoExpirationTime() async {
    await users
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          promoExpirationTime = snapshot.docs.single.get('promoExpirationTime');
        });
      }
    });
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
          if (isTimetoPay && FirebaseAuth.instance.currentUser != null) {
            await LocalNotifications().showNotification(context);
            timer?.cancel();
            await users.doc(snapshot.docs.single.id).update({'isPromo': '1'});
            Navigator.pushNamed(context, RoutesGenerator.SPLASH_SCREEN);
          }
        });
      }
    }).catchError((error) {});
  }

  Future<bool> getTimeToPay(dynamic doc) async {
    final expTime = Utils.toDateTime(promoExpirationTime);
    final isInnerTimeToPay = DateTime.now().isAfter(expTime!);
    return isInnerTimeToPay;
  }

  void _onVpnStatusChanged(VpnStatus? vpnStatus) {
    if (!mounted) return;
    setState(() {
      status = vpnStatus;
    });
  }

  void _onVpnStageChanged(VPNStage stage, String string) {
    if (!mounted) return;
    setState(() {
      this.stage = stage;
    });
    listenVpnStage(stage);
  }

  listenVpnStage(VPNStage vpnStage) async {
    switch (vpnStage.toString()) {
      case 'VPNStage.connected':
        if (!mounted) return;
        setState(() {
          isConnected = true;
          stringStage = 'СТОП';
        });
        break;
      case 'VPNStage.disconnected':
        if (!mounted) return;
        setState(() {
          isConnected = false;
          stringStage = 'СТАРТ';
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VpnBloc, VpnState>(
      listener: (context, state) async {
        if (state is VpnLoadingVpnState) {
          if (!mounted) return;
          await EasyLoading.show(
              status: "Загрузка", maskType: EasyLoadingMaskType.black);
        }

        if (state is VpnConnectedState) {
          if (!mounted) return;
          setState(() {
            stringStage = 'СТОП';
            isConnected = true;
            chatDocConfigId = state.chatDocId;
          });

          await Future.delayed(Duration(seconds: 4)).then((_) {
            EasyLoading.showSuccess('Все прошло успешно!');
          });
        }

        if (state is VpnDisconnectedState) {
          if (!mounted) return;
          setState(() {
            stringStage = 'СТАРТ';
            isConnected = false;
          });
        }
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Stack(
          children: [
            Image.asset(
              'assets/icons/back_image.jpg',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Scaffold(
              drawer: DrawerVpnMainWidget(
                  promoExpirationTime: promoExpirationTime, auth: auth),
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () async {
                      if (isConnected) {
                        EasyLoading.showInfo('Отключите ВПН!');
                      } else {
                        await auth.signOut();
                        timer?.cancel();
                        Navigator.pushNamed(context, RoutesGenerator.WRAPPER);
                        print('User is out');
                      }
                    },
                    icon: Icon(
                      Icons.exit_to_app_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'Ghost',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              fontSize: 25),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'VPN',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Image.asset(
                          'assets/icons/icon.jpg',
                          fit: BoxFit.cover,
                          height: 30,
                          width: 30,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              body: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 190),
                        child: Text(
                          isConnected ? status!.duration! : "00:00:00",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () async {
                            isConnected
                                ? {
                                    BlocProvider.of<VpnBloc>(context).add(
                                        VpnDisconnect(
                                            openVPN: openvpn,
                                            chatDocId: chatDocConfigId))
                                  }
                                : {
                                    openvpn.requestPermissionAndroid(),
                                    BlocProvider.of<VpnBloc>(context)
                                        .add(VpnConnect(
                                      openVPN: openvpn,
                                    ))
                                  };
                          },
                          child: Material(
                              elevation: 3,
                              borderRadius: BorderRadius.circular(150),
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                      height: 140,
                                      width: 140,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.power_settings_new,
                                            size: 34,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            stringStage,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 23,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                        ],
                                      )))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ContainerSpeedWidget(
                              isDownload: true,
                              speed: isConnected ? status!.byteIn! : "0",
                              type: 'Скачано',
                            ),
                            ContainerSpeedWidget(
                              isDownload: false,
                              speed: isConnected ? status!.byteOut! : "0",
                              type: 'Загружено',
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
