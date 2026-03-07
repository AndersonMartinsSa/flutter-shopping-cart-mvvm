import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryYellow = Color(0xFFFFE600);
  static const Color primaryBlue = Color(0xFF3483FA);
  static const Color background = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF333333);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: background,

      colorScheme: const ColorScheme.light(
        primary: primaryYellow,
        secondary: primaryBlue,
        surface: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: primaryYellow,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),

      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),

      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: textPrimary),
      ),
    );
  }
}
