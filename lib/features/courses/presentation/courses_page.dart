import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/extensions/context_ext.dart';
import '../../../shared/widgets/state_views/empty_view.dart';
import '../../../shared/widgets/state_views/error_view.dart';
import '../../../shared/widgets/state_views/loading_view.dart';
import '../domain/course.dart';
import 'bloc/courses_bloc.dart';
import 'bloc/courses_event.dart';
import 'bloc/courses_state.dart';
import 'widgets/course_card.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(),
        const _Controls(),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: BlocBuilder<CoursesBloc, CoursesState>(
            builder: (context, state) {
              if (state.status == CoursesStatus.loading &&
                  state.courses.isEmpty) {
                return const LoadingView(message: 'Loading courses...');
              }
              if (state.status == CoursesStatus.failure &&
                  state.courses.isEmpty) {
                return ErrorView(
                  message: state.errorMessage ?? 'Failed to load courses',
                  onRetry: () => context
                      .read<CoursesBloc>()
                      .add(const CoursesLoadRequested()),
                );
              }
              if (state.courses.isEmpty) {
                return const EmptyView(
                  icon: Icons.menu_book_outlined,
                  title: 'No courses yet',
                  subtitle:
                      'Once you enroll in a course, it will appear here.',
                );
              }

              final filtered = state.filteredCourses;
              if (filtered.isEmpty) {
                return EmptyView(
                  icon: Icons.search_off_outlined,
                  title: 'No matches',
                  subtitle: state.search.trim().isNotEmpty
                      ? 'No courses match "${state.search}".'
                      : 'No courses match "${state.filter.label}".',
                  actionLabel: 'Clear filters',
                  onAction: () => context
                      .read<CoursesBloc>()
                      .add(const CoursesFiltersCleared()),
                );
              }

              return _CoursesGrid(courses: filtered);
            },
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// Header
// ------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header();

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
          Text('All the courses you are enrolled in.', style: text.bodySmall),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// Search + Filter row
// ------------------------------------------------------------

class _Controls extends StatefulWidget {
  const _Controls();

  @override
  State<_Controls> createState() => _ControlsState();
}

class _ControlsState extends State<_Controls> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    final initial = context.read<CoursesBloc>().state.search;
    _searchCtrl = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => context
                    .read<CoursesBloc>()
                    .add(CoursesSearchChanged(v)),
                decoration: const InputDecoration(
                  hintText: 'Search by title, instructor, or category',
                  prefixIcon: Icon(Icons.search, size: 20),
                ),
              ),
            ),
          ),
          const Spacer(),
          BlocBuilder<CoursesBloc, CoursesState>(
            buildWhen: (a, b) => a.filter != b.filter,
            builder: (context, state) {
              return _FilterChips(
                selected: state.filter,
                onSelect: (f) =>
                    context.read<CoursesBloc>().add(CoursesFilterChanged(f)),
              );
            },
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