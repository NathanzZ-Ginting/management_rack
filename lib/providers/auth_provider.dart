import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/shared_prefs_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  Future<void> login(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Cek apakah email yang login sesuai yang diizinkan
      if (userCredential.user?.email == 'modezaadminstore@gmail.com') {
        _isLogin = true;
        SharedPrefsService.setLoginStatus(true);
        notifyListeners();
      } else {
        // Jika bukan email yg diizinkan, langsung logout lagi
        await FirebaseAuth.instance.signOut();
        throw FirebaseAuthException(
          code: 'email-not-allowed',
          message: 'Akun tidak diizinkan',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Gagal login');
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _isLogin = false;
    SharedPrefsService.clearLogin();
    notifyListeners();
  }
}