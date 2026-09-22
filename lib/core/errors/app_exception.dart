/// Data-layer exceptions. Raised by datasources / network layer.
/// Mapped to [Failure] before reaching presentation.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause});
}

final class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timed out']);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

final class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'Forbidden']);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Not found']);
}

final class ValidationException extends AppException {
  const ValidationException(super.message, {this.fieldErrors});

  final Map<String, String>? fieldErrors;
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Server error']);
}

final class UnknownException extends AppException {
  const UnknownException([super.message = 'Something went wrong']);
}