import 'package:flutter/material.dart';

abstract final class AppTypography {
  static TextTheme textTheme(ColorScheme colors) => TextTheme(
    headlineSmall: TextStyle(
      color: colors.onSurface,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
    titleLarge: TextStyle(
      color: colors.onSurface,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),
    titleMedium: TextStyle(
      color: colors.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.35,
    ),
    bodyLarge: TextStyle(
      color: colors.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      color: colors.onSurfaceVariant,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.45,
    ),
    labelLarge: TextStyle(
      color: colors.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
  );
}
