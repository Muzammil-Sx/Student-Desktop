// ignore_for_file: unintended_html_in_doc_comment

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_courses.dart';
import 'course.dart';

// ============================================================
// Filters & Search
// ============================================================

enum CourseFilter {
  all,
  inProgress,
  completed,
  notStarted;

  String get label => switch (this) {
        CourseFilter.all => 'All',
        CourseFilter.inProgress => 'In progress',
        CourseFilter.completed => 'Completed',
        CourseFilter.notStarted => 'Not started',
      };
}

class CourseFilterNotifier extends Notifier<CourseFilter> {
  @override
  CourseFilter build() => CourseFilter.all;

  void set(CourseFilter value) => state = value;
}

final courseFilterProvider =
    NotifierProvider<CourseFilterNotifier, CourseFilter>(
  CourseFilterNotifier.new,
);

class CourseSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void set(String value) => state = value;

  void clear() => state = '';
}

final courseSearchProvider =
    NotifierProvider<CourseSearchNotifier, String>(CourseSearchNotifier.new);

// ============================================================
// Data
// ============================================================

/// All courses.
/// TODO: Replace with a FutureProvider<List<Course>> once the API layer
/// is wired. The rest of the app can stay unchanged — the presentation
/// layer will switch to `.when(data:, loading:, error:)`.
final allCoursesProvider = Provider<List<Course>>((ref) => mockCourses);

/// Courses after applying the current search + filter.
final filteredCoursesProvider = Provider<List<Course>>((ref) {
  final courses = ref.watch(allCoursesProvider);
  final filter = ref.watch(courseFilterProvider);
  final query = ref.watch(courseSearchProvider).trim().toLowerCase();

  return courses.where((c) {
    // Filter
    final matchesFilter = switch (filter) {
      CourseFilter.all => true,
      CourseFilter.inProgress => c.status == CourseStatus.inProgress,
      CourseFilter.completed => c.status == CourseStatus.completed,
      CourseFilter.notStarted => c.status == CourseStatus.notStarted,
    };
    if (!matchesFilter) return false;

    // Search
    if (query.isEmpty) return true;
    return c.title.toLowerCase().contains(query) ||
        c.instructor.toLowerCase().contains(query) ||
        c.category.toLowerCase().contains(query);
  }).toList();
});

/// Courses currently in progress, ordered by most recently accessed.
final continueLearningProvider = Provider<List<Course>>((ref) {
  final courses = ref
      .watch(allCoursesProvider)
      .where((c) => c.status == CourseStatus.inProgress)
      .toList()
    ..sort((a, b) => b.lastAccessedAt.compareTo(a.lastAccessedAt));
  return courses;
});

/// Simple aggregated stats — used by the dashboard.
class CourseStats {
  const CourseStats({
    required this.enrolled,
    required this.completed,
    required this.inProgress,
    required this.notStarted,
  });

  final int enrolled;
  final int completed;
  final int inProgress;
  final int notStarted;
}

final courseStatsProvider = Provider<CourseStats>((ref) {
  final courses = ref.watch(allCoursesProvider);
  return CourseStats(
    enrolled: courses.length,
    completed: courses.where((c) => c.status == CourseStatus.completed).length,
    inProgress: courses.where((c) => c.status == CourseStatus.inProgress).length,
    notStarted: courses.where((c) => c.status == CourseStatus.notStarted).length,
  );
});