class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException: $message';
}

final class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.cause});
}

final class ValidationException extends AppException {
  const ValidationException(super.message, {super.cause});
}

final class FileStorageException extends AppException {
  const FileStorageException(super.message, {super.cause});
}

final class SubscriptionException extends AppException {
  const SubscriptionException(super.message, {super.cause});
}

final class PurchaseCancelledException extends AppException {
  const PurchaseCancelledException() : super('Purchase cancelled.');
}
