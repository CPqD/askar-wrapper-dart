// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../../askar/crypto/handles.dart';
import '../askar_wrapper.dart';
import '../crypto/askar_encrypted_buffer.dart';
import '../enums/askar_error_code.dart';
import '../enums/askar_key_algorithm.dart';
import '../enums/askar_key_backend.dart';
import '../enums/askar_signature_algorithm.dart';
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
  Uint8List aeadDecrypt(Uint8List ciphertext, Uint8List nonce) {
    final result = askarKeyAeadDecrypt(handle!, ciphertext, nonce);
    if (result.errorCode == ErrorCode.success) {}
    throw AskarKeyException("LocalKeyHandle Error: ${result.errorCode}");
  }

  @override
  AskarEncryptedBuffer aeadEncrypt(Uint8List message,
      {Uint8List? nonce, Uint8List? aad}) {
    final result = askarKeyAeadEncrypt(handle!, message, nonce: nonce, aad: aad);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException("LocalKeyHandle Error: ${result.errorCode}");
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
  LocalKeyHandle convert(KeyAlgorithm alg) {
    final result = askarKeyConvert(handle!, alg);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException("AskarKeyRepository convert Error: ${result.errorCode}");
  }

  @override
  Uint8List cryptoBox(LocalKeyHandle recipKey, LocalKeyHandle senderKey,
      Uint8List message, Uint8List nonce) {
    final result = askarKeyCryptoBox(recipKey, senderKey, message, nonce);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException("AskarKeyRepository cryptoBox Error: ${result.errorCode}");
  }

  @override
  Future<bool> cryptoBoxOpen() {
    // TODO: implement cryptoBoxOpen
    throw UnimplementedError();
  }

  @override
  Uint8List cryptoBoxRandomNonce() {
    final result = askarKeyCryptoBoxRandomNonce();
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException(
        "AskarKeyRepository cryptoBoxOpen Error: ${result.errorCode}");
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
  LocalKeyHandle deriveEcdh1Pu(
      KeyAlgorithm algorithm,
      LocalKeyHandle ephemeralKey,
      LocalKeyHandle senderKey,
      LocalKeyHandle recipientKey,
      Uint8List algId,
      Uint8List apu,
      Uint8List apv,
      {Uint8List? ccTag,
      required bool receive}) {
    final result = askarKeyDeriveEcdh1pu(
        algorithm, ephemeralKey, senderKey, recipientKey, algId, apu, apv,
        receive: receive);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException(
        "AskarKeyRepository deriveEcdh1Pu Error: ${result.errorCode}");
  }

  @override
  LocalKeyHandle deriveEcdhEs(
      KeyAlgorithm algorithm,
      LocalKeyHandle ephemeralKey,
      LocalKeyHandle recipientKey,
      Uint8List algId,
      Uint8List apu,
      Uint8List apv,
      bool receive) {
    final result = askarKeyDeriveEcdhEs(
        algorithm, ephemeralKey, recipientKey, algId, apu, apv, receive);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException("AskarKeyRepository deriveEcdhEs Error: ${result.errorCode}");
  }

  @override
  void free(LocalKeyHandle handle) {
    askarKeyFree(handle);
  }

  static LocalKeyHandle fromJwk(String jwk) {
    final result = askarKeyFromJwk(jwk);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException("AskarKeyRepository fromJwk Error: ${result.errorCode}");
  }

  @override
  LocalKeyHandle fromKeyExchange(
      KeyAlgorithm alg, LocalKeyHandle skHandle, LocalKeyHandle pkHandle) {
    final result = askarKeyFromKeyExchange(alg, skHandle, pkHandle);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException(
        "AskarKeyRepository fromKeyExchange Error: ${result.errorCode}");
  }

  static LocalKeyHandle fromPublicBytes(KeyAlgorithm algorithm, Uint8List publicBytes) {
    final result = askarKeyFromPublicBytes(algorithm, publicBytes);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException(
        "AskarKeyRepository fromPublicBytes Error: ${result.errorCode}");
  }

  static LocalKeyHandle fromSecretBytes(KeyAlgorithm algorithm, Uint8List secret) {
    final result = askarKeyFromSecretBytes(algorithm, secret);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException(
        "AskarKeyRepository fromPublicBytes Error: ${result.errorCode}");
  }

  static LocalKeyHandle fromSeed() {
    // TODO: implement getAlgorithm
    throw UnimplementedError();

    // final result = askarKeyFromSeed(alg, seed, method, out);
    // if (result.errorCode == ErrorCode.success) {
    //   return result.value;
    // }
    // throw AskarKeyException(
    //     "AskarKeyRepository fromPublicBytes Error: ${result.errorCode}");
  }

  @override
  KeyAlgorithm getAlgorithm() {
    checkHandle();
    final result = askarKeyGetAlgorithm(handle!);
    if (result.errorCode == ErrorCode.success) {
      KeyAlgorithm alg = KeyAlgorithm.values.firstWhere((e) {
        return e.value == result.value;
      }, orElse: () {
        throw AskarKeyEntryListException("Algoritmo listado no enum KeyAlgorithm");
      });
      return alg;
    }
    throw AskarKeyException("AskarKeyRepository getAlgorithm Error: ${result.errorCode}");
  }

  @override
  Future<bool> getEphemeral() {
    // TODO: implement getEphemeral
    throw UnimplementedError();
  }

  @override
  String getJwkPublic(KeyAlgorithm algorithm) {
    checkHandle();
    final result = askarKeyGetJwkPublic(handle!, algorithm);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException("AskarKeyRepository getJwkPublic Error: ${result.errorCode}");
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
  Uint8List getPublicBytes() {
    checkHandle();
    final result = askarKeyGetPublicBytes(handle!);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException(
        "AskarKeyRepository getPublicBytes Error: ${result.errorCode}");
  }

  @override
  Uint8List getSecretBytes() {
    checkHandle();
    final result = askarKeyGetSecretBytes(handle!);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException(
        "AskarKeyRepository getSecretBytes Error: ${result.errorCode}");
  }

  static StringListHandle getSupportedBackends() {
    final result = askarKeyGetSupportedBackends();
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException(
        "AskarKeyRepository getSupportedBackends Error: ${result.errorCode}");
  }

  @override
  Uint8List signMessage(Uint8List message, SignatureAlgorithm sigType) {
    checkHandle();
    final result = askarKeySignMessage(handle!, message, sigType);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException("AskarKeyRepository signMessage Error: ${result.errorCode}");
  }

  @override
  LocalKeyHandle unwrapKey(KeyAlgorithm algorithm, Uint8List ciphertext,
      {Uint8List? nonce, Uint8List? tag}) {
    checkHandle();
    final result = askarKeyUnwrapKey(handle!, algorithm, ciphertext);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException("AskarKeyRepository unwrapKey Error: ${result.errorCode}");
  }

  @override
  bool verifySignature(
      Uint8List message, Uint8List signature, SignatureAlgorithm sigType) {
    checkHandle();
    final result = askarKeyVerifySignature(handle!, message, signature, sigType);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return false;
  }

  @override
  AskarEncryptedBuffer wrapKey(LocalKeyHandle other, {Uint8List? nonce}) {
    final result = askarKeyWrapKey(handle!, other);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    throw AskarKeyException("AskarKeyRepository wrapKey Error: ${result.errorCode}");
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
