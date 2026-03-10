import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF0057D9);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFD9E6FF);
  static const Color onPrimaryContainer = Color(0xFF001A4D);

  static const Color secondary = Color(0xFF00A884);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFCCF3EA);
  static const Color onSecondaryContainer = Color(0xFF002B21);

  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF2E7D32);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFD6F5D6);
  static const Color onSuccessContainer = Color(0xFF0E3B11);

  static const Color warning = Color(0xFFFFC107);
  static const Color onWarning = Color(0xFF3B2F00);
  static const Color warningContainer = Color(0xFFFFF4B3);
  static const Color onWarningContainer = Color(0xFF4A3B00);

  static const Color background = Color(0xFFF7FAFF);
  static const Color onBackground = Color(0xFF111827);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF111827);

  static const Color outline = Color(0xFF93A3B8);

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: secondary,
    onTertiary: onSecondary,
    tertiaryContainer: secondaryContainer,
    onTertiaryContainer: onSecondaryContainer,
    error: error,
    onError: onError,
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    surface: surface,
    onSurface: onSurface,
    onSurfaceVariant: Color(0xFF3F4D63),
    outline: outline,
    outlineVariant: Color(0xFFC7D2E0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF1C2430),
    onInverseSurface: Color(0xFFEAF0F9),
    inversePrimary: Color(0xFFAFC7FF),
    surfaceTint: primary,
  );
}
