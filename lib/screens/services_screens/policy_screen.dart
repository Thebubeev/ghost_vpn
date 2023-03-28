import 'package:flutter/material.dart';
import 'package:ghost_vpn/screens/services_screens/welcome_screen.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';
import 'package:ghost_vpn/widgets/loader_widget.dart';
import 'package:open_filex/open_filex.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({Key? key}) : super(key: key);

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  bool isLoading = false;
  AuthBase auth = Auth();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.black,
          body: isLoading
              ? LoaderWidget()
              : SafeArea(
                  child: ListView(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 25, right: 25, top: 15),
                        child: Center(
                          child: Text(
                            'Мы ценим вашу конфиденциальность',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 25, right: 25, top: 10),
                        child: Text(
                          '''
                  \nЭто приложение собирает ограниченный объем данных, чтобы предоставить вам быстрый и надежный VPN-сервис.
                  \nВот несколько примеров того, какую информацию мы собираем, когда вы используете это приложение:
                  \n1. Информация об устройстве, такая как версия операционной системы, модель оборудования и IP-адрес, для оптимизации сетевого подключения и предоставления высококачественных услуг.
                  \n1. Агрегированные анонимные данные об активности для проведения аналитики в нашем сервисе, обмена информацией об использовании приложений и обеспечения безопасного доступа к определенным веб-сайтам и приложениям.
                  \n3. Общая потребляемая пропускная способность и продолжительность подключения к нашему VPN-сервису.
                  \n4. Платежные реквизиты и (необязательно) адрес электронной почты при покупке платного плана. 
                  \nПолную информацию о собранных данных и способах их обработки можно найти в нашей Политике конфиденциальности.
                          ''',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Center(
                        child: TextButton(
                            onPressed: () => openFile(),
                            child: Text(
                              'Политика конфиденциальности',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => WelcomeScreen())));
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
                      ),
                    ],
                  ),
                )),
    );
  }

  Future openFile() async {
    setState(() {
      isLoading = true;
    });
    final path = await auth.getFirebaseDocuments(
        'политика_конфиденциальности_для', 'pdf', 'documents');
    OpenFilex.open(path);
    setState(() {
      isLoading = false;
    });
  }
}
