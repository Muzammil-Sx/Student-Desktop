import 'package:dio/dio.dart';

import 'app_exception.dart';
import 'failure.dart';

/// Maps any error into a domain [Failure].
/// Single source of truth — no per-repository mapping.
abstract final class ErrorMapper {
  ErrorMapper._();

  static Failure toFailure(Object error) {
    if (error is Failure) return error;
    if (error is AppException) return _fromException(error);
    if (error is DioException) return _fromDio(error);
    return UnknownFailure(error.toString());
  }

  static Failure _fromException(AppException e) => switch (e) {
        NetworkException() => NetworkFailure(e.message),
        TimeoutException() => TimeoutFailure(e.message),
        UnauthorizedException() => UnauthorizedFailure(e.message),
        ForbiddenException() => ForbiddenFailure(e.message),
        NotFoundException() => NotFoundFailure(e.message),
        ValidationException(:final fieldErrors) =>
          ValidationFailure(e.message, fieldErrors: fieldErrors),
        ServerException() => ServerFailure(e.message),
        UnknownException() => UnknownFailure(e.message),
      };

  static Failure _fromDio(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.transformTimeout =>
          const TimeoutFailure(),
        DioExceptionType.connectionError => const NetworkFailure(),
        DioExceptionType.badCertificate =>
          const NetworkFailure('Invalid certificate'),
        DioExceptionType.cancel => const UnknownFailure('Request cancelled'),
        DioExceptionType.badResponse => _fromStatus(e),
        DioExceptionType.unknown => e.error is AppException
            ? _fromException(e.error! as AppException)
            : const UnknownFailure(),
      };

  static Failure _fromStatus(DioException e) {
    final code = e.response?.statusCode ?? 0;
    return switch (code) {
      400 => ValidationFailure(_messageOf(e) ?? 'Bad request'),
      401 => const UnauthorizedFailure(),
      403 => const ForbiddenFailure(),
      404 => const NotFoundFailure(),
      422 => ValidationFailure(_messageOf(e) ?? 'Invalid input'),
      >= 500 => ServerFailure(_messageOf(e) ?? 'Server error'),
      _ => UnknownFailure(_messageOf(e) ?? 'Unexpected error'),
    };
  }

  static String? _messageOf(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }
}