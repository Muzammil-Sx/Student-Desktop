import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }

enum AppButtonSize { sm, md, lg }

/// Single button system for the app.
/// Never create another button widget for a new feature.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.iconTrailing = false,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool iconTrailing;
  final bool isLoading;
  final bool isFullWidth;

  bool get _isDisabled => onPressed == null || isLoading;

  double get _height => switch (size) {
        AppButtonSize.sm => 36,
        AppButtonSize.md => 44,
        AppButtonSize.lg => 52,
      };

  EdgeInsets get _padding => switch (size) {
        AppButtonSize.sm => const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        AppButtonSize.md => const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        AppButtonSize.lg => const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      };

  double get _fontSize => switch (size) {
        AppButtonSize.sm => 13,
        AppButtonSize.md => 14,
        AppButtonSize.lg => 15,
      };

  @override
  Widget build(BuildContext context) {
    final child = _buildChild(context);
    final button = SizedBox(
      height: _height,
      width: isFullWidth ? double.infinity : null,
      child: switch (variant) {
        AppButtonVariant.primary => FilledButton(
            onPressed: _isDisabled ? null : onPressed,
            style: FilledButton.styleFrom(padding: _padding),
            child: child,
          ),
        AppButtonVariant.secondary => FilledButton.tonal(
            onPressed: _isDisabled ? null : onPressed,
            style: FilledButton.styleFrom(padding: _padding),
            child: child,
          ),
        AppButtonVariant.outline => OutlinedButton(
            onPressed: _isDisabled ? null : onPressed,
            style: OutlinedButton.styleFrom(padding: _padding),
            child: child,
          ),
        AppButtonVariant.ghost => TextButton(
            onPressed: _isDisabled ? null : onPressed,
            style: TextButton.styleFrom(padding: _padding),
            child: child,
          ),
        AppButtonVariant.danger => FilledButton(
            onPressed: _isDisabled ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              padding: _padding,
            ),
            child: child,
          ),
      },
    );

    return button;
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: _fontSize + 4,
        width: _fontSize + 4,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
    }

    final labelWidget = Text(
      label,
      style: TextStyle(
        fontSize: _fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );

    if (icon == null) return labelWidget;

    final iconWidget = Icon(icon, size: _fontSize + 4);
    final children = iconTrailing
        ? [labelWidget, const SizedBox(width: AppSpacing.sm), iconWidget]
        : [iconWidget, const SizedBox(width: AppSpacing.sm), labelWidget];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}