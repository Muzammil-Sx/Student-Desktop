import 'package:flutter/material.dart';

/// App typography tokens.
/// Uses platform default font — override by adding a custom font in pubspec
/// and setting [_fontFamily].
abstract final class AppTypography {
  AppTypography._();

  static const String? _fontFamily = null; // null = platform default

  static TextTheme textTheme(Color primary, Color secondary) => TextTheme(
        displayLarge: _s(32, FontWeight.w700, primary, 1.25),
        displayMedium: _s(28, FontWeight.w700, primary, 1.25),
        displaySmall: _s(24, FontWeight.w600, primary, 1.3),
        headlineLarge: _s(22, FontWeight.w600, primary, 1.3),
        headlineMedium: _s(20, FontWeight.w600, primary, 1.35),
        headlineSmall: _s(18, FontWeight.w600, primary, 1.4),
        titleLarge: _s(16, FontWeight.w600, primary, 1.4),
        titleMedium: _s(15, FontWeight.w500, primary, 1.4),
        titleSmall: _s(14, FontWeight.w500, primary, 1.4),
        bodyLarge: _s(15, FontWeight.w400, primary, 1.5),
        bodyMedium: _s(14, FontWeight.w400, primary, 1.5),
        bodySmall: _s(13, FontWeight.w400, secondary, 1.5),
        labelLarge: _s(14, FontWeight.w600, primary, 1.4, letterSpacing: 0.1),
        labelMedium: _s(13, FontWeight.w500, secondary, 1.4, letterSpacing: 0.1),
        labelSmall: _s(12, FontWeight.w500, secondary, 1.4, letterSpacing: 0.1),
      );

  static TextStyle _s(
    double size,
    FontWeight weight,
    Color color,
    double height, {
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color,
        letterSpacing: letterSpacing,
      );
}