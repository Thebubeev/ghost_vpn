import 'package:shared_preferences/shared_preferences.dart';

mixin Constants {
  static const String welcome = 'welcome';
}

class SharedPreferenceStorage {
  Future setWelcome(bool welcome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.welcome, welcome);
  }

   getWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.welcome);
  }
}
