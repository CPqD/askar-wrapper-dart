class ProfileDuplicatedException implements Exception {
  final String? message;

  ProfileDuplicatedException([this.message]);

  @override
  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}

class AskarSessionException implements Exception {
  final String? message;

  AskarSessionException([this.message]);

  @override
  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}

class AskarStoreException implements Exception {
  final String? message;

  AskarStoreException([this.message]);

  @override
  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}

class AskarKeyEntryListException implements Exception {
  final String? message;

  AskarKeyEntryListException([this.message]);

  @override
  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}

class AskarEntryException implements Exception {
  final String? message;

  AskarEntryException([this.message]);

  @override
  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}

class AskarKeyException implements Exception {
  final String? message;

  AskarKeyException([this.message]);

  @override
  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
