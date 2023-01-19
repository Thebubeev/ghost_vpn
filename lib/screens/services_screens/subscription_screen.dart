import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_vpn/bloc/vpn_bloc/vpn_bloc.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/models/payments_option.dart';
import 'package:ghost_vpn/screens/services_screens/splash_start_screen.dart';
import 'package:ghost_vpn/screens/services_screens/toggle_screen.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';
import 'package:ghost_vpn/widgets/loader_widget.dart';
import 'package:ghost_vpn/widgets/subscription_card_buy_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool isLoading = false;
  final auth = Auth();
  @override
  Widget build(BuildContext context) {
    return BlocListener<VpnBloc, VpnState>(
      listener: (context, state) async {
        if (state is VpnLoadingState) {
          setState(() {
            isLoading = true;
          });
        }

        if (state is VpnReturnState) {
          setState(() {
            isLoading = false;
          });
        }

        if (state is VpnSubscriptionPaidState) {
          setState(() {
            isLoading = false;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => SplashStartScreen())));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: isLoading
            ? LoaderWidget()
            : Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return SubscriptionCardBuyWidget(
                        title: options[index].title,
                        subtitle: options[index].subtitle,
                        imagePath: options[index].imagePath,
                        value: options[index].value,
                        text: options[index].text,
                        textButton: options[index].textButton,
                        isBackButton: options[index].isBackButton);
                  },
                )),
      ),
    );
  }
}

List<PaymentsOption> options = [
  PaymentsOption(
    title: 'Подписка на месяц',
    subtitle: 'VPN на месяц\n150 ₽',
    imagePath: 'assets/images/month_subscription.jpg',
    value: 150,
    text: ''' 
Данный продукт позволяет вам беспрепятственности пользоваться Instagram, Telegram, VK, YouTube и другими популярными сервисами😎

Для подключения необходимо написать продавцу😉

Далее вы получите:
✅ инструкцию для подключения
✅ персональный ключ
✅ 5 дня бесплатного пользования для проверки качества товара
          ''',
    textButton: 'Оформить подписку на месяц',
    isBackButton: true,
  ),
  PaymentsOption(
    title: 'Подписка на полгода',
    subtitle: 'VPN на 6 месяцев\n600 ₽',
    imagePath: 'assets/images/half_year_subscription.jpg',
    value: 600,
    text: ''' 
Данный продукт позволяет вам беспрепятственности пользоваться Instagram, Telegram, VK, YouTube и другими популярными сервисами😎

Для подключения необходимо написать продавцу😉

Далее вы получите:
✅ инструкцию для подключения
✅ персональный ключ
✅ 5 дня бесплатного пользования для проверки качества товара
          ''',
    textButton: 'Оформить подписку на полгода',
    isBackButton: false,
  ),
  PaymentsOption(
    title: 'Подписка на год',
    subtitle: 'VPN на год\n1 000 ₽',
    value: 1000,
    imagePath: 'assets/images/year_subscription.jpg',
    text: ''' 
Данный продукт позволяет вам беспрепятственности пользоваться Instagram, Telegram, VK, YouTube и другими популярными сервисами😎

Для подключения необходимо написать продавцу😉

Далее вы получите:
✅ инструкцию для подключения
✅ персональный ключ
✅ 5 дня бесплатного пользования для проверки качества товара
          ''',
    textButton: 'Оформить подписку на год',
    isBackButton: false,
  ),
];
