import 'dart:typed_data';

import '../../askar/askar_wrapper.dart';
import '../../askar/exceptions/exceptions.dart';
import 'key.dart';

/// A class designed to encrypt and decrypt independent messages.
///
/// This class is compatible with libsodium's `crypto_box` construct.
/// For more information, see libsodium documentation.
///
/// https://doc.libsodium.org/secret-key_cryptography/encrypted-messages

class CryptoBox {
  /// Generates a random nonce for use in a crypto box.
  ///
  /// - **Throws**: [AskarKeyException] if the nonce generation fails.
  static Uint8List randomNonce() {
    try {
      return askarKeyCryptoBoxRandomNonce().getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to generate random nonce for crypto box: $e');
    }
  }

  /// Encrypts a message into a crypto box with a given nonce.
  ///
  /// - **Throws**: [AskarKeyException] if encryption fails.
  static Uint8List cryptoBox({
    required Key recipientKey,
    required Key senderKey,
    required Uint8List message,
    required Uint8List nonce,
  }) {
    try {
      return askarKeyCryptoBox(
        recipientKey.handle,
        senderKey.handle,
        message,
        nonce,
      ).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Error on crypto box: $e');
    }
  }

  /// Decrypts a message from a crypto box.
  ///
  /// - **Throws**: An [AskarKeyException] if decryption fails.
  static Uint8List open({
    required Key recipientKey,
    required Key senderKey,
    required Uint8List message,
    required Uint8List nonce,
  }) {
    try {
      return askarKeyCryptoBoxOpen(
        recipientKey.handle,
        senderKey.handle,
        message,
        nonce,
      ).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Error on crypto box open: $e');
    }
  }

  /// Encrypts a message for a recipient using an ephemeral key and a deterministic nonce.
  ///
  /// - **Throws**: An [AskarKeyException] if encryption fails.
  static Uint8List seal({
    required Key recipientKey,
    required Uint8List message,
  }) {
    try {
      return askarKeyCryptoBoxSeal(
        recipientKey.handle,
        message,
      ).getValueOrException();
    } catch (e) {
      throw AskarKeyException('Error on crypto box seal: $e');
    }
  }

  /// Decrypts a sealed crypto box.
  /// - **Throws**: An [AskarKeyException] if decryption fails.
  static Uint8List sealOpen({
    required Key recipientKey,
    required Uint8List ciphertext,
  }) {
    try {
      return askarKeyCryptoBoxSealOpen(recipientKey.handle, ciphertext)
          .getValueOrException();
    } catch (e) {
      throw AskarKeyException('Error on crypto box seal open: $e');
    }
  }
}
