import 'package:dio/dio.dart';

import '../../errors/app_exception.dart';

/// Converts DioException into typed [AppException].
/// Repositories catch [AppException] — never raw Dio.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: _map(err),
        stackTrace: err.stackTrace,
      ),
    );
  }

  AppException _map(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.transformTimeout =>
          const TimeoutException(),
        DioExceptionType.connectionError =>
          const NetworkException('No internet connection'),
        DioExceptionType.badResponse => _fromResponse(e.response),
        DioExceptionType.cancel => const UnknownException('Request cancelled'),
        DioExceptionType.unknown =>
          NetworkException(e.message ?? 'Network error', cause: e.error),
        DioExceptionType.badCertificate =>
          const NetworkException('Invalid certificate'),
      };

  AppException _fromResponse(Response? r) {
    final code = r?.statusCode ?? 0;
    final message = _message(r?.data);
    return switch (code) {
      400 => ValidationException(message ?? 'Bad request'),
      401 => const UnauthorizedException(),
      403 => const ForbiddenException(),
      404 => const NotFoundException(),
      422 => ValidationException(message ?? 'Invalid input'),
      >= 500 => ServerException(message ?? 'Server error'),
      _ => UnknownException(message ?? 'Unexpected error'),
    };
  }

  String? _message(Object? data) {
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }
}