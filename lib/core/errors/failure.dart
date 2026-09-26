enum FailureType { database, validation, storage, unexpected }

final class Failure {
  const Failure({required this.type, required this.message, this.cause});

  final FailureType type;
  final String message;
  final Object? cause;
}
