import 'dart:typed_data';
import 'package:import_so_libaskar/askar/askar_wrapper.dart';
import 'package:import_so_libaskar/askar/crypto/askar_encrypted_buffer.dart';
import 'package:import_so_libaskar/askar/crypto/askar_key.dart';
import 'package:import_so_libaskar/askar/enums/askar_key_algorithm.dart';
import 'package:import_so_libaskar/askar/exceptions/exceptions.dart';

class Ecdh1PU {
  final Uint8List algId;
  final Uint8List apu;
  final Uint8List apv;

  Ecdh1PU({required this.algId, required this.apu, required this.apv});

  AskarKey deriveKey({
    required KeyAlgorithm encryptionAlgorithm,
    required AskarKey ephemeralKey,
    required AskarKey senderKey,
    required AskarKey recipientKey,
    required bool receive,
    Uint8List? ccTag,
  }) {
    try {
      return AskarKey(
        askarKeyDeriveEcdh1pu(encryptionAlgorithm, ephemeralKey.handle, senderKey.handle,
                recipientKey.handle, algId, apu, apv,
                ccTag: ccTag, receive: receive)
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
    required AskarKey senderKey,
    required Uint8List message,
    Uint8List? aad,
    Uint8List? nonce,
  }) {
    final derived = deriveKey(
      encryptionAlgorithm: encryptionAlgorithm,
      ephemeralKey: ephemeralKey,
      recipientKey: recipientKey,
      senderKey: senderKey,
      receive: false,
    );
    final encryptedBuffer = derived.aeadEncrypt(message: message, aad: aad, nonce: nonce);
    derived.handle.free();
    return encryptedBuffer;
  }

  Uint8List decryptDirect({
    required KeyAlgorithm encryptionAlgorithm,
    required AskarKey recipientKey,
    required AskarKey ephemeralKey,
    required AskarKey senderKey,
    required Uint8List ciphertext,
    required Uint8List nonce,
    required Uint8List tag,
    Uint8List? aad,
  }) {
    final derived = deriveKey(
      encryptionAlgorithm: encryptionAlgorithm,
      ephemeralKey: ephemeralKey,
      recipientKey: recipientKey,
      senderKey: senderKey,
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
    required AskarKey senderKey,
    required AskarKey cek,
    required Uint8List ccTag,
  }) {
    final derived = deriveKey(
      encryptionAlgorithm: keyWrappingAlgorithm,
      ephemeralKey: ephemeralKey,
      recipientKey: recipientKey,
      senderKey: senderKey,
      receive: false,
      ccTag: ccTag,
    );
    final encryptedBuffer = derived.wrapKey(other: cek);
    derived.handle.free();
    return encryptedBuffer;
  }

  AskarKey receiverUnwrapKey({
    required KeyAlgorithm keyWrappingAlgorithm,
    required KeyAlgorithm encryptionAlgorithm,
    required AskarKey recipientKey,
    required AskarKey ephemeralKey,
    required AskarKey senderKey,
    required Uint8List ciphertext,
    Uint8List? nonce,
    Uint8List? tag,
    required Uint8List ccTag,
  }) {
    final derived = deriveKey(
      encryptionAlgorithm: keyWrappingAlgorithm,
      ephemeralKey: ephemeralKey,
      recipientKey: recipientKey,
      receive: true,
      senderKey: senderKey,
      ccTag: ccTag,
    );
    final unwrappedKey = derived.unwrapKey(
        tag: tag, nonce: nonce, ciphertext: ciphertext, algorithm: encryptionAlgorithm);
    derived.handle.free();
    return unwrappedKey;
  }
}
