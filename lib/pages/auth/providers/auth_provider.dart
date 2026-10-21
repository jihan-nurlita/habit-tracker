import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _name;
  String? _email;
  String? _profileImagePath;
  bool _useDefaultIcon = false;
  bool _isLoading = true;

  String get name => (_name != null && _name!.isNotEmpty) ? _name! : 'User';
  String get email =>
      (_email != null && _email!.isNotEmpty) ? _email! : 'user@gmail.com';
  String? get profileImagePath => _profileImagePath;
  bool get useDefaultIcon => _useDefaultIcon;
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
    _profileImagePath = prefs.getString('profile_image_path');
    _useDefaultIcon = prefs.getBool('use_default_icon') ?? false;

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

  // Fungsi Update Profil (Nama, Email, dan Foto Profil)
  Future<void> updateUser({
    required String name,
    required String email,
    String? profileImagePath,
    bool? useDefaultIcon,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    _name = name;
    _email = email;

    await prefs.setString('name', name);
    await prefs.setString('email', email);

    if (profileImagePath != null) {
      _profileImagePath = profileImagePath;
      await prefs.setString('profile_image_path', profileImagePath);
    }

    if (useDefaultIcon != null) {
      _useDefaultIcon = useDefaultIcon;
      await prefs.setBool('use_default_icon', useDefaultIcon);
    }

    notifyListeners();
  }

  // Fungsi khusus untuk memperbarui foto profil / icon / hapus foto
  Future<void> updateProfileImage({
    String? path,
    required bool defaultIcon,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    _profileImagePath = path;
    _useDefaultIcon = defaultIcon;

    if (path != null) {
      await prefs.setString('profile_image_path', path);
    } else {
      await prefs.remove('profile_image_path');
    }

    await prefs.setBool('use_default_icon', defaultIcon);

    notifyListeners();
  }

  // Fungsi Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('profile_image_path');
    await prefs.remove('use_default_icon');
    await prefs.setBool(
        'is_logged_in', false); // 👈 Set status login jadi false

    _name = null;
    _email = null;
    _profileImagePath = null;
    _useDefaultIcon = false;

    notifyListeners();
  }
}
