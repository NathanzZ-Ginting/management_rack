import 'package:flutter/material.dart';
import '../services/shared_prefs_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  void login(String username, String password) {
    if (username == 'admin' && password == '123') {
      _isLogin = true;
      SharedPrefsService.setLoginStatus(true);
      notifyListeners();
    }
  }

  void logout() {
    _isLogin = false;
    SharedPrefsService.clearLogin();
    notifyListeners();
  }
}