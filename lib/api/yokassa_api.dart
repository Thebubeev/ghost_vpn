import 'dart:convert';
import 'package:ghost_vpn/models/yokassa_payment.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

mixin Constants {
  static const secretKey = "live_GJuV8iE5UsSJDrMXAdG0jwdUBrB5WaH7QC99rVGBE6I";
  static const secretMobileKey =
      "live_MjAzNjMwZ-oxcKiZ7GuFpf00Bdw9aRO2m9v_RHAtigo";
  static const shopId = '203630';
  static const clientId = '11q73cqv3htff22k0md92f3otk8apnel';
}

class YokassaApi {
  Future<YokassaPayment?> checkYokassaPayment(String token) async {
    final credentials =
        '203630:live_GJuV8iE5UsSJDrMXAdG0jwdUBrB5WaH7QC99rVGBE6I';

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
        '203630:live_GJuV8iE5UsSJDrMXAdG0jwdUBrB5WaH7QC99rVGBE6I';

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
