import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/extensions/context_ext.dart';
import '../../../shared/widgets/state_views/loading_view.dart';
import '../../courses/domain/course.dart';
import '../../courses/presentation/bloc/courses_bloc.dart';
import '../../courses/presentation/bloc/courses_state.dart';
import 'widgets/activity_tile.dart';
import 'widgets/continue_learning_card.dart';
import 'widgets/stat_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state.status == CoursesStatus.loading && state.courses.isEmpty) {
          return const LoadingView(message: 'Loading dashboard...');
        }

        final stats = state.stats;
        final continueLearning = state.continueLearning;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _GreetingHeader(),
              const SizedBox(height: AppSpacing.xxl),
              _StatsRow(stats: stats),
              const SizedBox(height: AppSpacing.xxl),
              _ContinueLearning(courses: continueLearning),
              const SizedBox(height: AppSpacing.xxl),
              const _RecentActivity(),
            ],
          ),
        );
      },
    );
  }
}

// ------------------------------------------------------------
// Greeting
// ------------------------------------------------------------

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$greeting, Alpha 👋', style: text.headlineMedium),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                "Here's your learning summary for today.",
                style: text.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// Stats
// ------------------------------------------------------------

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final CourseStats stats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width > 1200
            ? 4
            : width > 800
                ? 2
                : 1;

        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppSpacing.lg,
          mainAxisSpacing: AppSpacing.lg,
          childAspectRatio: 1.9,
          children: [
            StatCard(
              label: 'Enrolled',
              value: '${stats.enrolled}',
              icon: Icons.library_books_outlined,
              accent: const Color(0xFF3B82F6),
              trend: 'total',
            ),
            StatCard(
              label: 'Completed',
              value: '${stats.completed}',
              icon: Icons.check_circle_outline,
              accent: const Color(0xFF16A34A),
            ),
            StatCard(
              label: 'In progress',
              value: '${stats.inProgress}',
              icon: Icons.play_circle_outline,
              accent: const Color(0xFFF59E0B),
            ),
            StatCard(
              label: 'Not started',
              value: '${stats.notStarted}',
              icon: Icons.schedule_outlined,
              accent: const Color(0xFF94A3B8),
            ),
          ],
        );
      },
    );
  }
}

// ------------------------------------------------------------
// Continue Learning
// ------------------------------------------------------------

class _ContinueLearning extends StatelessWidget {
  const _ContinueLearning({required this.courses});

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    final text = context.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Continue learning', style: text.titleLarge),
            const Spacer(),
            Text('${courses.length} active', style: text.bodySmall),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (courses.isEmpty)
          const _EmptyRow()
        else
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: courses.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.lg),
              itemBuilder: (context, i) =>
                  ContinueLearningCard(course: courses[i]),
            ),
          ),
      ],
    );
  }
}

class _EmptyRow extends StatelessWidget {
  const _EmptyRow();

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      alignment: Alignment.center,
      child: Text(
        'No courses in progress. Start one from the Courses tab.',
        style: text.bodySmall,
      ),
    );
  }
}

// ------------------------------------------------------------
// Recent Activity
// ------------------------------------------------------------

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;

    final items = const [
      (
        icon: Icons.check_circle_outline,
        title: 'Lesson completed',
        subtitle: 'Flutter for Desktop — Layouts',
        time: '2h ago',
        accent: Color(0xFF16A34A),
      ),
      (
        icon: Icons.play_circle_outline,
        title: 'Started a new course',
        subtitle: 'State Management Deep Dive',
        time: '12h ago',
        accent: Color(0xFF3B82F6),
      ),
      (
        icon: Icons.emoji_events_outlined,
        title: 'Earned a certificate',
        subtitle: 'Advanced Dart — Completed',
        time: '1d ago',
        accent: Color(0xFFF59E0B),
      ),
      (
        icon: Icons.rate_review_outlined,
        title: 'Left a review',
        subtitle: 'UI/UX Fundamentals',
        time: '3d ago',
        accent: Color(0xFF8B5CF6),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              bottom: AppSpacing.sm,
            ),
            child: Text('Recent activity', style: text.titleLarge),
          ),
          for (final item in items)
            ActivityTile(
              icon: item.icon,
              title: item.title,
              subtitle: item.subtitle,
              timeAgo: item.time,
              accent: item.accent,
            ),
        ],
      ),
    );
  }
}