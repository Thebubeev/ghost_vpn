import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ghost_vpn/bloc/vpn_bloc.dart';
import 'package:ghost_vpn/screens/subscription_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:flutter_vpn/state.dart';

class VpnMainScreen extends StatefulWidget {
  const VpnMainScreen({Key key}) : super(key: key);

  @override
  State<VpnMainScreen> createState() => _VpnMainScreenState();
}

class _VpnMainScreenState extends State<VpnMainScreen> {
  FlutterVpnState currentState = FlutterVpnState.disconnected;

  bool isLoading = false;
  bool isConnected = false;
  Stream streamTime =
      Stream.periodic(const Duration(seconds: 1)).asBroadcastStream();

  @override
  void initState() {
    BlocProvider.of<VpnBloc>(context).add(VpnInitialize());
    super.initState();
  }

  void operateVPN() {
    if (currentState == FlutterVpnState.connected) {
      BlocProvider.of<VpnBloc>(context).add(VpnDisconnect());
    } else {
      BlocProvider.of<VpnBloc>(context).add(VpnConnect());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VpnBloc, VpnState>(
      listener: (context, state) {
        if (state is VpnDataState) {
          setState(() {
            currentState = state.flutterVpnState;
          });
        }

        if (state is VpnConnectedState) {
          setState(() {
            isConnected = state.isConnected;
          });
        }

        if (state is VpnDisconnectedState) {
          setState(() {
            isConnected = state.isConnected;
          });
        }
      },
      child: Stack(
        children: [
          Image.asset(
            'assets/icons/back_image.jpg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () async {
                      await showGeneralDialog(
                          context: context,
                          pageBuilder: (context, animation, _) {
                            return const SubscriptionScreen();
                          });
                    },
                    icon: const Icon(
                      Icons.vertical_distribute_sharp,
                      color: Colors.white,
                    ))
              ],
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: const TextSpan(
                        text: 'Ghost',
                        style: TextStyle(color: Colors.grey, fontSize: 25),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'VPN',
                              style: TextStyle(color: Colors.white))
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
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: StreamBuilder(
                        stream: streamTime,
                        builder: (context, snapshot) {
                          return Text(
                            DateFormat('kk:mm:ss').format(DateTime.now()),
                            style: const TextStyle(
                                fontSize: 45, color: Colors.white),
                          );
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      isConnected ? 'connected' : 'disconnected',
                      style: TextStyle(
                        color: isConnected ? Colors.green : Colors.red,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isLoading ? 0 : 40,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      isLoading
                          ? const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: SpinKitSpinningLines(
                                color: Colors.white,
                                size: 190,
                              ),
                            )
                          : Container(),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });

                          await Future.delayed(const Duration(seconds: 3))
                              .then((_) async {
                            operateVPN();
                            setState(() {
                              isLoading = false;
                            });
                          });
                        },
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isConnected ? Colors.green : Colors.red,
                          ),
                          child: Center(
                            child: Icon(
                              isConnected
                                  ? Icons.power_settings_new
                                  : Icons.power_settings_new_rounded,
                              size: 65,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: DraggableScrollableSheet(
                      minChildSize: 0.30,
                      maxChildSize: 0.60,
                      initialChildSize: 0.30,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 41, 41, 40),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(45),
                                topLeft: Radius.circular(45),
                              )),
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: 7,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 5),
                                  child: Divider(
                                    indent: 140,
                                    endIndent: 140,
                                    thickness: 5.0,
                                    color: Colors.black,
                                  ),
                                );
                              }
                              return ListTile(
                                title: const Text(
                                  'Амстердам 141.0.12.142',
                                  style: TextStyle(color: Colors.white),
                                ),
                                leading: Image.asset(
                                  'assets/flags/net.png',
                                  fit: BoxFit.cover,
                                  width: 35,
                                  height: 35,
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      ),
                                    )),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
