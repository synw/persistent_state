/// An exception for an error with the state database
class StateStorageException implements Exception {
  /// Provide a message
  StateStorageException(this.message);

  /// The error message
  final String message;

  @override
  String toString() => message;
}
