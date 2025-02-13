import 'dart:typed_data';

import '../../askar/askar_wrapper.dart';
import '../../askar/exceptions/exceptions.dart';
import 'key.dart';

class CryptoBox {
  static Uint8List randomNonce() {
    try {
      return askarKeyCryptoBoxRandomNonce().getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to generate random nonce for crypto box: $e');
    }
  }

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
