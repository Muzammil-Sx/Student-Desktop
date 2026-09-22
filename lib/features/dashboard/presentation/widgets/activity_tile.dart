import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String timeAgo;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: AppRadius.mdAll,
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleSmall),
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle, style: text.bodySmall),
              ],
            ),
          ),
          Text(
            timeAgo,
            style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}