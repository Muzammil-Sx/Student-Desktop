import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  AppTheme._();

  // ---------- Light ----------
  static ThemeData get light => _build(
        brightness: Brightness.light,
        primary: AppColors.brandPrimary,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        surfaceVariant: AppColors.lightSurfaceVariant,
        border: AppColors.lightBorder,
        onSurface: AppColors.lightTextPrimary,
        onSurfaceSecondary: AppColors.lightTextSecondary,
        onSurfaceTertiary: AppColors.lightTextTertiary,
      );

  // ---------- Dark ----------
  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        primary: AppColors.brandPrimaryDark,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        surfaceVariant: AppColors.darkSurfaceVariant,
        border: AppColors.darkBorder,
        onSurface: AppColors.darkTextPrimary,
        onSurfaceSecondary: AppColors.darkTextSecondary,
        onSurfaceTertiary: AppColors.darkTextTertiary,
      );

  // ---------- Builder ----------
  static ThemeData _build({
    required Brightness brightness,
    required Color primary,
    required Color background,
    required Color surface,
    required Color surfaceVariant,
    required Color border,
    required Color onSurface,
    required Color onSurfaceSecondary,
    required Color onSurfaceTertiary,
  }) {
    final isLight = brightness == Brightness.light;

    final scheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: AppColors.white,
      primaryContainer: primary.withValues(alpha: 0.12),
      onPrimaryContainer: primary,
      secondary: AppColors.brandSecondary,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.brandSecondary.withValues(alpha: 0.12),
      onSecondaryContainer: AppColors.brandSecondary,
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColors.error.withValues(alpha: 0.12),
      onErrorContainer: AppColors.error,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceSecondary,
      outline: border,
      outlineVariant: border.withValues(alpha: 0.6),
      shadow: AppColors.black.withValues(alpha: isLight ? 0.06 : 0.3),
      scrim: AppColors.black.withValues(alpha: 0.5),
      inverseSurface: onSurface,
      onInverseSurface: surface,
      inversePrimary: primary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      textTheme: AppTypography.textTheme(onSurface, onSurfaceSecondary),
      primaryTextTheme: AppTypography.textTheme(onSurface, onSurfaceSecondary),
      dividerColor: border,
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: AppColors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: TextStyle(color: onSurfaceTertiary),
        labelStyle: TextStyle(color: onSurfaceSecondary),
        errorStyle: const TextStyle(color: AppColors.error),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          side: BorderSide(color: border),
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      iconTheme: IconThemeData(color: onSurface, size: 20),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: onSurface,
        contentTextStyle: TextStyle(color: surface),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: onSurface,
          borderRadius: AppRadius.smAll,
        ),
        textStyle: TextStyle(color: surface, fontSize: 12),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
          onSurfaceTertiary.withValues(alpha: 0.5),
        ),
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(3),
      ),
    );
  }
}