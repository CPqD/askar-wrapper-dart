import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'askar_native_functions.dart';

Pointer<ByteBuffer> stringToByteBuffer(String value) {
  return bytesListToByteBuffer(utf8.encode(value));
}

Pointer<ByteBuffer> bytesListToByteBuffer(Uint8List bytesList) {
  Pointer<Uint8> dataPointer = calloc<Uint8>(bytesList.length);

  for (int i = 0; i < bytesList.length; i++) {
    dataPointer[i] = bytesList[i];
  }

  Pointer<ByteBuffer> byteBufferPointer = calloc<ByteBuffer>();

  byteBufferPointer.ref.len = bytesList.length;
  byteBufferPointer.ref.data = dataPointer;

  return byteBufferPointer;
}

String secretBufferToString(SecretBuffer secretBuffer) {
  return utf8.decode(secretBufferToBytesList(secretBuffer));
}

Uint8List secretBufferToBytesList(SecretBuffer secretBuffer) {
  int length = secretBuffer.len;
  Pointer<Uint8> dataPointer = secretBuffer.data;

  return dataPointer.asTypedList(length);
}

bool intToBool(int value) {
  switch (value) {
    case 0:
      return false;
    case 1:
      return true;
    default:
      throw ArgumentError('Invalid bool value: $value');
  }
}

int boolToInt(bool value) {
  return value ? 1 : 0;
}

Uint8List generateRandomSeed() {
  final random = Random.secure();
  final seed = List<int>.generate(32, (_) => random.nextInt(256));
  return Uint8List.fromList(seed);
}
