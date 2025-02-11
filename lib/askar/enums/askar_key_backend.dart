enum KeyBackend {
  software('software'),
  secureElement('secure_element');

  final String value;
  const KeyBackend(this.value);
}
