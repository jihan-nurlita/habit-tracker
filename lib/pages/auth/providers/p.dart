import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _name;
  String? _email;

  String get name => _name ?? "";
  String get email => _email ?? "";

  bool get isLogin => _name != null;

  Future<void> login({
    required String name,
    required String email,
  }) async {
    _name = name;
    _email = email;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "name",
      name,
    );

    await prefs.setString(
      "email",
      email,
    );

    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString("name");
    _email = prefs.getString("email");

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    _name = null;
    _email = null;

    notifyListeners();
  }
}
