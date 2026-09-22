import 'package:equatable/equatable.dart';

import 'courses_state.dart';

sealed class CoursesEvent extends Equatable {
  const CoursesEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load / refresh.
final class CoursesLoadRequested extends CoursesEvent {
  const CoursesLoadRequested();
}

/// Re-fetch (e.g., after sync completes).
final class CoursesRefreshRequested extends CoursesEvent {
  const CoursesRefreshRequested();
}

/// Apply a status filter.
final class CoursesFilterChanged extends CoursesEvent {
  const CoursesFilterChanged(this.filter);

  final CourseFilter filter;

  @override
  List<Object?> get props => [filter];
}

/// Update the search query.
final class CoursesSearchChanged extends CoursesEvent {
  const CoursesSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Clear both filter and search.
final class CoursesFiltersCleared extends CoursesEvent {
  const CoursesFiltersCleared();
}