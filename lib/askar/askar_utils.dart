import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'askar_native_functions.dart';

Pointer<ByteBuffer> stringToByteBuffer(String value) {
  List<int> bytes = utf8.encode(value);

  Pointer<Uint8> dataPointer = calloc<Uint8>(bytes.length);

  for (int i = 0; i < bytes.length; i++) {
    dataPointer[i] = bytes[i];
  }

  Pointer<ByteBuffer> byteBufferPointer = calloc<ByteBuffer>();

  byteBufferPointer.ref.len = bytes.length;
  byteBufferPointer.ref.data = dataPointer;

  return byteBufferPointer;
}

String secretBufferToString(Pointer<SecretBuffer> byteBufferPointer) {
  int length = byteBufferPointer.ref.len;

  Pointer<Uint8> dataPointer = byteBufferPointer.ref.data;

  List<int> bytes = dataPointer.asTypedList(length);

  return utf8.decode(bytes, allowMalformed: true);
}
