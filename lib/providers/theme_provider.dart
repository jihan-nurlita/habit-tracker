import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/core/theme/theme_data.dart';
import 'package:habit_tracker/core/theme/theme_model.dart';

class ThemeProvider extends ChangeNotifier {
  /// Keys untuk SharedPreferences
  static const String _darkModeKey = 'is_dark_mode_key';
  static const String _themeIndexKey = 'selected_theme_index_key';

  /// COLOR THEME
  ThemeModel _selectedTheme = greenTheme;

  ThemeModel get selectedTheme => _selectedTheme;

  /// MODE
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  /// Constructor: Otomatis memuat tema saat Provider dibuat
  ThemeProvider() {
    _loadThemeFromStorage();
  }

  /// =========================
  /// LOCAL STORAGE (SHARED PREFERENCES)
  /// =========================

  // Simpan pengaturan tema ke SharedPreferences
  Future<void> _saveThemeToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Simpan status Dark Mode
      await prefs.setBool(_darkModeKey, _isDarkMode);

      // Cari indeks dari _selectedTheme di appThemes
      // Pastikan `appThemes` didefinisikan di `theme_data.dart`
      int themeIndex = appThemes.indexOf(_selectedTheme);
      if (themeIndex != -1) {
        await prefs.setInt(_themeIndexKey, themeIndex);
      }
    } catch (e) {
      debugPrint('Gagal menyimpan pengaturan tema: $e');
    }
  }

  // Memuat pengaturan tema dari SharedPreferences
  Future<void> _loadThemeFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load status Dark Mode
      _isDarkMode = prefs.getBool(_darkModeKey) ?? false;

      // Load indeks tema warna
      final int? themeIndex = prefs.getInt(_themeIndexKey);
      if (themeIndex != null &&
          themeIndex >= 0 &&
          themeIndex < appThemes.length) {
        _selectedTheme = appThemes[themeIndex];
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Gagal memuat pengaturan tema: $e');
    }
  }

  /// =========================
  /// CURRENT THEME
  /// =========================
  ThemeModel get currentTheme {
    if (_isDarkMode) {
      return ThemeModel(
        primaryColor: _selectedTheme.primaryColor,
        backgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        iconColor: Colors.white,
        textColor: Colors.white,
        softColor: const Color(0xFF2A2A2A),
        borderColor: const Color(0xFF333333),
      );
    }

    return _selectedTheme;
  }

  /// =========================
  /// CHANGE COLOR
  /// =========================
  void changeTheme(
    ThemeModel theme,
  ) {
    _selectedTheme = theme;
    _saveThemeToStorage(); // <--- Simpan perubahan secara otomatis

    notifyListeners();
  }

  /// =========================
  /// DARK MODE
  /// =========================
  void setDarkMode(
    bool value,
  ) {
    _isDarkMode = value;
    _saveThemeToStorage(); // <--- Simpan perubahan secara otomatis

    notifyListeners();
  }
}
