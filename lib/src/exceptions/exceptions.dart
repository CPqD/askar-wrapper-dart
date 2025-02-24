import '../../src/enums/askar_error_code.dart';

/// Base class for all Askar exceptions.
class AskarException implements Exception {
  /// A message describing the Askar Exception.
  final String? message;

  AskarException([this.message]);

  @override
  String toString() {
    if (message == null) return "Askar Exception";
    return "Askar Exception: $message";
  }
}

/// Exception thrown when a profile is duplicated.
class ProfileDuplicatedException extends AskarException {
  ProfileDuplicatedException([super.message]);
}

/// Exception thrown when a session-related error occurs.
class AskarSessionException extends AskarException {
  AskarSessionException([super.message]);
}

/// Exception thrown when a store-related error occurs.
class AskarStoreException extends AskarException {
  AskarStoreException([super.message]);
}

/// Exception thrown when a scan-related error occurs.
class AskarScanException extends AskarException {
  AskarScanException([super.message]);
}

/// Exception thrown when a key entry list-related error occurs.
class AskarKeyEntryListException extends AskarException {
  AskarKeyEntryListException([super.message]);
}

/// Exception thrown when an entry-related error occurs.
class AskarEntryException extends AskarException {
  AskarEntryException([super.message]);
}

/// Exception thrown when an entry list-related error occurs.
class AskarEntryListException extends AskarException {
  AskarEntryListException([super.message]);
}

/// Exception thrown when a key-related error occurs.
class AskarKeyException extends AskarException {
  AskarKeyException([super.message]);
}

/// Exception thrown when an error code-related error occurs.
class AskarErrorCodeException extends AskarException {
  /// The [ErrorCode] associated with the exception.
  final ErrorCode errorCode;

  AskarErrorCodeException(this.errorCode);

  @override
  String toString() {
    return "Invalid Error Code: $errorCode";
  }
}
