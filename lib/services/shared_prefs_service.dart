import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String keyIsLogin = 'is_login';

  static Future<void> setLoginStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLogin, value);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLogin) ?? false;
  }

  static Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyIsLogin);
  }
}