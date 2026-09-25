import 'package:flutter/material.dart';

class ThemeModel {
  final Color primaryColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color iconColor;
  final Color textColor;
  final Color softColor;
  final Color borderColor;

  ThemeModel({
    required this.primaryColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.iconColor,
    required this.textColor,
    required this.softColor,
    required this.borderColor,
  });

  /// Konversi otomatis ke skema Dark Mode dengan mempertahankan warna aksen (primaryColor)
  ThemeModel toDarkMode() {
    return ThemeModel(
      primaryColor: primaryColor,
      backgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      iconColor: primaryColor, // Menggunakan warna aksen untuk ikon
      textColor: Colors.white,
      softColor: primaryColor.withOpacity(0.15),
      borderColor: const Color(0xFF2C2C2C),
    );
  }
}
