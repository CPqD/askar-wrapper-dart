import 'dart:typed_data';

import '../enums/askar_key_algorithm.dart';

abstract class IAskarKey {
  Future<bool> aeadDecrypt();
  Future<bool> aeadEncrypt();
  Future<bool> aeadGetPadding();
  Future<bool> aeadGetParams();
  Uint8List aeadRandomNonce();
  Future<bool> convert();
  Future<bool> cryptoBox();
  Future<bool> cryptoBoxOpen();
  Future<bool> cryptoBoxRandomNonce(); //Sem Entrada de LocalKeyHandle
  Future<bool> cryptoBoxSeal();
  Future<bool> cryptoBoxSealOpen();
  Future<bool> deriveEcdh1Pu();
  Future<bool> deriveEcdhEs();
  Future<bool> free();
  Future<bool> fromJwk(); //Sem Entrada de LocalKeyHandle -- SAIDA
  Future<bool> fromKeyExchange();
  Future<bool> fromPublicBytes(); //Sem Entrada de LocalKeyHandle -- SAIDA
  Future<bool> fromSecretBytes(); //Sem Entrada de LocalKeyHandle -- SAIDA
  Future<bool> fromSeed(); //Sem Entrada de LocalKeyHandle -- SAIDA

  Future<bool> getAlgorithm();
  Future<bool> getEphemeral();
  Future<bool> getJwkPublic();
  Future<bool> getJwkSecret();
  String getJwkThumbprint(KeyAlgorithm alg);
  Future<bool> getPublicBytes();
  Future<bool> getSecretBytes();
  Future<bool> getSupportedBackends(); //Sem Entrada de LocalKeyHandle nem saída
  Future<bool> signMessage();
  Future<bool> unwrapKey();
  Future<bool> verifySignature();
  Future<bool> wrapKey();

  //Sem Entrada de LocalKeyHandle -- SAIDA
  //Implementação Estática no Repositório
  //LocalKeyHandle generate();
}
