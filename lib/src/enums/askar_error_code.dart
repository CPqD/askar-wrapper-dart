import '../exceptions/exceptions.dart';

/// Represents error codes used in the Askar SDK.
enum ErrorCode {
  /// Operation was successful.
  success(0),

  /// Backend error occurred.
  backend(1),

  /// Operation is busy.
  busy(2),

  /// Duplicate entry found.
  duplicate(3),

  /// Encryption error occurred.
  encryption(4),

  /// Input error occurred.
  input(5),

  /// Entry not found.
  notFound(6),

  /// Unexpected error occurred.
  unexpected(7),

  /// Operation is unsupported.
  unsupported(8),

  /// Custom error occurred.
  custom(100);

  /// The integer value associated with the error code.
  final int code;

  /// Constructs an instance of [ErrorCode] with the given integer [code].
  const ErrorCode(this.code);

  /// Returns the [ErrorCode] corresponding to the given integer [code].
  ///
  /// Throws an [ArgumentError] if the code is invalid.
  static ErrorCode fromInt(int code) {
    return ErrorCode.values.firstWhere(
      (e) => e.code == code,
      orElse: () => throw ArgumentError('Invalid error code: $code'),
    );
  }

  /// Checks if the error code represents a successful operation.
  bool isSuccess() {
    return (code == ErrorCode.success.code);
  }

  /// Throws an [AskarErrorCodeException] if the error code is not successful.
  void throwOnError() {
    if (!isSuccess()) {
      throw AskarErrorCodeException(ErrorCode.fromInt(code));
    }
  }
}
