import 'package:student_desktop/features/courses/data/mock_courses.dart';

import '../../domain/course.dart';
import '../../domain/repositories/courses_repository.dart';

/// Mock implementation — swap with API/local implementation when ready.
/// Bloc never has to change.
class CoursesRepositoryImpl implements CoursesRepository {
  const CoursesRepositoryImpl();

  @override
  Future<List<Course>> fetchCourses() async {
    // Simulate network latency so loading states are visible during dev.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return mockCourses;
  }
}