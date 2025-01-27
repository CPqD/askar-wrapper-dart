enum KeyAlgorithm {
  aesA128Gcm('a128gcm'),
  aesA256Gcm('a256gcm'),
  aesA128CbcHs256('a128cbchs256'),
  aesA256CbcHs512('a256cbchs512'),
  aesA128Kw('a128kw'),
  aesA256Kw('a256kw'),
  bls12381G1('bls12381g1'),
  bls12381G2('bls12381g2'),
  bls12381G1G2('bls12381g1g2'),
  chacha20C20P('c20p'),
  chacha20XC20P('xc20p'),
  ed25519('ed25519'),
  x25519('x25519'),
  ecSecp256k1('k256'),
  ecSecp256r1('p256'),
  ecSecp384r1('p384');

  final String value;
  const KeyAlgorithm(this.value);
}
