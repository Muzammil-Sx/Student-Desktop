import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

/// Centered loading indicator with optional message.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: colors.primary),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(message!, style: text.bodyMedium),
          ],
        ],
      ),
    );
  }
}