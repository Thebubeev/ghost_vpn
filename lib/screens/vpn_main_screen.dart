import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_vpn/bloc/vpn_bloc.dart';
import 'package:ghost_vpn/screens/subscription_screen.dart';
import 'package:ghost_vpn/widgets/container_speed_widget.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class VpnMainScreen extends StatefulWidget {
  const VpnMainScreen({Key? key}) : super(key: key);

  @override
  State<VpnMainScreen> createState() => _VpnMainScreenState();
}

class _VpnMainScreenState extends State<VpnMainScreen> {
  bool isConnected = false;
  bool isLoading = false;

  late OpenVPN openvpn;
  VpnStatus? status;
  VPNStage? stage;

  String stringStage = 'disconnected';

  @override
  void initState() {
    openvpn = OpenVPN(
        onVpnStatusChanged: _onVpnStatusChanged,
        onVpnStageChanged: _onVpnStageChanged);
    openvpn.initialize(
        groupIdentifier: "group.com.ghost.vpn",
        providerBundleIdentifier: "id.ghost.openvpnFlutterExample.VPNExtension",
        localizedDescription: "Ghost VPN");
    super.initState();
  }

  void _onVpnStatusChanged(VpnStatus? vpnStatus) {
    setState(() {
      status = vpnStatus;
    });
  }

  void _onVpnStageChanged(VPNStage? stage, String string) {
    setState(() {
      this.stage = stage;
      isLoading = true;
    });
    listenVpnStage(stage);
  }

  listenVpnStage(VPNStage? vpnStage) {
    switch (vpnStage.toString()) {
      case 'VPNStage.connected':
        setState(() {
          isConnected = true;
          isLoading = false;
          stringStage = 'Connected';
        });
        break;
      case 'VPNStage.disconnected':
        setState(() {
          isConnected = false;
          isLoading = false;
          stringStage = 'Disconnected';
        });
        break;
      case 'VPNStage.unknown':
        setState(() {
          isConnected = false;
          isLoading = false;
          stringStage = 'Error';
        });
        break;
      default:
        setState(() {
          isLoading = true;
          stringStage = 'Loading...';
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VpnBloc, VpnState>(
      listener: (context, state) {
        if (state is VpnConnectedState) {
          setState(() {
            isConnected = false;
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
            resizeToAvoidBottomInset: false,
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
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 90),
                          child: Text(
                            isConnected ? status!.duration! : '00:00:00',
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 50,
                                color: Colors.white),
                          )),
                      const SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          isConnected
                              ? BlocProvider.of<VpnBloc>(context)
                                  .add(VpnDisconnect(openVPN: openvpn))
                              : BlocProvider.of<VpnBloc>(context)
                                  .add(VpnConnect(openVPN: openvpn));
                        },
                        child: Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(150),
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      isConnected ? Colors.red : Colors.white,
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
                                          isLoading
                                              ? 'LOADING'
                                              : isConnected
                                                  ? 'STOP'
                                                  : "START",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 23,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                      ],
                                    )))),
                      ),
                      isConnected
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ContainerSpeedWidget(
                                    speed: status!.byteIn,
                                    type: 'Download',
                                  ),
                                  ContainerSpeedWidget(
                                    speed: status!.byteOut,
                                    type: 'Upload',
                                  ),
                                ],
                              ),
                            )
                          : Container(),
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
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 5),
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
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
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

