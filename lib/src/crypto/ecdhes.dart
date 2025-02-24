import 'dart:typed_data';

import 'encrypted_buffer.dart';

import '../askar_wrapper.dart';
import '../../src/enums/askar_key_algorithm.dart';
import '../../src/exceptions/exceptions.dart';
import 'key.dart';

/// A class for ECDH-ES key derivation
///
/// This class provides methods to derive shared keys for anonymous encryption
/// and to perform direct encryption and decryption using the derived keys.
class EcdhEs {
  final Uint8List algId;
  final Uint8List apu;
  final Uint8List apv;

  /// Constructs an instance of [EcdhEs].
  EcdhEs({required this.algId, required this.apu, required this.apv});

  /// Derives an ECDH-ES shared key for anonymous encryption.
  ///
  /// Throws an [AskarKeyException] if key derivation fails.
  Key deriveKey({
    required KeyAlgorithm encryptionAlgorithm,
    required Key ephemeralKey,
    required Key recipientKey,
    required bool receive,
  }) {
    try {
      return Key(
        askarKeyDeriveEcdhEs(
          encryptionAlgorithm,
          ephemeralKey.handle,
          recipientKey.handle,
          algId,
          apu,
          apv,
          receive,
        ).getValueOrException(),
      );
    } catch (e) {
      throw AskarKeyException('Failed to derive key: $e');
    }
  }

  /// Encrypts a message directly using the derived key.
  ///
  /// Returns an [EncryptedBuffer] containing the encrypted message.
  EncryptedBuffer encryptDirect({
    required KeyAlgorithm encryptionAlgorithm,
    required Key recipientKey,
    required Key ephemeralKey,
    required Uint8List message,
    Uint8List? aad,
    Uint8List? nonce,
  }) {
    final derived = deriveKey(
      encryptionAlgorithm: encryptionAlgorithm,
      ephemeralKey: ephemeralKey,
      recipientKey: recipientKey,
      receive: false,
    );
    final encryptedBuffer = derived.aeadEncrypt(message: message, aad: aad, nonce: nonce);
    derived.handle.free();
    return encryptedBuffer;
  }

  /// Decrypts a message directly using the derived key.
  ///
  /// Returns a [Uint8List] containing the decrypted message.
  Uint8List decryptDirect({
    required KeyAlgorithm encryptionAlgorithm,
    required Key recipientKey,
    required Uint8List ciphertext,
    required Key ephemeralKey,
    required Uint8List nonce,
    required Uint8List tag,
    Uint8List? aad,
  }) {
    final derived = deriveKey(
      encryptionAlgorithm: encryptionAlgorithm,
      ephemeralKey: ephemeralKey,
      recipientKey: recipientKey,
      receive: true,
    );
    final decryptedBuffer = derived.aeadDecrypt(
      tag: tag,
      nonce: nonce,
      ciphertext: ciphertext,
      aad: aad,
    );
    derived.handle.free();
    return decryptedBuffer;
  }

  /// Wraps a key for the sender using the derived key.
  ///
  /// Returns an [EncryptedBuffer] containing the wrapped key.
  EncryptedBuffer senderWrapKey({
    required KeyAlgorithm keyWrappingAlgorithm,
    required Key ephemeralKey,
    required Key recipientKey,
    required Key cek,
  }) {
    final derived = deriveKey(
      encryptionAlgorithm: keyWrappingAlgorithm,
      ephemeralKey: ephemeralKey,
      recipientKey: recipientKey,
      receive: false,
    );
    final encryptedBuffer = derived.wrapKey(other: cek);
    derived.handle.free();
    return encryptedBuffer;
  }

  /// Unwraps a key for the receiver using the derived key.
  ///
  /// Returns a [Key] containing the unwrapped key.
  Key receiverUnwrapKey({
    required KeyAlgorithm keyWrappingAlgorithm,
    required KeyAlgorithm encryptionAlgorithm,
    required Key ephemeralKey,
    required Key recipientKey,
    required Uint8List ciphertext,
    Uint8List? nonce,
    Uint8List? tag,
  }) {
    final derived = deriveKey(
      encryptionAlgorithm: keyWrappingAlgorithm,
      ephemeralKey: ephemeralKey,
      recipientKey: recipientKey,
      receive: true,
    );
    final encryptedBuffer = derived.unwrapKey(
      tag: tag,
      nonce: nonce,
      ciphertext: ciphertext,
      algorithm: encryptionAlgorithm,
    );
    derived.handle.free();
    return encryptedBuffer;
  }
}
