import 'dart:typed_data';
import 'package:import_so_libaskar/askar/askar_wrapper.dart';
import 'package:import_so_libaskar/askar/crypto/askar_key.dart';
import 'package:import_so_libaskar/askar/exceptions/exceptions.dart';

class AskarCryptoBox {
  static Uint8List randomNonce() {
    try {
      return askarKeyCryptoBoxRandomNonce().getValueOrException();
    } catch (e) {
      throw AskarKeyException('Failed to generate random nonce for crypto box: $e');
    }
  }

  static Uint8List cryptoBox({
    required AskarKey recipientKey,
    required AskarKey senderKey,
    required Uint8List message,
    required Uint8List nonce,
  }) {
    try {
      return askarKeyCryptoBox(recipientKey.handle, senderKey.handle, message, nonce)
          .getValueOrException();
    } catch (e) {
      throw AskarKeyException('Error on crypto box: $e');
    }
  }

// TODO
  // static Uint8List open({
  //   required AskarKey recipientKey,
  //   required AskarKey senderKey,
  //   required Uint8List message,
  //   required Uint8List nonce,
  // }) {
  //   return askarKeyCryptoBoxOpen(
  //     nonce: nonce,
  //     message: message,
  //     senderKey: senderKey.handle,
  //     recipientKey: recipientKey.handle,
  //   ).getValueOrException();
  // }

// TODO
  // static Uint8List seal({
  //   required AskarKey recipientKey,
  //   required Uint8List message,
  // }) {
  //   return askarKeyCryptoBoxSeal(
  //     message: message,
  //     localKeyHandle: recipientKey.handle,
  //   ).getValueOrException();
  // }

// TODO
  // static Uint8List sealOpen({
  //   required AskarKey recipientKey,
  //   required Uint8List ciphertext,
  // }) {
  //   return askarKeyCryptoBoxSealOpen(
  //     ciphertext: ciphertext,
  //     localKeyHandle: recipientKey.handle,
  //   ).getValueOrException();
  // }
}
