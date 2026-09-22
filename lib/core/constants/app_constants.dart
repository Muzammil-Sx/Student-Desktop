/// App-wide constants that are not secrets and not URLs.
abstract final class AppConstants {
  AppConstants._();

  static const String appName = 'Student Desktop';
  static const String appVersion = '0.1.0';

  // ---------- Layout ----------
  static const double sidebarWidth = 240;
  static const double windowMinWidth = 1024;
  static const double windowMinHeight = 700;
  static const double windowInitialWidth = 1280;
  static const double windowInitialHeight = 800;
  static const double contentMaxWidth = 1400;

  // ---------- Timing ----------
  static const Duration splashMinimumDuration = Duration(milliseconds: 800);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration cacheShortTtl = Duration(minutes: 5);
  static const Duration cacheMediumTtl = Duration(hours: 1);
  static const Duration cacheLongTtl = Duration(days: 1);

  // ---------- Sync ----------
  static const int syncBatchSize = 50;
  static const int syncMaxRetries = 5;
}