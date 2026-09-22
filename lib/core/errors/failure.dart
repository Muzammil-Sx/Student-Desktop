/// Domain-layer failure. Presentation layer consumes this.
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Session expired']);
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = 'Access denied']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.fieldErrors});

  final Map<String, String>? fieldErrors;
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong']);
}