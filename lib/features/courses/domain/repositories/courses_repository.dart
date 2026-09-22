import '../course.dart';

/// Abstract contract for fetching courses.
/// Implementation may be API, local DB, or mock.
abstract interface class CoursesRepository {
  Future<List<Course>> fetchCourses();
}