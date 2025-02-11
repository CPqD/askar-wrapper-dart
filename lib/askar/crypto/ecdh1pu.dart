import 'dart:typed_data';

import 'package:askar_flutter_sdk/askar/crypto/encrypted_buffer.dart';

import '../../askar/askar_wrapper.dart';
import '../../askar/enums/askar_key_algorithm.dart';
import '../../askar/exceptions/exceptions.dart';
import 'key.dart';

class Ecdh1PU {
  final Uint8List algId;
  final Uint8List apu;
  final Uint8List apv;

  Ecdh1PU({required this.algId, required this.apu, required this.apv});

  Key deriveKey({
    required KeyAlgorithm encryptionAlgorithm,
    required Key ephemeralKey,
    required Key senderKey,
    required Key recipientKey,
    required bool receive,
    Uint8List? ccTag,
  }) {
    try {
      return Key(
        askarKeyDeriveEcdh1pu(encryptionAlgorithm, ephemeralKey.handle, senderKey.handle,
                recipientKey.handle, algId, apu, apv,
                ccTag: ccTag, receive: receive)
            .getValueOrException(),
      );
    } catch (e) {
      throw AskarKeyException('Failed to derive key: $e');
    }
  }

  EncryptedBuffer encryptDirect({
    required KeyAlgorithm encryptionAlgorithm,
    required Key recipientKey,
    required Key ephemeralKey,
    required Key senderKey,
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
    required Key recipientKey,
    required Key ephemeralKey,
    required Key senderKey,
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

  EncryptedBuffer senderWrapKey({
    required KeyAlgorithm keyWrappingAlgorithm,
    required Key ephemeralKey,
    required Key recipientKey,
    required Key senderKey,
    required Key cek,
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

  Key receiverUnwrapKey({
    required KeyAlgorithm keyWrappingAlgorithm,
    required KeyAlgorithm encryptionAlgorithm,
    required Key recipientKey,
    required Key ephemeralKey,
    required Key senderKey,
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
