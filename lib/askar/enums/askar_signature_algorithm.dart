enum SignatureAlgorithm {
  edDSA('eddsa'),
  eS256('es256'),
  eS256K('es256k'),
  eS384('es384');

  final String value;
  const SignatureAlgorithm(this.value);
}
