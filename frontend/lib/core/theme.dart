import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF534AB7);
  static const _surface = Color(0xFFF8F7FE);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: _surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: _surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEEEDFE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEEEDFE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
    ),
  );
}

class AppColors {
  static const purple = Color(0xFF534AB7);
  static const purpleLight = Color(0xFFEEEDFE);
  static const teal = Color(0xFF1D9E75);
  static const tealLight = Color(0xFFE1F5EE);
  static const coral = Color(0xFFD85A30);
  static const coralLight = Color(0xFFFAECE7);
  static const amber = Color(0xFFBA7517);
  static const amberLight = Color(0xFFFAEEDA);
  static const blue = Color(0xFF378ADD);
  static const blueLight = Color(0xFFE6F1FB);
  static const green = Color(0xFF639922);
  static const greenLight = Color(0xFFEAF3DE);
  static const pink = Color(0xFFD4537E);
  static const pinkLight = Color(0xFFFBEAF0);

  static const Map<String, Color> categoryColors = {
    'food': coral,
    'transport': blue,
    'shopping': purple,
    'health': teal,
    'entertainment': pink,
    'utilities': amber,
    'travel': green,
    'other': Color(0xFF888780),
  };

  static const Map<String, Color> categoryLightColors = {
    'food': coralLight,
    'transport': blueLight,
    'shopping': purpleLight,
    'health': tealLight,
    'entertainment': pinkLight,
    'utilities': amberLight,
    'travel': greenLight,
    'other': Color(0xFFF1EFE8),
  };
}
