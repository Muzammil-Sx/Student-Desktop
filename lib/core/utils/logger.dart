import 'package:flutter/foundation.dart';

/// Minimal, redacting logger.
/// - Silent in release builds (except [error]).
/// - Redacts sensitive keys before printing.
abstract final class AppLogger {
  AppLogger._();

  static const _sensitiveKeys = {
    'password',
    'token',
    'access_token',
    'refresh_token',
    'authorization',
    'apikey',
    'api_key',
    'secret',
    'email',
  };

  static void debug(String message, {Map<String, Object?>? data}) {
    if (!kDebugMode) return;
    _log('DEBUG', message, data);
  }

  static void info(String message, {Map<String, Object?>? data}) {
    if (!kDebugMode) return;
    _log('INFO', message, data);
  }

  static void warn(String message, {Map<String, Object?>? data}) {
    if (!kDebugMode) return;
    _log('WARN', message, data);
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stack,
    Map<String, Object?>? data,
  }) {
    _log('ERROR', message, data);
    if (error != null) debugPrint('  └─ error: $error');
    if (stack != null && kDebugMode) debugPrint('  └─ $stack');
  }

  static void _log(String level, String message, Map<String, Object?>? data) {
    final safe = data == null ? '' : ' ${_redact(data)}';
    debugPrint('[${DateTime.now().toIso8601String()}] $level $message$safe');
  }

  static Map<String, Object?> _redact(Map<String, Object?> data) => {
        for (final e in data.entries)
          e.key: _sensitiveKeys.contains(e.key.toLowerCase())
              ? '***'
              : e.value,
      };
}