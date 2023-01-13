import 'dart:convert';
import 'package:ghost_vpn/models/yokassa_payment.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

mixin Constants {
  static const secretKey = "test_bIliC6BtVBR9nsRORMoysSSfwOSKbjLffnF8Qth505g";
  static const secretMobileKey =
      "test_OTY0NzY2f_SIZ3JMqHPYfAT-Zwo6BP0u12Ns0orep0c";
  static const shopId = '964766';
  static const clientId = '11q73cqv3htff22k0md92f3otk8apnel';
}

class YokassaApi {
  Future<YokassaPayment?> checkYokassaPayment(String token) async {
    final credentials =
        '964766:test_bIliC6BtVBR9nsRORMoysSSfwOSKbjLffnF8Qth505g';

    String basicAuth = 'Basic ' + base64.encode(utf8.encode(credentials));

    final response = await http.get(
      Uri.parse("https://api.yookassa.ru/v3/payments/$token"),
      headers: <String, String>{'Authorization': basicAuth},
    );
    if (response.statusCode == 200) {
      return YokassaPayment.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
    }
    return null;
  }

  Future<YokassaPayment?> makeYokassaPayment(
      String token, String descriptionOfOrder, String value) async {
    final credentials =
        '964766:test_bIliC6BtVBR9nsRORMoysSSfwOSKbjLffnF8Qth505g';

    String basicAuth = 'Basic ' + base64.encode(utf8.encode(credentials));

    final response =
        await http.post(Uri.parse("https://api.yookassa.ru/v3/payments"),
            headers: <String, String>{
              'content-type': 'application/json',
              'Idempotence-Key': Uuid().v4(),
              'Authorization': basicAuth
            },
            body: json.encode(<String, dynamic>{
              "payment_token": token,
              "amount": {"value": value, "currency": "RUB"},
              "capture": true,
              "confirmation": {
                "type": "redirect",
                "return_url": "https://ddpub.ru/success"
              },
              "description": descriptionOfOrder
            }));
    if (response.statusCode == 200) {
      return YokassaPayment.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
    }
    return null;
  }
}
