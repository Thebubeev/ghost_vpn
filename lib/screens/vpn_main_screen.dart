import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_vpn/bloc/vpn_bloc/vpn_bloc.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';
import 'package:ghost_vpn/widgets/container_speed_widget.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class VpnMainScreen extends StatefulWidget {
  const VpnMainScreen({Key? key}) : super(key: key);

  @override
  State<VpnMainScreen> createState() => _VpnMainScreenState();
}

class _VpnMainScreenState extends State<VpnMainScreen> {
  final auth = Auth();
  bool isConnected = false;
  bool isLoading = false;

  late OpenVPN openvpn;
  late VpnStatus? status;
  late VPNStage stage;

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
    if (!mounted) return;
    setState(() {
      status = vpnStatus;
    });
  }

  void _onVpnStageChanged(VPNStage stage, String string) {
    if (!mounted) return;
    setState(() {
      this.stage = stage;
      isLoading = true;
    });
    listenVpnStage(stage);
  }

  listenVpnStage(VPNStage vpnStage) {
    switch (vpnStage.toString()) {
      case 'VPNStage.connected':
        if (!mounted) return;
        setState(() {
          isConnected = true;
          isLoading = false;
          stringStage = 'Connected';
        });
        break;
      case 'VPNStage.disconnected':
        if (!mounted) return;
        setState(() {
          isConnected = false;
          isLoading = false;
          stringStage = 'Disconnected';
        });
        break;
      case 'VPNStage.unknown':
        if (!mounted) return;
        setState(() {
          isConnected = false;
          isLoading = false;
          stringStage = 'Error';
        });
        break;
      default:
        if (!mounted) return;
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
      listener: (context, state) async {
        if (state is VpnConnectedState) {
          if (!mounted) return;
          setState(() {
            isConnected = false;
          });
        }

        if (state is VpnDisconnectedState) {
          if (!mounted) return;
          setState(() {
            isConnected = state.isConnected;
          });
        }

        if (state is VpnExitAppState) {
          if (!mounted) return;
          setState(() {
            isConnected = state.isConnected;
          });
          await auth.signOut();
          Navigator.pushNamed(context, RoutesGenerator.WRAPPER);
          print('User is out');
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
                    if (isConnected) {
                      BlocProvider.of<VpnBloc>(context)
                          .add(VpnExitApp(openVPN: openvpn));
                    } else {
                      await auth.signOut();
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
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isConnected ? status!.duration! : '00:00:00',
                      style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 60,
                          color: Colors.white),
                    ),
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
                                color: isConnected ? Colors.red : Colors.white,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ContainerSpeedWidget(
                                  speed: status!.byteIn!,
                                  type: 'Download',
                                ),
                                ContainerSpeedWidget(
                                  speed: status!.byteOut!,
                                  type: 'Upload',
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
