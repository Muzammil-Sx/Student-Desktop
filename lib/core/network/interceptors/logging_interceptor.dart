import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../utils/logger.dart';

/// Logs requests/responses in debug mode only.
/// Redacts sensitive headers and body keys.
class LoggingInterceptor extends Interceptor {
  static const _redactedHeaders = {'authorization', 'cookie', 'set-cookie'};
  static const _redactedBodyKeys = {
    'password',
    'token',
    'access_token',
    'refresh_token',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.debug(
        '➡ ${options.method} ${options.uri}',
        data: {
          'headers': _redactHeaders(options.headers),
          if (options.data != null) 'body': _redactBody(options.data),
        },
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.debug(
        '✅ ${response.statusCode} ${response.requestOptions.uri}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '❌ ${err.requestOptions.method} ${err.requestOptions.uri}',
      error: err.type,
      data: {'status': err.response?.statusCode},
    );
    handler.next(err);
  }

  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) => {
        for (final e in headers.entries)
          e.key: _redactedHeaders.contains(e.key.toLowerCase())
              ? '***'
              : e.value,
      };

  Object? _redactBody(Object? body) {
    if (body is Map) {
      return {
        for (final e in body.entries)
          e.key: _redactedBodyKeys.contains(e.key.toString().toLowerCase())
              ? '***'
              : e.value,
      };
    }
    return body;
  }
}