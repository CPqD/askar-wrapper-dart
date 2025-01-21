enum ErrorCode {
  Success,
  Backend,
  Busy,
  Duplicate,
  Encryption,
  Input,
  NotFound,
  Unexpected,
  Unsupported,
  Custom,
}

ErrorCode intToErrorCode(int code) {
  switch (code) {
    case 0:
      return ErrorCode.Success;
    case 1:
      return ErrorCode.Backend;
    case 2:
      return ErrorCode.Busy;
    case 3:
      return ErrorCode.Duplicate;
    case 4:
      return ErrorCode.Encryption;
    case 5:
      return ErrorCode.Input;
    case 6:
      return ErrorCode.NotFound;
    case 7:
      return ErrorCode.Unexpected;
    case 8:
      return ErrorCode.Unsupported;
    case 100:
      return ErrorCode.Custom;
    default:
      throw ArgumentError('Invalid error code: $code');
  }
}
