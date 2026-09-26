import 'package:flutter/material.dart';

abstract final class AppColors {
  static const brand = Color(0xFF175C4C);
  static const brandDark = Color(0xFF72D6BC);
  static const lightSurface = Color(0xFFF8FAF9);
  static const darkSurface = Color(0xFF101513);

  static ColorScheme get lightScheme => ColorScheme.fromSeed(
    seedColor: brand,
    brightness: Brightness.light,
    surface: lightSurface,
  );

  static ColorScheme get darkScheme => ColorScheme.fromSeed(
    seedColor: brandDark,
    brightness: Brightness.dark,
    surface: darkSurface,
  );
}
