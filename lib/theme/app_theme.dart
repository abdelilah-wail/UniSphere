import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF63003C);
  static const Color primaryLight = Color(0xFF8B1A5E);
  static const Color primaryDark = Color(0xFF3E0026);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: const Color(0xFFF8F6F7),
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: primaryLight,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSurface: const Color(0xFF1A1A1A),
    ),
    fontFamily: 'Inter',
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: const Color(0xFF0D0D0D),
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: primaryLight,
      surface: const Color(0xFF1A1A1A),
      onPrimary: Colors.white,
      onSurface: const Color(0xFFE0E0E0),
    ),
    fontFamily: 'Inter',
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    ),
  );
}
