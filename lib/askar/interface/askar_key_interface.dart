import 'dart:typed_data';

import 'package:import_so_libaskar/askar/askar_wrapper.dart';
import 'package:import_so_libaskar/askar/enums/askar_key_algorithm.dart';
import 'package:import_so_libaskar/askar/enums/askar_key_backend.dart';

import '../enums/askar_error_code.dart';
import '../exceptions/exceptions.dart';

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
  Future<bool> getJwkThumbprint();
  Future<bool> getPublicBytes();
  Future<bool> getSecretBytes();
  Future<bool> getSupportedBackends(); //Sem Entrada de LocalKeyHandle nem saída
  Future<bool> signMessage();
  Future<bool> unwrapKey();
  Future<bool> verifySignature();
  Future<bool> wrapKey();

  //Sem Entrada de LocalKeyHandle -- SAIDA
  static LocalKeyHandle generate(
      KeyAlgorithm alg, KeyBackend keyBackend, bool ephemeral) {
    final result = askarKeyGenerate(alg, keyBackend, ephemeral);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException("Erro ao gerar chave");
  }
}
