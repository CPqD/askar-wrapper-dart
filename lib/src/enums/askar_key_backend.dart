/// Represents the types of key backends supported by Askar.
enum KeyBackend {
  /// Software-based keys (default).
  software('software'),

  /// Keys generated and stored in the secure element of the device.
  secureElement('secure_element');

  /// The string value associated with the key backend.
  final String value;

  /// Constructs an instance of [KeyBackend] with the given string [value].
  const KeyBackend(this.value);
}
