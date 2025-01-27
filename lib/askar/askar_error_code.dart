enum ErrorCode {
  success,
  backend,
  busy,
  duplicate,
  encryption,
  input,
  notFound,
  unexpected,
  unsupported,
  custom,
}

ErrorCode intToErrorCode(int code) {
  switch (code) {
    case 0:
      return ErrorCode.success;
    case 1:
      return ErrorCode.backend;
    case 2:
      return ErrorCode.busy;
    case 3:
      return ErrorCode.duplicate;
    case 4:
      return ErrorCode.encryption;
    case 5:
      return ErrorCode.input;
    case 6:
      return ErrorCode.notFound;
    case 7:
      return ErrorCode.unexpected;
    case 8:
      return ErrorCode.unsupported;
    case 100:
      return ErrorCode.custom;
    default:
      throw ArgumentError('Invalid error code: $code');
  }
}
