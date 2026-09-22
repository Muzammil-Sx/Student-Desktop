/// Centralized cache keys — avoids typos and duplicates.
abstract final class CacheKeys {
  CacheKeys._();

  static const String courses = 'cache.courses';
  static const String students = 'cache.students';
  static const String dashboardSummary = 'cache.dashboard.summary';
  static const String userProfile = 'cache.user.profile';

  /// Prefix for all cache keys — helps bulk-clear cache on logout.
  static const String prefix = 'cache.';

  static String withUser(int userId, String key) => 'cache.u$userId.$key';
}