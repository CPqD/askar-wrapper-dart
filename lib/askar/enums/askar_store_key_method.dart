enum StoreKeyMethod {
  raw('raw'),
  none('none'),
  argon2IMod('kdf:argon2i:mod'),
  argon2IInt('kdf:argon2i:int');

  final String value;
  const StoreKeyMethod(this.value);
}
