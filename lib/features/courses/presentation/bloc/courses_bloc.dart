import 'package:bloc/bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/courses_repository.dart';
import 'courses_event.dart';
import 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  CoursesBloc({required CoursesRepository repository})
      : _repository = repository,
        super(const CoursesState()) {
    on<CoursesLoadRequested>(_onLoad);
    on<CoursesRefreshRequested>(_onRefresh);
    on<CoursesFilterChanged>(_onFilterChanged);
    on<CoursesSearchChanged>(_onSearchChanged);
    on<CoursesFiltersCleared>(_onFiltersCleared);
  }

  final CoursesRepository _repository;

  Future<void> _onLoad(
    CoursesLoadRequested event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.loading, clearError: true));
    await _fetch(emit);
  }

  Future<void> _onRefresh(
    CoursesRefreshRequested event,
    Emitter<CoursesState> emit,
  ) async {
    // Keep existing data visible during refresh.
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<CoursesState> emit) async {
    try {
      final courses = await _repository.fetchCourses();
      emit(
        state.copyWith(
          status: CoursesStatus.success,
          courses: courses,
          clearError: true,
        ),
      );
    } on AppException catch (e, st) {
      AppLogger.error('CoursesBloc fetch failed', error: e, stack: st);
      emit(
        state.copyWith(
          status: CoursesStatus.failure,
          errorMessage: ErrorMapper.toFailure(e).message,
        ),
      );
    } catch (e, st) {
      AppLogger.error('CoursesBloc unexpected error', error: e, stack: st);
      const failure = UnknownFailure();
      emit(
        state.copyWith(
          status: CoursesStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  void _onFilterChanged(
    CoursesFilterChanged event,
    Emitter<CoursesState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onSearchChanged(
    CoursesSearchChanged event,
    Emitter<CoursesState> emit,
  ) {
    emit(state.copyWith(search: event.query));
  }

  void _onFiltersCleared(
    CoursesFiltersCleared event,
    Emitter<CoursesState> emit,
  ) {
    emit(state.copyWith(filter: CourseFilter.all, search: ''));
  }
}