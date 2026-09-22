import 'package:equatable/equatable.dart';

import '../../domain/course.dart';

/// Filter for the courses list.
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

/// Status for the courses load.
enum CoursesStatus { initial, loading, success, failure }

class CoursesState extends Equatable {
  const CoursesState({
    this.status = CoursesStatus.initial,
    this.courses = const [],
    this.filter = CourseFilter.all,
    this.search = '',
    this.errorMessage,
  });

  final CoursesStatus status;
  final List<Course> courses;
  final CourseFilter filter;
  final String search;
  final String? errorMessage;

  // ------------------------------------------------------------
  // Derived getters — no recomputation in UI.
  // ------------------------------------------------------------

  bool get isLoading =>
      status == CoursesStatus.loading && courses.isEmpty;

  bool get hasAnyCourse => courses.isNotEmpty;

  bool get isFiltered =>
      filter != CourseFilter.all || search.trim().isNotEmpty;

  /// Courses after applying filter + search.
  List<Course> get filteredCourses {
    final query = search.trim().toLowerCase();
    return courses.where((c) {
      final matchesFilter = switch (filter) {
        CourseFilter.all => true,
        CourseFilter.inProgress => c.status == CourseStatus.inProgress,
        CourseFilter.completed => c.status == CourseStatus.completed,
        CourseFilter.notStarted => c.status == CourseStatus.notStarted,
      };
      if (!matchesFilter) return false;
      if (query.isEmpty) return true;
      return c.title.toLowerCase().contains(query) ||
          c.instructor.toLowerCase().contains(query) ||
          c.category.toLowerCase().contains(query);
    }).toList();
  }

  /// Courses to show in "Continue learning".
  List<Course> get continueLearning {
    final list = courses
        .where((c) => c.status == CourseStatus.inProgress)
        .toList()
      ..sort((a, b) => b.lastAccessedAt.compareTo(a.lastAccessedAt));
    return list;
  }

  /// Aggregated stats for the dashboard.
  CourseStats get stats => CourseStats(
        enrolled: courses.length,
        completed:
            courses.where((c) => c.status == CourseStatus.completed).length,
        inProgress:
            courses.where((c) => c.status == CourseStatus.inProgress).length,
        notStarted:
            courses.where((c) => c.status == CourseStatus.notStarted).length,
      );

  CoursesState copyWith({
    CoursesStatus? status,
    List<Course>? courses,
    CourseFilter? filter,
    String? search,
    String? errorMessage,
    bool clearError = false,
  }) =>
      CoursesState(
        status: status ?? this.status,
        courses: courses ?? this.courses,
        filter: filter ?? this.filter,
        search: search ?? this.search,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );

  @override
  List<Object?> get props => [status, courses, filter, search, errorMessage];
}

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