import 'dart:typed_data';
import 'package:import_so_libaskar/askar/askar_wrapper.dart';
import 'package:import_so_libaskar/askar/crypto/askar_encrypted_buffer.dart';
import 'package:import_so_libaskar/askar/crypto/askar_key.dart';
import 'package:import_so_libaskar/askar/enums/askar_key_algorithm.dart';
import 'package:import_so_libaskar/askar/exceptions/exceptions.dart';

class EcdhEs {
  final Uint8List algId;
  final Uint8List apu;
  final Uint8List apv;

  EcdhEs({required this.algId, required this.apu, required this.apv});

  AskarKey deriveKey({
    required KeyAlgorithm encryptionAlgorithm,
    required AskarKey ephemeralKey,
    required AskarKey recipientKey,
    required bool receive,
  }) {
    try {
      return AskarKey(
        askarKeyDeriveEcdhEs(encryptionAlgorithm, ephemeralKey.handle,
                recipientKey.handle, algId, apu, apv, receive)
            .getValueOrException(),
      );
    } catch (e) {
      throw AskarKeyException('Failed to derive key: $e');
    }
  }

  AskarEncryptedBuffer encryptDirect({
    required KeyAlgorithm encryptionAlgorithm,
    required AskarKey recipientKey,
    required AskarKey ephemeralKey,
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

  Uint8List decryptDirect({
    required KeyAlgorithm encryptionAlgorithm,
    required AskarKey recipientKey,
    required Uint8List ciphertext,
    required AskarKey ephemeralKey,
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
    final decryptedBuffer =
        derived.aeadDecrypt(tag: tag, nonce: nonce, ciphertext: ciphertext, aad: aad);
    derived.handle.free();
    return decryptedBuffer;
  }

  AskarEncryptedBuffer senderWrapKey({
    required KeyAlgorithm keyWrappingAlgorithm,
    required AskarKey ephemeralKey,
    required AskarKey recipientKey,
    required AskarKey cek,
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

  AskarKey receiverUnwrapKey({
    required KeyAlgorithm keyWrappingAlgorithm,
    required KeyAlgorithm encryptionAlgorithm,
    required AskarKey ephemeralKey,
    required AskarKey recipientKey,
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
        tag: tag, nonce: nonce, ciphertext: ciphertext, algorithm: encryptionAlgorithm);
    derived.handle.free();
    return encryptedBuffer;
  }
}
