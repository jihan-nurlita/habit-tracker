import 'package:flutter/material.dart';
import 'package:habit_tracker/core/theme/theme_model.dart';

/// 🌿 Green Theme
final greenTheme = ThemeModel(
  primaryColor: const Color(0xFF6BAF92),
  backgroundColor: const Color(0xFFF6FBF8),
  cardColor: Colors.white,
  iconColor: const Color(0xFF4F8A70),
  textColor: Colors.black,
  softColor: const Color(0xFFDDF0DF),
  borderColor: const Color(0xFFE8F0E8),
);

/// 💜 Purple Theme
final purpleTheme = ThemeModel(
  primaryColor: const Color(0xFF8B80F8),
  backgroundColor: const Color(0xFFF7F5FF),
  cardColor: Colors.white,
  iconColor: const Color(0xFF6C63FF),
  textColor: Colors.black,
  softColor: const Color(0xFFEAE7FF),
  borderColor: const Color(0xFFE4DFFF),
);

/// 🌸 Pink Theme
final pinkTheme = ThemeModel(
  primaryColor: const Color(0xFFF48FB1),
  backgroundColor: const Color(0xFFFFF5F8),
  cardColor: Colors.white,
  iconColor: const Color(0xFFE91E63),
  textColor: Colors.black,
  softColor: const Color(0xFFFFE4EE),
  borderColor: const Color(0xFFFFD4E5),
);

/// 💙 Blue Theme
final blueTheme = ThemeModel(
  primaryColor: const Color(0xFF64B5F6),
  backgroundColor: const Color(0xFFF5FAFF),
  cardColor: Colors.white,
  iconColor: const Color(0xFF2196F3),
  textColor: Colors.black,
  softColor: const Color(0xFFE3F2FD),
  borderColor: const Color(0xFFD6ECFF),
);

/// 🧡 Orange Theme
final orangeTheme = ThemeModel(
  primaryColor: const Color(0xFFFFB74D),
  backgroundColor: const Color(0xFFFFF8F1),
  cardColor: Colors.white,
  iconColor: const Color(0xFFFF9800),
  textColor: Colors.black,
  softColor: const Color(0xFFFFE8CC),
  borderColor: const Color(0xFFFFDDB5),
);

/// 🩶 Grey Theme
final greyTheme = ThemeModel(
  primaryColor: const Color(0xFF90A4AE),
  backgroundColor: const Color(0xFFF5F5F5),
  cardColor: Colors.white,
  iconColor: const Color(0xFF607D8B),
  textColor: Colors.black,
  softColor: const Color(0xFFECEFF1),
  borderColor: const Color(0xFFE0E0E0),
);

/// ❤️ Red Theme
final redTheme = ThemeModel(
  primaryColor: const Color(0xFFE57373),
  backgroundColor: const Color(0xFFFFF5F5),
  cardColor: Colors.white,
  iconColor: const Color(0xFFD32F2F),
  textColor: Colors.black,
  softColor: const Color(0xFFFFE3E3),
  borderColor: const Color(0xFFFFD2D2),
);

/// 🌊 Cyan Theme
final cyanTheme = ThemeModel(
  primaryColor: const Color(0xFF4DD0E1),
  backgroundColor: const Color(0xFFF2FDFF),
  cardColor: Colors.white,
  iconColor: const Color(0xFF00BCD4),
  textColor: Colors.black,
  softColor: const Color(0xFFDDFBFF),
  borderColor: const Color(0xFFCFF6FC),
);

/// 🌼 Yellow Theme
final yellowTheme = ThemeModel(
  primaryColor: const Color(0xFFFFEB3B),
  backgroundColor: const Color(0xFFFFFDEB),
  cardColor: Colors.white,
  iconColor: const Color(0xFFFBC02D),
  textColor: Colors.black,
  softColor: const Color(0xFFFFF7C2),
  borderColor: const Color(0xFFFFF0A6),
);

/// 🌙 Dark Theme
final darkTheme = ThemeModel(
  primaryColor: const Color(0xFF2E7D32),
  backgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  iconColor: Colors.white,
  textColor: Colors.white,
  softColor: const Color(0xFF2A2A2A),
  borderColor: const Color(0xFF333333),
);

/// 🌿 Mint Theme
final mintTheme = ThemeModel(
  primaryColor: const Color(0xFF4DB6AC),
  backgroundColor: const Color(0xFFF2FFFC),
  cardColor: Colors.white,
  iconColor: const Color(0xFF009688),
  textColor: Colors.black,
  softColor: const Color(0xFFD9FFF8),
  borderColor: const Color(0xFFC6F7EE),
);

/// 🌌 Indigo Theme
final indigoTheme = ThemeModel(
  primaryColor: const Color(0xFF7986CB),
  backgroundColor: const Color(0xFFF5F6FF),
  cardColor: Colors.white,
  iconColor: const Color(0xFF3F51B5),
  textColor: Colors.black,
  softColor: const Color(0xFFE4E8FF),
  borderColor: const Color(0xFFD7DDFF),
);

/// ☕ Brown Theme
final brownTheme = ThemeModel(
  primaryColor: const Color(0xFFA1887F),
  backgroundColor: const Color(0xFFFAF7F5),
  cardColor: Colors.white,
  iconColor: const Color(0xFF795548),
  textColor: Colors.black,
  softColor: const Color(0xFFEDE0DA),
  borderColor: const Color(0xFFE0D2CB),
);

/// 🌺 Rose Theme
final roseTheme = ThemeModel(
  primaryColor: const Color(0xFFF06292),
  backgroundColor: const Color(0xFFFFF5F8),
  cardColor: Colors.white,
  iconColor: const Color(0xFFE91E63),
  textColor: Colors.black,
  softColor: const Color(0xFFFFE0EB),
  borderColor: const Color(0xFFFFD0E1),
);

/// 🌈 Lavender Theme
final lavenderTheme = ThemeModel(
  primaryColor: const Color(0xFFB39DDB),
  backgroundColor: const Color(0xFFF9F7FF),
  cardColor: Colors.white,
  iconColor: const Color(0xFF7E57C2),
  textColor: Colors.black,
  softColor: const Color(0xFFEDE7FF),
  borderColor: const Color(0xFFE0D8FF),
);

/// 🌊 Ocean Theme
final oceanTheme = ThemeModel(
  primaryColor: const Color(0xFF4FC3F7),
  backgroundColor: const Color(0xFFF3FBFF),
  cardColor: Colors.white,
  iconColor: const Color(0xFF0288D1),
  textColor: Colors.black,
  softColor: const Color(0xFFDFF5FF),
  borderColor: const Color(0xFFCDEEFF),
);

/// List semua tema untuk kebutuhan SharedPreferences
final List<ThemeModel> appThemes = [
  greenTheme,
  purpleTheme,
  pinkTheme,
  blueTheme,
  orangeTheme,
  greyTheme,
  redTheme,
  cyanTheme,
  yellowTheme,
  mintTheme,
  indigoTheme,
  brownTheme,
  roseTheme,
  lavenderTheme,
  oceanTheme,
];
