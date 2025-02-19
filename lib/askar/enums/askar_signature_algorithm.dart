/// Represents the different signature algorithms supported by Askar.
enum SignatureAlgorithm {
  /// Edwards-curve Digital Signature Algorithm (EdDSA).
  edDSA('eddsa'),

  /// ECDSA using P-256 and SHA-256.
  eS256('es256'),

  /// ECDSA using secp256k1 and SHA-256.
  eS256K('es256k'),

  /// ECDSA using P-384 and SHA-384.
  eS384('es384');

  /// The string value associated with the signature algorithm.
  final String value;

  /// Constructs an instance of [SignatureAlgorithm] with the given string [value].
  const SignatureAlgorithm(this.value);
}
