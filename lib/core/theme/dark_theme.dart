import 'package:flutter/material.dart';

class DarkTheme {
  static const Color backgroundColor = Color(0xFF0A0A14);
  static const Color cardColor = Color(0xFF13132A);
  static const Color primaryColor = Color(0xFF7F77DD);
  static const Color accentColor = Color(0xFFFFB800);

  static const Color borderTileColor = Color(0xFF2A2A44);
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Color(0x99FFFFFF);

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: cardColor,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
