// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../askar_wrapper.dart';
import '../enums/askar_error_code.dart';
import '../enums/askar_key_algorithm.dart';
import '../enums/askar_key_backend.dart';
import '../exceptions/exceptions.dart';
import '../interface/askar_key_interface.dart';

class AskarKeyRepository implements IAskarKey {
  //LocalKeyHandle é necessário
  //Obtido em this.convert, this.deriveEcdh1Pu, this.deriveEcdhEs,
  // this.fromJwk, this.fromKeyExchange, this.fromPublicBytes, this.fromSecretBytes,
  // this.fromSeed, this.generate, this.unwrapKey,
  // ******this.generate -> static ???
  // AskarKeyEntryList.loadLocal

  LocalKeyHandle? handle;

  AskarKeyRepository({
    required this.handle,
  });

  @override
  Future<bool> aeadDecrypt() {
    // TODO: implement aeadDecrypt
    throw UnimplementedError();
  }

  @override
  Future<bool> aeadEncrypt() {
    // TODO: implement aeadEncrypt
    throw UnimplementedError();
  }

  @override
  Future<bool> aeadGetPadding() {
    // TODO: implement aeadGetPadding
    throw UnimplementedError();
  }

  @override
  Future<bool> aeadGetParams() {
    // TODO: implement aeadGetParams
    throw UnimplementedError();
  }

  @override
  Uint8List aeadRandomNonce() {
    checkHandle();
    final result = askarKeyAeadRandomNonce(handle!);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }

    throw AskarKeyException("Erro ao gerar nonce aleatório");
  }

  @override
  Future<bool> convert() {
    // TODO: implement convert
    throw UnimplementedError();
  }

  @override
  Future<bool> cryptoBox() {
    // TODO: implement cryptoBox
    throw UnimplementedError();
  }

  @override
  Future<bool> cryptoBoxOpen() {
    // TODO: implement cryptoBoxOpen
    throw UnimplementedError();
  }

  @override
  Future<bool> cryptoBoxRandomNonce() {
    // TODO: implement cryptoBoxRandomNonce
    throw UnimplementedError();
  }

  @override
  Future<bool> cryptoBoxSeal() {
    // TODO: implement cryptoBoxSeal
    throw UnimplementedError();
  }

  @override
  Future<bool> cryptoBoxSealOpen() {
    // TODO: implement cryptoBoxSealOpen
    throw UnimplementedError();
  }

  @override
  Future<bool> deriveEcdh1Pu() {
    // TODO: implement deriveEcdh1Pu
    throw UnimplementedError();
  }

  @override
  Future<bool> deriveEcdhEs() {
    // TODO: implement deriveEcdhEs
    throw UnimplementedError();
  }

  @override
  Future<bool> free() {
    // TODO: implement free
    throw UnimplementedError();
  }

  @override
  Future<bool> fromJwk() {
    // TODO: implement fromJwk
    throw UnimplementedError();
  }

  @override
  Future<bool> fromKeyExchange() {
    // TODO: implement fromKeyExchange
    throw UnimplementedError();
  }

  @override
  Future<bool> fromPublicBytes() {
    // TODO: implement fromPublicBytes
    throw UnimplementedError();
  }

  @override
  Future<bool> fromSecretBytes() {
    // TODO: implement fromSecretBytes
    throw UnimplementedError();
  }

  @override
  Future<bool> fromSeed() {
    // TODO: implement fromSeed
    throw UnimplementedError();
  }

  @override
  Future<bool> getAlgorithm() {
    // TODO: implement getAlgorithm
    throw UnimplementedError();
  }

  @override
  Future<bool> getEphemeral() {
    // TODO: implement getEphemeral
    throw UnimplementedError();
  }

  @override
  Future<bool> getJwkPublic() {
    // TODO: implement getJwkPublic
    throw UnimplementedError();
  }

  @override
  Future<bool> getJwkSecret() {
    // TODO: implement getJwkSecret
    throw UnimplementedError();
  }

  @override
  String getJwkThumbprint(KeyAlgorithm alg) {
    checkHandle();
    final result = askarKeyGetJwkThumbprint(handle!, alg);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException("Erro ao gerar Thumbprint");
  }

  @override
  Future<bool> getPublicBytes() {
    // TODO: implement getPublicBytes
    throw UnimplementedError();
  }

  @override
  Future<bool> getSecretBytes() {
    // TODO: implement getSecretBytes
    throw UnimplementedError();
  }

  @override
  Future<bool> getSupportedBackends() {
    // TODO: implement getSupportedBackends
    throw UnimplementedError();
  }

  @override
  Future<bool> signMessage() {
    // TODO: implement signMessage
    throw UnimplementedError();
  }

  @override
  Future<bool> unwrapKey() {
    // TODO: implement unwrapKey
    throw UnimplementedError();
  }

  @override
  Future<bool> verifySignature() {
    // TODO: implement verifySignature
    throw UnimplementedError();
  }

  @override
  Future<bool> wrapKey() {
    // TODO: implement wrapKey
    throw UnimplementedError();
  }

  static LocalKeyHandle generate(
      KeyAlgorithm alg, KeyBackend keyBackend, bool ephemeral) {
    final result = askarKeyGenerate(alg, keyBackend, ephemeral);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException("Erro ao gerar chave");
  }

  checkHandle() {
    if (handle == null) {
      throw AskarKeyException("LocalKeyHandle não inicializado");
    }
  }
}
