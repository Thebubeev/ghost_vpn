import 'package:flutter/material.dart';
import 'package:ghost_vpn/widgets/subscription_card_buy_widget.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ListView(
          children: const [
            SubscriptionCardBuyWidget(
              label: 'VPN на месяц\n150 ₽',
              imagePath: 'assets/images/month_subscription.jpg',
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
            SubscriptionCardBuyWidget(
              label: 'VPN на 6 месяцев\n600 ₽',
              imagePath: 'assets/images/half_year_subscription.jpg',
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
            SubscriptionCardBuyWidget(
              label: 'VPN на год\n1 000 ₽',
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
          ],
        ),
      ),
    );
  }
}
