/// Represents the different key algorithms supported by Askar.
enum KeyAlgorithm {
  /// AES with 128-bit GCM mode.
  aesA128Gcm('a128gcm'),

  /// AES with 256-bit GCM mode.
  aesA256Gcm('a256gcm'),

  /// AES with 128-bit CBC mode and HMAC-SHA-256.
  aesA128CbcHs256('a128cbchs256'),

  /// AES with 256-bit CBC mode and HMAC-SHA-512.
  aesA256CbcHs512('a256cbchs512'),

  /// AES with 128-bit key wrapping.
  aesA128Kw('a128kw'),

  /// AES with 256-bit key wrapping.
  aesA256Kw('a256kw'),

  /// BLS12-381 curve, G1 subgroup.
  bls12381G1('bls12381g1'),

  /// BLS12-381 curve, G2 subgroup.
  bls12381G2('bls12381g2'),

  /// BLS12-381 curve, both G1 and G2 subgroups.
  bls12381G1G2('bls12381g1g2'),

  /// ChaCha20 with Poly1305.
  chacha20C20P('c20p'),

  /// XChaCha20 with Poly1305.
  chacha20XC20P('xc20p'),

  /// Ed25519 signature algorithm.
  ed25519('ed25519'),

  /// X25519 key exchange algorithm.
  x25519('x25519'),

  /// Elliptic Curve SECP256K1.
  ecSecp256k1('k256'),

  /// Elliptic Curve SECP256R1.
  ecSecp256r1('p256'),

  /// Elliptic Curve SECP384R1.
  ecSecp384r1('p384');

  /// The string value associated with the key algorithm.
  final String value;

  /// Constructs an instance of [KeyAlgorithm] with the given string [value].
  const KeyAlgorithm(this.value);

  /// Returns the [KeyAlgorithm] corresponding to the given string [algorithm].
  ///
  /// Throws an [ArgumentError] if the algorithm is invalid.
  static KeyAlgorithm fromString(String algorithm) {
    return KeyAlgorithm.values.firstWhere(
      (e) => e.value == algorithm,
      orElse: () => throw ArgumentError('Invalid KeyAlgorithm: $algorithm'),
    );
  }
}
