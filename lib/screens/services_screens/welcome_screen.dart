import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:ghost_vpn/models/welcome_option.dart';
import 'package:ghost_vpn/screens/authentication/wrapper_screen.dart';
import 'package:ghost_vpn/services/shared_preferences_storage.dart';
import 'package:ghost_vpn/widgets/welcome_card_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final prefs = SharedPreferenceStorage();
  SwiperController _controller = SwiperController();

  @override
  void initState() {
    prefs.setWelcome(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Wrapper()));
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return WelcomeCardWidget(options: options, index: index);
        },
        controller: _controller,
        itemCount: options.length,
        pagination: SwiperPagination(
            margin: EdgeInsets.all(20), builder: SwiperPagination.dots),
        control: SwiperControl(color: Colors.black),
      ),
    );
  }

  final List<WelcomeOption> options = [
    WelcomeOption(
        title: 'Анонимность',
        subtitle: 'GhostVPN скрывает ваш реальный IP адрес в сети',
        imageUrl: 'assets/images/anonymous.png'),
    WelcomeOption(
        title: 'Безопасность',
        subtitle:
            'Будьте спокойны за свои персональные данные телефона, ведь мы зарабатываем за счет продажи тарифов, а не личной информации пользователей',
        imageUrl: 'assets/images/shield.png'),
    WelcomeOption(
        title: 'Универсальность',
        subtitle:
            'GhostVPN предлагает полный доступ ко всем ресурсам. Вы можете пользоваться всеми сайтами и приложениями без ограничений',
        imageUrl: 'assets/images/versatility.png'),
  ];
}

