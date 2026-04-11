import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  bool get isLight => Theme.of(this).brightness == Brightness.light;

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get size => MediaQuery.of(this).size;

  double get width => size.width;

  double get height => size.height;
}
