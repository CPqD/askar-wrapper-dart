import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'askar_native_functions.dart';

Pointer<NativeByteBuffer> stringToByteBuffer(String value) {
  return bytesListToByteBuffer(utf8.encode(value));
}

Pointer<NativeByteBuffer> bytesListToByteBuffer(Uint8List? bytesList) {
  if (bytesList == null) {
    return calloc<NativeByteBuffer>();
  }

  Pointer<Uint8> dataPointer = calloc<Uint8>(bytesList.length);

  for (int i = 0; i < bytesList.length; i++) {
    dataPointer[i] = bytesList[i];
  }

  Pointer<NativeByteBuffer> byteBufferPointer = calloc<NativeByteBuffer>();

  byteBufferPointer.ref.len = bytesList.length;
  byteBufferPointer.ref.data = dataPointer;

  return byteBufferPointer;
}

String secretBufferToString(NativeSecretBuffer secretBuffer) {
  return utf8.decode(secretBufferToBytesList(secretBuffer));
}

Uint8List secretBufferToBytesList(NativeSecretBuffer secretBuffer) {
  int length = secretBuffer.len;
  Pointer<Uint8> dataPointer = secretBuffer.data;

  return dataPointer.asTypedList(length);
}

int boolToInt(bool value) {
  return value ? 1 : 0;
}

Uint8List generateRandomSeed() {
  final random = Random.secure();
  final seed = List<int>.generate(32, (_) => random.nextInt(256));
  return Uint8List.fromList(seed);
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
