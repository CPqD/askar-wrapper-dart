enum ErrorCode {
  success(0),
  backend(1),
  busy(2),
  duplicate(3),
  encryption(4),
  input(5),
  notFound(6),
  unexpected(7),
  unsupported(8),
  custom(100);

  final int code;
  const ErrorCode(this.code);

  static ErrorCode fromInt(int code) {
    return ErrorCode.values.firstWhere(
      (e) => e.code == code,
      orElse: () => throw ArgumentError('Invalid error code: $code'),
    );
  }
}
