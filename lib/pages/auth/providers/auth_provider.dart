import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _name;
  String? _email;
  bool _isLoading = true;

  String get name => (_name != null && _name!.isNotEmpty) ? _name! : 'User';
  String get email =>
      (_email != null && _email!.isNotEmpty) ? _email! : 'user@gmail.com';
  bool get isLoading => _isLoading;

  bool get isLogin =>
      _name != null &&
      _email != null &&
      _name!.isNotEmpty &&
      _email!.isNotEmpty;

  // Helper untuk mendapatkan inisial nama (1 huruf pertama)
  String get initialName {
    if (_name == null || _name!.trim().isEmpty) return 'U';
    return _name!.trim()[0].toUpperCase();
  }

  // Panggil fungsi ini di main.dart atau saat app dimuat
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name');
    _email = prefs.getString('email');

    _isLoading = false;
    notifyListeners();
  }

  // Fungsi Login / Daftar Pertama Kali
  Future<void> login({
    required String name,
    required String email,
  }) async {
    await updateUser(name: name, email: email);
  }

  // Fungsi Update Profil / Daftar Ulang
  Future<void> updateUser({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    _name = name;
    _email = email;

    await prefs.setString('name', name);
    await prefs.setString('email', email);

    notifyListeners();
  }

  // Fungsi Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('name');
    await prefs.remove('email');

    _name = null;
    _email = null;

    notifyListeners();
  }
}
