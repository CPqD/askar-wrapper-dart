/// Represents the key generation methods supported by Askar.
enum KeyMethod {
  /// No specific key generation method.
  none(''),

  /// BLS key generation method.
  blsKeygen('bls_keygen');

  /// The string value associated with the key method.
  final String value;

  /// Constructs an instance of [KeyMethod] with the given string [value].
  const KeyMethod(this.value);
}
