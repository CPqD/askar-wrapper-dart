import '../../askar/enums/askar_error_code.dart';

class ProfileDuplicatedException extends AskarException {
  ProfileDuplicatedException([super.message]);
}

class AskarSessionException extends AskarException {
  AskarSessionException([super.message]);
}

class AskarStoreException extends AskarException {
  AskarStoreException([super.message]);
}

class AskarScanException extends AskarException {
  AskarScanException([super.message]);
}

class AskarKeyEntryListException extends AskarException {
  AskarKeyEntryListException([super.message]);
}

class AskarEntryException extends AskarException {
  AskarEntryException([super.message]);
}

class AskarEntryListException extends AskarException {
  AskarEntryListException([super.message]);
}

class AskarKeyException extends AskarException {
  AskarKeyException([super.message]);
}

class AskarErrorCodeException extends AskarException {
  final ErrorCode errorCode;

  AskarErrorCodeException(this.errorCode);

  @override
  String toString() {
    return "Invalid Error Code: $errorCode";
  }
}

class AskarException implements Exception {
  final String? message;

  AskarException([this.message]);

  @override
  String toString() {
    if (message == null) return "Askar Exception";
    return "Askar Exception: $message";
  }
}
