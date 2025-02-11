import 'dart:typed_data';

import '../askar_native_functions.dart';
import '../askar_utils.dart';

final class AskarEncryptedBuffer {
  final Uint8List buffer;
  final int tagPos;
  final int noncePos;

  AskarEncryptedBuffer(this.buffer, this.tagPos, this.noncePos);

  Uint8List get ciphertextWithTag {
    return buffer.sublist(0, noncePos);
  }

  Uint8List get ciphertext {
    return buffer.sublist(0, tagPos);
  }

  Uint8List get nonce {
    return buffer.sublist(noncePos);
  }

  Uint8List get tag {
    return buffer.sublist(tagPos, noncePos);
  }

  Map<String, Uint8List> get parts {
    return {
      'ciphertext': ciphertext,
      'tag': tag,
      'nonce': nonce,
    };
  }

  @override
  String toString() {
    return "AskarEncryptedBuffer(tagPos: $tagPos, noncePos: $noncePos, buffer: $buffer)";
  }
}

AskarEncryptedBuffer readNativeEncryptedBuffer(NativeEncryptedBuffer encryptedBuffer) {
  int noncePos = encryptedBuffer.nonce_pos;
  int tagPos = encryptedBuffer.tag_pos;

  return AskarEncryptedBuffer(
      Uint8List.fromList(secretBufferToBytesList(encryptedBuffer.buffer)),
      tagPos,
      noncePos);
}
