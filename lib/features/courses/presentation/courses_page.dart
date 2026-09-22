import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/extensions/context_ext.dart';
import '../../../shared/widgets/state_views/empty_view.dart';
import '../domain/course.dart';
import '../domain/courses_provider.dart';
import 'widgets/course_card.dart';

class CoursesPage extends ConsumerWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(filteredCoursesProvider);
    final allEmpty = ref.watch(allCoursesProvider).isEmpty;
    final filter = ref.watch(courseFilterProvider);
    final search = ref.watch(courseSearchProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(),
        _Controls(),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: courses.isEmpty
              ? _EmptyContent(
                  hasAnyCourse: !allEmpty,
                  filter: filter,
                  search: search,
                )
              : _CoursesGrid(courses: courses),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// Header
// ------------------------------------------------------------

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.xxl,
        AppSpacing.xxl,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Courses', style: text.headlineMedium),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'All the courses you are enrolled in.',
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// Search + Filter row
// ------------------------------------------------------------

class _Controls extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(courseFilterProvider);
    final search = ref.watch(courseSearchProvider);
    final searchCtrl = TextEditingController(text: search);
    searchCtrl.selection = TextSelection.collapsed(offset: search.length);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: TextField(
                controller: searchCtrl,
                onChanged: (v) => ref.read(courseSearchProvider.notifier).set(v),
                decoration: const InputDecoration(
                  hintText: 'Search by title, instructor, or category',
                  prefixIcon: Icon(Icons.search, size: 20),
                ),
              ),
            ),
          ),
          const Spacer(),
          _FilterChips(
            selected: filter,
            onSelect: (f) => ref.read(courseFilterProvider.notifier).set(f),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onSelect});

  final CourseFilter selected;
  final ValueChanged<CourseFilter> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        for (final f in CourseFilter.values)
          _FilterChip(
            label: f.label,
            isSelected: f == selected,
            onTap: () => onSelect(f),
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;

    return Material(
      color: isSelected
          ? colors.primary.withValues(alpha: 0.12)
          : colors.surfaceContainerHighest,
      borderRadius: AppRadius.pillAll,
      child: InkWell(
        borderRadius: AppRadius.pillAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            label,
            style: text.bodySmall?.copyWith(
              color: isSelected ? colors.primary : colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Grid
// ------------------------------------------------------------

class _CoursesGrid extends StatelessWidget {
  const _CoursesGrid({required this.courses});

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width > 1400
            ? 4
            : width > 1080
                ? 3
                : 2;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            0,
            AppSpacing.xxl,
            AppSpacing.xxl,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.lg,
            mainAxisSpacing: AppSpacing.lg,
            mainAxisExtent: 250,
          ),
          itemCount: courses.length,
          itemBuilder: (context, i) => CourseCard(course: courses[i]),
        );
      },
    );
  }
}

// ------------------------------------------------------------
// Empty
// ------------------------------------------------------------

class _EmptyContent extends ConsumerWidget {
  const _EmptyContent({
    required this.hasAnyCourse,
    required this.filter,
    required this.search,
  });

  final bool hasAnyCourse;
  final CourseFilter filter;
  final String search;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!hasAnyCourse) {
      return const EmptyView(
        icon: Icons.menu_book_outlined,
        title: 'No courses yet',
        subtitle:
            'Once you enroll in a course, it will appear here. You can also try refreshing after syncing.',
      );
    }

    // Filtered to nothing
    final hasSearch = search.trim().isNotEmpty;
    return EmptyView(
      icon: Icons.search_off_outlined,
      title: 'No matches',
      subtitle: hasSearch
          ? 'No courses match "$search". Try a different search or filter.'
          : 'No courses match "${filter.label}". Try a different filter.',
      actionLabel: 'Clear filters',
      onAction: () {
        ref.read(courseSearchProvider.notifier).clear();
        ref.read(courseFilterProvider.notifier).set(CourseFilter.all);
      },
    );
  }
}