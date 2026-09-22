import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/course.dart';

class CourseCard extends StatefulWidget {
  const CourseCard({super.key, required this.course, this.onTap});

  final Course course;
  final VoidCallback? onTap;

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final accent = _accentColor(widget.course.category, colors);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.lgAll,
          border: Border.all(
            color: _hovered ? accent.withValues(alpha: 0.5) : colors.outline,
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.lgAll,
          child: InkWell(
            borderRadius: AppRadius.lgAll,
            onTap: widget.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Banner(accent: accent, icon: _categoryIcon(widget.course.category)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.course.title,
                                style: text.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _StatusBadge(status: widget.course.status),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'by ${widget.course.instructor}',
                          style: text.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        _ProgressRow(course: widget.course, accent: accent),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Color _accentColor(String category, ColorScheme colors) =>
      switch (category) {
        'Programming' => const Color(0xFF3B82F6),
        'Design' => const Color(0xFFEC4899),
        'Business' => const Color(0xFFF59E0B),
        'Marketing' => const Color(0xFF8B5CF6),
        'Data Science' => const Color(0xFF10B981),
        _ => colors.primary,
      };

  static IconData _categoryIcon(String category) => switch (category) {
        'Programming' => Icons.code,
        'Design' => Icons.brush_outlined,
        'Business' => Icons.business_center_outlined,
        'Marketing' => Icons.campaign_outlined,
        'Data Science' => Icons.insights_outlined,
        _ => Icons.school_outlined,
      };
}

class _Banner extends StatelessWidget {
  const _Banner({required this.accent, required this.icon});

  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.18),
            accent.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Icon(icon, color: accent, size: 28),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final CourseStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      CourseStatus.notStarted => ('New', const Color(0xFF94A3B8)),
      CourseStatus.inProgress => ('Active', const Color(0xFF3B82F6)),
      CourseStatus.completed => ('Done', const Color(0xFF16A34A)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.course, required this.accent});

  final Course course;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${course.completedLessons}/${course.totalLessons} lessons',
              style: text.bodySmall,
            ),
            const Spacer(),
            Text(
              '${course.progressPercent}%',
              style: text.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: course.progress,
            minHeight: 5,
            backgroundColor: colors.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(accent),
          ),
        ),
      ],
    );
  }
}