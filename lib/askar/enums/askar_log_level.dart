enum LogLevel {
  rustLog(-1),
  off(0),
  error(1),
  warn(2),
  info(3),
  debug(4),
  trace(5);

  final int value;
  const LogLevel(this.value);
}
