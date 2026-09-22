import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../courses/domain/course.dart';

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({super.key, required this.course, this.onTap});

  final Course course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SizedBox(
      width: 280,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: colors.outline),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.lgAll,
          child: InkWell(
            borderRadius: AppRadius.lgAll,
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        course.category.toUpperCase(),
                        style: text.labelSmall?.copyWith(
                          color: colors.primary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Text(
                      '${course.progressPercent}%',
                      style: text.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  course.title,
                  style: text.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'by ${course.instructor}',
                  style: text.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.lg),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: course.progress,
                    minHeight: 5,
                    backgroundColor: colors.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(colors.primary),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Text(
                      '${course.completedLessons} / ${course.totalLessons} lessons',
                      style: text.bodySmall,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}