import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'askar_native_functions.dart';

/// Converts a string to a [NativeByteBuffer].
///
/// Takes a [String] [value] and returns a [Pointer] to a [NativeByteBuffer].
Pointer<NativeByteBuffer> stringToByteBuffer(String value) {
  return bytesListToByteBuffer(utf8.encode(value));
}

/// Converts a list of bytes to a [NativeByteBuffer].
///
/// Takes an optional [Uint8List] [bytesList] and returns a [Pointer] to a [NativeByteBuffer].
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

/// Converts a [NativeSecretBuffer] to a string.
///
/// Takes a [NativeSecretBuffer] [secretBuffer] and returns a [String].
String secretBufferToString(NativeSecretBuffer secretBuffer) {
  return utf8.decode(secretBufferToBytesList(secretBuffer));
}

/// Converts a [NativeSecretBuffer] to a list of bytes.
///
/// Takes a [NativeSecretBuffer] [secretBuffer] and returns a [Uint8List].
Uint8List secretBufferToBytesList(NativeSecretBuffer secretBuffer) {
  int length = secretBuffer.len;
  Pointer<Uint8> dataPointer = secretBuffer.data;

  return Uint8List.fromList(dataPointer.asTypedList(length));
}

/// Converts a boolean value to an integer.
///
/// Takes a [bool] [value] and returns an [int] (1 for true, 0 for false).
int boolToInt(bool value) {
  return value ? 1 : 0;
}

/// Generates a random seed.
///
/// Returns a [Uint8List] containing 32 random bytes.
Uint8List generateRandomSeed() {
  final random = Random.secure();
  final seed = List<int>.generate(32, (_) => random.nextInt(256));
  return Uint8List.fromList(seed);
}

/// Converts an integer to a boolean value.
///
/// Takes an [int] [value] and returns a [bool] (true for 1, false for 0).
/// Throws an [ArgumentError] if the value is not 0 or 1.
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
