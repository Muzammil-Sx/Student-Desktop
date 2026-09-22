/// API URLs. Base URL is injected via [String.fromEnvironment] at build time.
/// Example:
///   flutter run -d windows --dart-define=API_BASE_URL=https://api.example.com
abstract final class AppUrls {
  AppUrls._();

  static const String _base = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  );

  static String get baseUrl => _base;

  // ---------- Auth ----------
  static String get login => '$_base/auth/login';
  static String get logout => '$_base/auth/logout';
  static String get refresh => '$_base/auth/refresh';

  // ---------- Dashboard ----------
  static String get dashboardSummary => '$_base/dashboard/summary';

  // ---------- Courses ----------
  static String get courses => '$_base/courses';
  static String courseById(int id) => '$_base/courses/$id';
}