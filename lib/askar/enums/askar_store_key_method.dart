/// Represents the methods for deriving store keys supported by Askar.
///
/// This enum specifies the different key derivation methods that can be used to generate store keys.
enum StoreKeyMethod {
  /// Raw key method.
  raw('raw'),

  /// No key derivation method.
  none('none'),

  /// Argon2i key derivation method with moderate memory and CPU usage.
  argon2IMod('kdf:argon2i:mod'),

  /// Argon2i key derivation method with intensive memory and CPU usage.
  argon2IInt('kdf:argon2i:int');

  /// The string value associated with the store key method.
  final String value;

  /// Constructs an instance of [StoreKeyMethod] with the given string [value].
  const StoreKeyMethod(this.value);
}
