/// Represents the different log levels supported by Askar.
enum LogLevel {
  /// Log level for Rust logging.
  rustLog(-1),

  /// Logging is turned off.
  off(0),

  /// Log level for error messages.
  error(1),

  /// Log level for warning messages.
  warn(2),

  /// Log level for informational messages.
  info(3),

  /// Log level for debug messages.
  debug(4),

  /// Log level for trace messages.
  trace(5);

  /// The integer value associated with the log level.
  final int value;

  /// Constructs an instance of [LogLevel] with the given integer [value].
  const LogLevel(this.value);
}
