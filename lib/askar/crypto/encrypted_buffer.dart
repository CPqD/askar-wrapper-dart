import 'dart:typed_data';

import '../askar_native_functions.dart';
import '../askar_utils.dart';

/// A class presents an encrypted buffer that includes the ciphertext [buffer], tag [tagPos], and nonce [noncePos].
///
/// This class provides methods to access the individual parts of the encrypted buffer.
final class EncryptedBuffer {
  final Uint8List buffer;

  /// The position of the tag within the buffer.
  final int tagPos;

  /// The position of the nonce within the buffer.
  final int noncePos;

  /// Constructs an instance of [EncryptedBuffer].
  EncryptedBuffer(this.buffer, this.tagPos, this.noncePos);

  /// Returns the combined ciphertext and tag.
  Uint8List get ciphertextWithTag {
    return buffer.sublist(0, noncePos);
  }

  /// Returns the ciphertext.
  Uint8List get ciphertext {
    return buffer.sublist(0, tagPos);
  }

  /// Returns the nonce.
  Uint8List get nonce {
    return buffer.sublist(noncePos);
  }

  /// Returns the tag.
  Uint8List get tag {
    return buffer.sublist(tagPos, noncePos);
  }

  /// Returns the parts of the encrypted buffer as a map.
  ///
  /// The map contains the ciphertext, tag, and nonce.
  Map<String, Uint8List> get parts {
    return {
      'ciphertext': ciphertext,
      'tag': tag,
      'nonce': nonce,
    };
  }

  @override
  String toString() {
    return "EncryptedBuffer(tagPos: $tagPos, noncePos: $noncePos, buffer: $buffer)";
  }
}

/// Reads a native encrypted buffer and converts it to an [EncryptedBuffer] instance.
///
/// The [encryptedBuffer] parameter is a [NativeEncryptedBuffer] containing the native encrypted data.
EncryptedBuffer readNativeEncryptedBuffer(NativeEncryptedBuffer encryptedBuffer) {
  int noncePos = encryptedBuffer.nonce_pos;
  int tagPos = encryptedBuffer.tag_pos;

  return EncryptedBuffer(
      Uint8List.fromList(secretBufferToBytesList(encryptedBuffer.buffer)),
      tagPos,
      noncePos);
}
