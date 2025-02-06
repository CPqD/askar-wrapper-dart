class ProfileDuplicatedException implements Exception {
  final String? message;

  ProfileDuplicatedException([this.message]);

  @override
  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
