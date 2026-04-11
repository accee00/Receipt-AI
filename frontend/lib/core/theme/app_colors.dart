import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00BFA5);
  static const Color primaryDark = Color(0xFF00897B);
  static const Color primaryLight = Color(0xFF4EDCC8);
  static const Color accent = Color(0xFFFFCA28);

  static const Color success = Color(0xFF26A69A);
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFCA28);
  static const Color info = Color(0xFF42A5F5);

  static const Color darkBackground = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1A2235);
  static const Color darkBorder = Color(0xFF252D42);
  static const Color darkTextPrimary = Color(0xFFF0F4FF);
  static const Color darkTextSecondary = Color(0xFF8A9BBE);
  static const Color darkTextHint = Color(0xFF4A5568);

  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F1729);
  static const Color lightTextSecondary = Color(0xFF5A6882);
  static const Color lightTextHint = Color(0xFFA0AEC0);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00BFA5), Color(0xFF00796B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBgGradient = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF111827)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient lightBgGradient = LinearGradient(
    colors: [Color(0xFFF5F7FA), Color(0xFFEBF4F1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color blob1Dark = Color(0xFF0D2137);
  static const Color blob2Dark = Color(0xFF0A1A2E);
  static const Color blob1Light = Color(0xFFD0F0EA);
  static const Color blob2Light = Color(0xFFBFEDE5);
  static const Color overlayDark = Color(0x40000000);
  static const Color glassBorderDark = Color(0x22FFFFFF);
  static const Color glassBorderLight = Color(0x3300BFA5);
}
