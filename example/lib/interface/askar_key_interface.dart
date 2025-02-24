import 'dart:typed_data';

import 'package:askar_wrapper_dart/askar_wrapper_dart.dart';

// TODO fix comments and documentation
abstract class IAskarKey {
  Uint8List aeadDecrypt(Uint8List ciphertext, Uint8List nonce);
  EncryptedBuffer aeadEncrypt(Uint8List message, {Uint8List? nonce, Uint8List? aad});
  Future<bool> aeadGetPadding();
  Future<bool> aeadGetParams();
  Uint8List aeadRandomNonce();
  LocalKeyHandle convert(KeyAlgorithm alg);
  Uint8List cryptoBox(
    LocalKeyHandle recipKey,
    LocalKeyHandle senderKey,
    Uint8List message,
    Uint8List nonce,
  );
  Future<bool> cryptoBoxOpen();
  Uint8List cryptoBoxRandomNonce(); //Sem Entrada de LocalKeyHandle
  Future<bool> cryptoBoxSeal();
  Future<bool> cryptoBoxSealOpen();
  LocalKeyHandle deriveEcdh1Pu(
    KeyAlgorithm algorithm,
    LocalKeyHandle ephemeralKey,
    LocalKeyHandle senderKey,
    LocalKeyHandle recipientKey,
    Uint8List algId,
    Uint8List apu,
    Uint8List apv, {
    Uint8List? ccTag,
    required bool receive,
  });
  LocalKeyHandle deriveEcdhEs(
    KeyAlgorithm algorithm,
    LocalKeyHandle ephemeralKey,
    LocalKeyHandle recipientKey,
    Uint8List algId,
    Uint8List apu,
    Uint8List apv,
    bool receive,
  );
  void free(LocalKeyHandle handle);

  //implementação Estática????
  // LocalKeyHandle fromJwk(); //Sem Entrada de LocalKeyHandle -- SAIDA
  LocalKeyHandle fromKeyExchange(
    KeyAlgorithm alg,
    LocalKeyHandle skHandle,
    LocalKeyHandle pkHandle,
  );

  //implementação Estática????
  // LocalKeyHandle fromPublicBytes(KeyAlgorithm algorithm,
  // Uint8List publicBytes); //Sem Entrada de LocalKeyHandle -- SAIDA

  //implementação Estática????
  // Future<bool> fromSecretBytes(); //Sem Entrada de LocalKeyHandle -- SAIDA

  //implementação Estática????
  // Future<bool> fromSeed(); //Sem Entrada de LocalKeyHandle -- SAIDA

  KeyAlgorithm getAlgorithm();
  Future<bool> getEphemeral();
  String getJwkPublic(KeyAlgorithm algorithm);
  Future<bool> getJwkSecret();
  String getJwkThumbprint(KeyAlgorithm alg);
  Uint8List getPublicBytes();
  Uint8List getSecretBytes();

  //implementação Estática???
  // StringListHandle getSupportedBackends();
  //Sem Entrada de LocalKeyHandle nem saída
  Uint8List signMessage(Uint8List message, SignatureAlgorithm sigType);
  LocalKeyHandle unwrapKey(
    KeyAlgorithm algorithm,
    Uint8List ciphertext, {
    Uint8List? nonce,
    Uint8List? tag,
  });
  bool verifySignature(
    Uint8List message,
    Uint8List signature,
    SignatureAlgorithm sigType,
  );
  EncryptedBuffer wrapKey(LocalKeyHandle other, {Uint8List? nonce});

  //Sem Entrada de LocalKeyHandle -- SAIDA
  //Implementação Estática no Repositório
  //LocalKeyHandle generate();
}
