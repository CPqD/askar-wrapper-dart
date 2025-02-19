import 'dart:convert';
import 'dart:typed_data';

import 'package:askar_flutter_sdk/askar/crypto/aead_params.dart';
import 'package:askar_flutter_sdk/askar/crypto/encrypted_buffer.dart';
import 'package:askar_flutter_sdk/askar/crypto/handles.dart';
import 'package:askar_flutter_sdk/askar/crypto/jwk.dart';

import '../../askar/askar_wrapper.dart';
import '../../askar/enums/askar_key_algorithm.dart';
import '../../askar/enums/askar_key_backend.dart';
import '../../askar/enums/askar_signature_algorithm.dart';
import '../../askar/exceptions/exceptions.dart';
import '../enums/askar_key_method.dart';

/// An active key or keypair instance.
class Key {
  final LocalKeyHandle localKeyHandle;

  /// Initializes the [Key] instance.
  Key(this.localKeyHandle);

  LocalKeyHandle get handle => localKeyHandle;

  /// Generates a new key.
  ///
  /// Throws an [AskarKeyException] if key generation fails.
  static Key generate(KeyAlgorithm algorithm, KeyBackend keyBackend,
      {bool ephemeral = false}) {
    try {
      return Key(
          askarKeyGenerate(algorithm, keyBackend, ephemeral).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Error generating key: $e');
    }
  }

  /// Creates a new deterministic key or keypair from a seed.
  ///
  /// Throws an [AskarKeyException] if key creation fails.
  static Key fromSeed(
      {required KeyAlgorithm algorithm,
      required Uint8List seed,
      KeyMethod method = KeyMethod.none}) {
    try {
      return Key(askarKeyFromSeed(algorithm, seed, method).value);
    } catch (e) {
      throw AskarKeyException('Error getting key from seed: $e');
    }
  }

  /// Creates a new key instance from a slice of key secret bytes.
  ///
  /// Throws an [AskarKeyException] if key creation fails.
  static Key fromSecretBytes(
      {required KeyAlgorithm algorithm, required Uint8List secretKey}) {
    try {
      return Key(askarKeyFromSecretBytes(algorithm, secretKey).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to get key from secret bytes: $e');
    }
  }

  /// Creates a new key instance from a slice of public key bytes.
  ///
  /// Throws an [AskarKeyException] if key creation fails.
  static Key fromPublicBytes(
      {required KeyAlgorithm algorithm, required Uint8List publicKey}) {
    try {
      return Key(askarKeyFromPublicBytes(algorithm, publicKey).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to get key from public bytes: $e');
    }
  }

  /// Create a new key instance from a JWK
  ///
  /// Throws an [AskarKeyException] if key creation fails.
  static Key fromJwk({required Jwk jwk}) {
    try {
      return Key(askarKeyFromJwk(jwk.toString()).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to get key from JWK: $e');
    }
  }

  /// Converts this key or keypair to its equivalent for another key algorithm.
  ///
  /// Throws an [AskarKeyException] if key conversion fails.
  Key convertKey({required KeyAlgorithm algorithm}) {
    try {
      return Key(askarKeyConvert(localKeyHandle, algorithm).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to convert key from algorithm: $e');
    }
  }

  /// Derives an instance of this key directly from a supported key exchange.
  ///
  /// Throws an [AskarKeyException] if key derivation fails.
  Key keyFromKeyExchange(
      {required KeyAlgorithm algorithm, required Key secretKey, required Key publicKey}) {
    try {
      return Key(askarKeyFromKeyExchange(algorithm, secretKey.handle, publicKey.handle)
          .getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to get key from key exchange: $e');
    }
  }

  /// Gets the key algorithm.
  ///
  /// Throws an [AskarKeyException] if the algorithm retrieval fails.
  KeyAlgorithm get algorithm {
    try {
      return KeyAlgorithm.fromString(
          askarKeyGetAlgorithm(localKeyHandle).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to get key algorithm: $e');
    }
  }

  /// Gets whether the key is ephemeral.
  ///
  /// Throws an [AskarKeyException] if the ephemeral status retrieval fails.
  bool get ephemeral {
    try {
      return askarKeyGetEphemeral(localKeyHandle).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to get key ephemeral: $e');
    }
  }

  /// Gets the public key bytes.
  ///
  /// Throws an [AskarKeyException] if the public key bytes retrieval fails.
  Uint8List get publicBytes {
    try {
      return askarKeyGetPublicBytes(localKeyHandle).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to get key public bytes: $e');
    }
  }

  /// Gets the secret key bytes.
  ///
  /// Throws an [AskarKeyException] if the secret key bytes retrieval fails.
  Uint8List get secretBytes {
    try {
      return askarKeyGetSecretBytes(localKeyHandle).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to get key secret bytes: $e');
    }
  }

  /// Gets the public JWK.
  ///
  /// Throws an [AskarKeyException] if the JWK retrieval fails.
  Jwk get jwkPublic {
    try {
      return Jwk.fromString(
          askarKeyGetJwkPublic(localKeyHandle, algorithm).getValueOrException());
    } catch (e) {
      throw AskarKeyException('Failed to get JWK public: $e');
    }
  }

  /// Gets the secret JWK.
  ///
  /// Throws an [AskarKeyException] if the JWK retrieval fails.
  Jwk get jwkSecret {
    try {
      return Jwk.fromString(
          utf8.decode(askarKeyGetJwkSecret(localKeyHandle).getValueOrException()));
    } catch (e) {
      throw AskarKeyException('Failed to get JWK secret: $e');
    }
  }

  /// Gets the JWK thumbprint.
  ///
  /// Throws an [AskarKeyException] if the thumbprint retrieval fails.
  String get jwkThumbprint {
    try {
      return askarKeyGetJwkThumbprint(localKeyHandle, algorithm).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to get jwk thumbprint: $e');
    }
  }

  /// Gets the AEAD parameters.
  ///
  /// Throws an [AskarKeyException] if the parameters retrieval fails.
  AeadParams get aeadParams {
    try {
      return askarKeyAeadGetParams(localKeyHandle).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Error getting aead params: $e');
    }
  }

  /// Generates a random nonce for AEAD.
  ///
  /// Throws an [AskarKeyException] if nonce generation fails.
  Uint8List get aeadRandomNonce {
    try {
      return askarKeyAeadRandomNonce(localKeyHandle).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Error generating random nonce: $e');
    }
  }

  /// Encrypts a message using AEAD.
  ///
  /// Throws an [AskarKeyException] if encryption fails.
  EncryptedBuffer aeadEncrypt(
      {required Uint8List message, Uint8List? nonce, Uint8List? aad}) {
    try {
      return askarKeyAeadEncrypt(localKeyHandle, message, nonce: nonce, aad: aad)
          .getValueOrException();
    } catch (e) {
      throw AskarKeyException('Error on AEAD Encryption: $e');
    }
  }

  /// Decrypts a message using AEAD.
  ///
  /// Throws an [AskarKeyException] if decryption fails.
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

  /// Signs a message.
  ///
  /// Throws an [AskarKeyException] if signing fails.
  Uint8List signMessage(
      {required Uint8List message, required SignatureAlgorithm sigType}) {
    try {
      return askarKeySignMessage(localKeyHandle, message, sigType).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to sign message: $e');
    }
  }

  /// Verifies a signature.
  ///
  /// Throws an [AskarKeyException] if verification fails.
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

  /// Wraps a key.
  ///
  /// Throws an [AskarKeyException] if wrapping fails.
  EncryptedBuffer wrapKey({required Key other, Uint8List? nonce}) {
    try {
      return askarKeyWrapKey(localKeyHandle, other.handle, nonce: nonce)
          .getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to wrap key: $e');
    }
  }

  /// Unwraps a key.
  ///
  /// Throws an [AskarKeyException] if unwrapping fails.
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
