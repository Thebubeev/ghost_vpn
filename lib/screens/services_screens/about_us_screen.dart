import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: Center(
              child: Text(
                'Мы - команда независимых разработчиков из СНГ, специализирующаяся на разработке сервисов для организации безопасных зашифрованных интернет соединений и создания частных сетей.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
