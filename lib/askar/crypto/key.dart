import 'dart:typed_data';

import 'package:askar_flutter_sdk/askar/crypto/encrypted_buffer.dart';
import 'package:askar_flutter_sdk/askar/crypto/handles.dart';
import 'package:askar_flutter_sdk/askar/crypto/jwk.dart';

import '../../askar/askar_wrapper.dart';
import '../../askar/enums/askar_key_algorithm.dart';
import '../../askar/enums/askar_key_backend.dart';
import '../../askar/enums/askar_signature_algorithm.dart';
import '../../askar/exceptions/exceptions.dart';

class Key {
  final LocalKeyHandle localKeyHandle;

  Key(this.localKeyHandle);

  static Key generate(KeyAlgorithm algorithm, KeyBackend keyBackend,
      {bool ephemeral = false}) {
    try {
      return Key(
          askarKeyGenerate(algorithm, keyBackend, ephemeral).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Error generating key: $e');
    }
  }

  // TODO
  // static AskarKey fromSeed(
  //     {required KeyAlgorithm algorithm,
  //     required Uint8List seed,
  //     KeyMethod method = KeyMethod.none}) {
  //   try {
  //     return AskarKey(askarKeyFromSeed(algorithm, seed, method).value);
  //   } catch (e) {
  //     throw AskarKeyException('Error getting key from seed: $e');
  //   }
  // }

  static Key fromSecretBytes(
      {required KeyAlgorithm algorithm, required Uint8List secretKey}) {
    try {
      return Key(askarKeyFromSecretBytes(algorithm, secretKey).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to get key from secret bytes: $e');
    }
  }

  static Key fromPublicBytes(
      {required KeyAlgorithm algorithm, required Uint8List publicKey}) {
    try {
      return Key(askarKeyFromPublicBytes(algorithm, publicKey).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to get key from public bytes: $e');
    }
  }

  static Key fromJwk({required Jwk jwk}) {
    try {
      return Key(askarKeyFromJwk(jwk.toString()).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to get key from JWK: $e');
    }
  }

  Key convertKey({required KeyAlgorithm algorithm}) {
    try {
      return Key(askarKeyConvert(localKeyHandle, algorithm).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to convert key from algorithm: $e');
    }
  }

  Key keyFromKeyExchange(
      {required KeyAlgorithm algorithm, required Key secretKey, required Key publicKey}) {
    try {
      return Key(askarKeyFromKeyExchange(algorithm, secretKey.handle, publicKey.handle)
          .getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to get key from key exchange: $e');
    }
  }

  LocalKeyHandle get handle => localKeyHandle;

  KeyAlgorithm get algorithm {
    try {
      return KeyAlgorithm.fromString(
          askarKeyGetAlgorithm(localKeyHandle).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to get key algorithm: $e');
    }
  }

  // TODO
  // bool get ephemeral => askar.keyGetEphemeral(localKeyHandle: handle);

  Uint8List get publicBytes {
    try {
      return askarKeyGetPublicBytes(localKeyHandle).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to get key public bytes: $e');
    }
  }

  Uint8List get secretBytes {
    try {
      return askarKeyGetSecretBytes(localKeyHandle).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to get key secret bytes: $e');
    }
  }

  Jwk get jwkPublic {
    try {
      return Jwk.fromString(
          askarKeyGetJwkPublic(localKeyHandle, algorithm).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to get JWK public: $e');
    }
  }

  // TODO
  // Jwk get jwkSecret {
  //   final secretBytes = askar.keyGetJwkSecret(localKeyHandle: handle);
  //   return Jwk.fromString(Buffer.from(secretBytes).toString());
  // }

  String get jwkThumbprint {
    try {
      return askarKeyGetJwkThumbprint(localKeyHandle, algorithm).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to get jwk thumbprint: $e');
    }
  }

  // TODO
  // Map<String, dynamic> get aeadParams => askar.keyAeadGetParams(localKeyHandle: handle);

  Uint8List get aeadRandomNonce {
    try {
      return askarKeyAeadRandomNonce(localKeyHandle).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Error generating random nonce: $e');
    }
  }

  EncryptedBuffer aeadEncrypt(
      {required Uint8List message, Uint8List? nonce, Uint8List? aad}) {
    try {
      return askarKeyAeadEncrypt(localKeyHandle, message, nonce: nonce, aad: aad)
          .getValueOrException();
    } catch (e) {
      throw AskarKeyException('Error on AEAD Encryption: $e');
    }
  }

  Uint8List aeadDecrypt(
      {required Uint8List ciphertext,
      required Uint8List nonce,
      Uint8List? tag,
      Uint8List? aad}) {
    try {
      return askarKeyAeadDecrypt(localKeyHandle, ciphertext, nonce, tag: tag, aad: aad)
          .getValueOrException();
    } catch (e) {
      throw AskarKeyException('Error on AEAD Decryption: $e');
    }
  }

  Uint8List signMessage(
      {required Uint8List message, required SignatureAlgorithm sigType}) {
    try {
      return askarKeySignMessage(localKeyHandle, message, sigType).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to sign message: $e');
    }
  }

  bool verifySignature(
      {required Uint8List message,
      required Uint8List signature,
      required SignatureAlgorithm sigType}) {
    try {
      return askarKeyVerifySignature(localKeyHandle, message, signature, sigType)
          .getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to verify signature: $e');
    }
  }

  EncryptedBuffer wrapKey({required Key other, Uint8List? nonce}) {
    try {
      return askarKeyWrapKey(localKeyHandle, other.handle, nonce: nonce)
          .getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to wrap key: $e');
    }
  }

  Key unwrapKey(
      {required KeyAlgorithm algorithm,
      Uint8List? tag,
      required Uint8List ciphertext,
      Uint8List? nonce}) {
    try {
      return Key(
          askarKeyUnwrapKey(localKeyHandle, algorithm, ciphertext, nonce: nonce, tag: tag)
              .getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to unwrap key: $e');
    }
  }
}
