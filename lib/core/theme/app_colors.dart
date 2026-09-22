import 'package:flutter/material.dart';

/// Single source of truth for all colors.
/// Never hardcode colors in widgets — always reference these tokens.
abstract final class AppColors {
  AppColors._();

  // ---------- Brand ----------
  static const Color brandPrimary = Color(0xFF2563EB); // blue-600
  static const Color brandPrimaryDark = Color(0xFF3B82F6); // blue-500
  static const Color brandSecondary = Color(0xFF7C3AED); // violet-600

  // ---------- Light palette ----------
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextTertiary = Color(0xFF94A3B8);

  // ---------- Dark palette ----------
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextTertiary = Color(0xFF94A3B8);

  // ---------- Semantic ----------
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF0EA5E9);

  // ---------- Neutrals ----------
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
}