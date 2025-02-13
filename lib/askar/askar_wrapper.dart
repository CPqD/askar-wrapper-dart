import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:askar_flutter_sdk/askar/enums/askar_key_method.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import '../../askar/askar_callbacks.dart';
import '../../askar/crypto/encrypted_buffer.dart';
import '../../askar/crypto/handles.dart';
import '../../askar/enums/askar_entry_operation.dart';
import '../../askar/enums/askar_error_code.dart';
import '../../askar/enums/askar_key_algorithm.dart';
import '../../askar/enums/askar_key_backend.dart';
import '../../askar/enums/askar_signature_algorithm.dart';
import '../../askar/enums/askar_store_key_method.dart';
import '../../askar/exceptions/exceptions.dart';

import 'askar_native_functions.dart';
import 'askar_utils.dart';

final class AskarResult<T> {
  final ErrorCode errorCode;
  final T value;

  AskarResult(this.errorCode, this.value);

  @override
  String toString() {
    return "AskarResult($errorCode, $value)";
  }

  T getValueOrException() {
    if (errorCode == ErrorCode.success) {
      return value;
    }
    throw AskarErrorCodeException(errorCode);
  }
}

typedef StringListHandle = int;

String askarVersion() {
  Pointer<Utf8> resultPointer = nullptr;

  try {
    resultPointer = nativeAskarVersion();
    return resultPointer.toDartString();
  } finally {
    freePointer(resultPointer);
  }
}

AskarResult<String> askarGetCurrentError() {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  try {
    final errorCode = ErrorCode.fromInt(nativeAskarGetCurrentError(utf8PtPointer));

    final String value =
        (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freeDoublePointer(utf8PtPointer);
  }
}

void askarBufferFree(Pointer<NativeSecretBuffer> buffer) {
  nativeAskarBufferFree(buffer);
}

void askarClearCustomLogger() {
  nativeAskarClearCustomLogger();
}

ErrorCode askarSetCustomLogger(
  Pointer<Void> context,
  Pointer<NativeFunction<LogCallback>> log,
  Pointer<NativeOptionEnabledCallbackStruct> enabled,
  Pointer<NativeOptionFlushCallbackStruct> flush,
  int maxLevel,
) {
  final result = nativeAskarSetCustomLogger(
    context,
    log,
    enabled,
    flush,
    maxLevel,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarSetDefaultLogger() {
  final result = nativeAskarSetDefaultLogger();
  return ErrorCode.fromInt(result);
}

ErrorCode askarSetMaxLogLevel(int maxLevel) {
  final result = nativeAskarSetMaxLogLevel(maxLevel);
  return ErrorCode.fromInt(result);
}

AskarResult<int> askarEntryListCount(EntryListHandle handle) {
  Pointer<Int32> countPointer = calloc<Int32>();

  try {
    final funcResult = nativeAskarEntryListCount(handle.toInt(), countPointer);

    final errorCode = ErrorCode.fromInt(funcResult);

    final value = (errorCode == ErrorCode.success) ? countPointer.value : 0;

    return AskarResult<int>(errorCode, value);
  } finally {
    freePointer(countPointer);
  }
}

void askarEntryListFree(EntryListHandle handle) {
  nativeAskarEntryListFree(handle.toInt());
}

AskarResult<String> askarEntryListGetCategory(EntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  try {
    final funcResult =
        nativeAskarEntryListGetCategory(handle.toInt(), index, utf8PtPointer);

    final errorCode = ErrorCode.fromInt(funcResult);

    final String value =
        (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freeDoublePointer(utf8PtPointer);
  }
}

AskarResult<String> askarEntryListGetName(EntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  try {
    final funcResult = nativeAskarEntryListGetName(handle.toInt(), index, utf8PtPointer);

    final errorCode = ErrorCode.fromInt(funcResult);

    final String value =
        (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freeDoublePointer(utf8PtPointer);
  }
}

AskarResult<String> askarEntryListGetTags(EntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  try {
    final funcResult = nativeAskarEntryListGetTags(handle.toInt(), index, utf8PtPointer);

    final errorCode = ErrorCode.fromInt(funcResult);

    final value =
        (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freeDoublePointer(utf8PtPointer);
  }
}

AskarResult<Uint8List> askarEntryListGetValue(EntryListHandle handle, int index) {
  Pointer<NativeSecretBuffer> secretBufferPointer = calloc<NativeSecretBuffer>();

  try {
    final funcResult =
        nativeAskarEntryListGetValue(handle.toInt(), index, secretBufferPointer);

    final errorCode = ErrorCode.fromInt(funcResult);

    final Uint8List value = (errorCode == ErrorCode.success)
        ? secretBufferToBytesList(secretBufferPointer.ref)
        : Uint8List(0);

    return AskarResult<Uint8List>(errorCode, value);
  } finally {
    freeSecretBufferPointer(secretBufferPointer);
  }
}

AskarResult<int> askarStringListCount(StringListHandle handle) {
  Pointer<Int32> countPtr = calloc<Int32>();

  try {
    final errorCode = ErrorCode.fromInt(nativeAskarStringListCount(handle, countPtr));
    final count = (errorCode == ErrorCode.success) ? countPtr.value : 0;

    return AskarResult<int>(errorCode, count);
  } finally {
    freePointer(countPtr);
  }
}

void askarStringListFree(StringListHandle handle) {
  nativeAskarStringListFree(handle);
}

AskarResult<String> askarStringListGetItem(StringListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtrPointer = calloc<Pointer<Utf8>>();

  try {
    final errorCode =
        ErrorCode.fromInt(nativeAskarStringListGetItem(handle, index, utf8PtrPointer));

    final String value =
        (errorCode == ErrorCode.success) ? utf8PtrPointer.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freeDoublePointer(utf8PtrPointer);
  }
}

AskarResult<Uint8List> askarKeyAeadDecrypt(
    LocalKeyHandle handle, Uint8List ciphertext, Uint8List nonce,
    {Uint8List? tag, Uint8List? aad}) {
  Pointer<NativeSecretBuffer> secretBufferPointer = calloc<NativeSecretBuffer>();

  Pointer<NativeByteBuffer> ciphertextPtr = nullptr;
  Pointer<NativeByteBuffer> noncePtr = nullptr;
  Pointer<NativeByteBuffer> tagPtr = nullptr;
  Pointer<NativeByteBuffer> aadPtr = nullptr;

  try {
    ciphertextPtr = bytesListToByteBuffer(ciphertext);
    noncePtr = bytesListToByteBuffer(nonce);
    tagPtr = bytesListToByteBuffer(tag);
    aadPtr = bytesListToByteBuffer(aad);

    final funcResult = nativeAskarKeyAeadDecrypt(
      handle.toInt(),
      ciphertextPtr.ref,
      noncePtr.ref,
      tagPtr.ref,
      aadPtr.ref,
      secretBufferPointer,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final decryptedData = (errorCode == ErrorCode.success)
        ? secretBufferToBytesList(secretBufferPointer.ref)
        : Uint8List(0);

    return AskarResult<Uint8List>(errorCode, decryptedData);
  } finally {
    freeSecretBufferPointer(secretBufferPointer);
    freeByteBufferPointer(ciphertextPtr);
    freeByteBufferPointer(noncePtr);
    freeByteBufferPointer(tagPtr);
    freeByteBufferPointer(aadPtr);
  }
}

AskarResult<EncryptedBuffer> askarKeyAeadEncrypt(
    LocalKeyHandle localKeyHandle, Uint8List message,
    {Uint8List? nonce, Uint8List? aad}) {
  Pointer<NativeEncryptedBuffer> outPtr = calloc<NativeEncryptedBuffer>();

  Pointer<NativeByteBuffer> messagePtr = nullptr;
  Pointer<NativeByteBuffer> noncePtr = nullptr;
  Pointer<NativeByteBuffer> aadPtr = nullptr;

  try {
    messagePtr = bytesListToByteBuffer(message);
    noncePtr = bytesListToByteBuffer(nonce);
    aadPtr = bytesListToByteBuffer(aad);

    final funcResult = nativeAskarKeyAeadEncrypt(
      localKeyHandle.toInt(),
      messagePtr.ref,
      noncePtr.ref,
      aadPtr.ref,
      outPtr,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final value = (errorCode == ErrorCode.success)
        ? readNativeEncryptedBuffer(outPtr.ref)
        : EncryptedBuffer(Uint8List.fromList([]), 0, 0);

    return AskarResult<EncryptedBuffer>(errorCode, value);
  } finally {
    freeEncryptedBufferPointer(outPtr);
    freeByteBufferPointer(messagePtr);
    freeByteBufferPointer(noncePtr);
    freeByteBufferPointer(aadPtr);
  }
}

ErrorCode askarKeyAeadGetPadding(
  LocalKeyHandle handle,
  int msgLen,
  Pointer<Int32> out,
) {
  final result = nativeAskarKeyAeadGetPadding(
    handle.toInt(),
    msgLen,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyAeadGetParams(
  LocalKeyHandle handle,
  Pointer<NativeAeadParams> out,
) {
  final result = nativeAskarKeyAeadGetParams(
    handle.toInt(),
    out,
  );

  return ErrorCode.fromInt(result);
}

AskarResult<Uint8List> askarKeyAeadRandomNonce(LocalKeyHandle handle) {
  Pointer<NativeSecretBuffer> secretBufferPtr = calloc<NativeSecretBuffer>();

  try {
    final funcResult = nativeAskarKeyAeadRandomNonce(
      handle.toInt(),
      secretBufferPtr,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final value = (errorCode == ErrorCode.success)
        ? secretBufferToBytesList(secretBufferPtr.ref)
        : Uint8List(0);

    return AskarResult<Uint8List>(errorCode, value);
  } finally {
    freeSecretBufferPointer(secretBufferPtr);
  }
}

AskarResult<LocalKeyHandle> askarKeyConvert(
  LocalKeyHandle handle,
  KeyAlgorithm alg,
) {
  Pointer<NativeLocalKeyHandle> localKeyHandlePtr = calloc<NativeLocalKeyHandle>();

  Pointer<Utf8> algPointer = nullptr;

  try {
    algPointer = alg.value.toNativeUtf8();

    final result = nativeAskarKeyConvert(
      handle.toInt(),
      algPointer,
      localKeyHandlePtr,
    );

    final errorCode = ErrorCode.fromInt(result);

    final localKeyHandle = LocalKeyHandle.fromPointer(errorCode, localKeyHandlePtr);

    return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
  } finally {
    freePointer(localKeyHandlePtr);
    freePointer(algPointer);
  }
}

AskarResult<Uint8List> askarKeyCryptoBox(
  LocalKeyHandle recipKey,
  LocalKeyHandle senderKey,
  Uint8List message,
  Uint8List nonce,
) {
  Pointer<NativeSecretBuffer> secretBufferPtr = calloc<NativeSecretBuffer>();
  Pointer<NativeByteBuffer> messageByteBufferPtr = nullptr;
  Pointer<NativeByteBuffer> nonceByteBufferPtr = nullptr;

  try {
    messageByteBufferPtr = bytesListToByteBuffer(message);
    nonceByteBufferPtr = bytesListToByteBuffer(nonce);

    final funcResult = nativeAskarKeyCryptoBox(
      recipKey.toInt(),
      senderKey.toInt(),
      messageByteBufferPtr.ref,
      nonceByteBufferPtr.ref,
      secretBufferPtr,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final Uint8List value = (errorCode == ErrorCode.success)
        ? secretBufferToBytesList(secretBufferPtr.ref)
        : Uint8List(0);

    return AskarResult<Uint8List>(errorCode, value);
  } finally {
    freeSecretBufferPointer(secretBufferPtr);
    freeByteBufferPointer(messageByteBufferPtr);
    freeByteBufferPointer(nonceByteBufferPtr);
  }
}

AskarResult<Uint8List> askarKeyCryptoBoxOpen(
  LocalKeyHandle recipKey,
  LocalKeyHandle senderKey,
  Uint8List message,
  Uint8List nonce,
) {
  Pointer<NativeSecretBuffer> secretBufferPtr = calloc<NativeSecretBuffer>();
  Pointer<NativeByteBuffer> messageByteBufferPtr = nullptr;
  Pointer<NativeByteBuffer> nonceByteBufferPtr = nullptr;
  try {
    messageByteBufferPtr = bytesListToByteBuffer(message);
    nonceByteBufferPtr = bytesListToByteBuffer(nonce);

    final result = nativeAskarKeyCryptoBoxOpen(
      recipKey.toInt(),
      senderKey.toInt(),
      messageByteBufferPtr.ref,
      nonceByteBufferPtr.ref,
      secretBufferPtr,
    );

    final errorCode = ErrorCode.fromInt(result);

    final Uint8List value = (errorCode == ErrorCode.success)
        ? secretBufferToBytesList(secretBufferPtr.ref)
        : Uint8List(0);
    return AskarResult<Uint8List>(errorCode, value);
  } finally {
    freeSecretBufferPointer(secretBufferPtr);
    freeByteBufferPointer(messageByteBufferPtr);
    freeByteBufferPointer(nonceByteBufferPtr);
  }
}

AskarResult<Uint8List> askarKeyCryptoBoxRandomNonce() {
  Pointer<NativeSecretBuffer> secretBufferPtr = calloc<NativeSecretBuffer>();

  try {
    final funcResult = nativeAskarKeyCryptoBoxRandomNonce(secretBufferPtr);

    final errorCode = ErrorCode.fromInt(funcResult);

    final Uint8List value = (errorCode == ErrorCode.success)
        ? secretBufferToBytesList(secretBufferPtr.ref)
        : Uint8List(0);

    return AskarResult<Uint8List>(errorCode, value);
  } finally {
    freeSecretBufferPointer(secretBufferPtr);
  }
}

AskarResult<Uint8List> askarKeyCryptoBoxSeal(
  LocalKeyHandle handle,
  Uint8List message,
) {
  Pointer<NativeByteBuffer> messagePtr = bytesListToByteBuffer(message);
  Pointer<NativeSecretBuffer> secretBufferPtr = calloc<NativeSecretBuffer>();

  try {
    final result = nativeAskarKeyCryptoBoxSeal(
      handle.toInt(),
      messagePtr.ref,
      secretBufferPtr,
    );

    final errorCode = ErrorCode.fromInt(result);

    final value = secretBufferToBytesList(secretBufferPtr.ref);

    return AskarResult<Uint8List>(errorCode, value);
  } finally {
    freeByteBufferPointer(messagePtr);
    freeSecretBufferPointer(secretBufferPtr);
  }
}

AskarResult<Uint8List> askarKeyCryptoBoxSealOpen(
    LocalKeyHandle localKeyHandle, Uint8List ciphertext) {
  Pointer<NativeByteBuffer> byteBufferPointer = bytesListToByteBuffer(ciphertext);
  Pointer<NativeSecretBuffer> secretBufferPointer = calloc<NativeSecretBuffer>();

  try {
    final funcResult = nativeAskarKeyCryptoBoxSealOpen(
        localKeyHandle.toInt(), byteBufferPointer.ref, secretBufferPointer);

    final errorCode = ErrorCode.fromInt(funcResult);

    final value = secretBufferToBytesList(secretBufferPointer.ref);

    return AskarResult<Uint8List>(errorCode, value);
  } finally {
    freeByteBufferPointer(byteBufferPointer);
    freeSecretBufferPointer(secretBufferPointer);
  }
}

AskarResult<LocalKeyHandle> askarKeyDeriveEcdh1pu(
    KeyAlgorithm algorithm,
    LocalKeyHandle ephemeralKey,
    LocalKeyHandle senderKey,
    LocalKeyHandle recipientKey,
    Uint8List algId,
    Uint8List apu,
    Uint8List apv,
    {Uint8List? ccTag,
    required bool receive}) {
  Pointer<NativeLocalKeyHandle> outPtr = calloc<NativeLocalKeyHandle>();

  Pointer<Utf8> algPointer = nullptr;
  Pointer<NativeByteBuffer> algIdByteBufferPtr = nullptr;
  Pointer<NativeByteBuffer> apuByteBufferPtr = nullptr;
  Pointer<NativeByteBuffer> apvByteBufferPtr = nullptr;
  Pointer<NativeByteBuffer> ccTagByteBufferPtr = nullptr;

  try {
    algPointer = algorithm.value.toNativeUtf8();
    algIdByteBufferPtr = bytesListToByteBuffer(algId);
    apuByteBufferPtr = bytesListToByteBuffer(apu);
    apvByteBufferPtr = bytesListToByteBuffer(apv);
    ccTagByteBufferPtr = bytesListToByteBuffer(ccTag);

    final funcResult = nativeAskarKeyDeriveEcdh1pu(
      algPointer,
      ephemeralKey.toInt(),
      senderKey.toInt(),
      recipientKey.toInt(),
      algIdByteBufferPtr.ref,
      apuByteBufferPtr.ref,
      apvByteBufferPtr.ref,
      ccTagByteBufferPtr.ref,
      boolToInt(receive),
      outPtr,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final value = LocalKeyHandle.fromPointer(errorCode, outPtr);

    return AskarResult<LocalKeyHandle>(errorCode, value);
  } finally {
    freePointer(outPtr);
    freePointer(algPointer);
    freeByteBufferPointer(algIdByteBufferPtr);
    freeByteBufferPointer(apuByteBufferPtr);
    freeByteBufferPointer(apvByteBufferPtr);
    freeByteBufferPointer(ccTagByteBufferPtr);
  }
}

AskarResult<LocalKeyHandle> askarKeyDeriveEcdhEs(
  KeyAlgorithm algorithm,
  LocalKeyHandle ephemeralKey,
  LocalKeyHandle recipientKey,
  Uint8List algId,
  Uint8List apu,
  Uint8List apv,
  bool receive,
) {
  Pointer<NativeLocalKeyHandle> outPtr = calloc<NativeLocalKeyHandle>();

  Pointer<Utf8> algPointer = nullptr;
  Pointer<NativeByteBuffer> algIdByteBufferPtr = nullptr;
  Pointer<NativeByteBuffer> apuByteBufferPtr = nullptr;
  Pointer<NativeByteBuffer> apvByteBufferPtr = nullptr;

  try {
    algPointer = algorithm.value.toNativeUtf8();
    algIdByteBufferPtr = bytesListToByteBuffer(algId);
    apuByteBufferPtr = bytesListToByteBuffer(apu);
    apvByteBufferPtr = bytesListToByteBuffer(apv);

    final funcResult = nativeAskarKeyDeriveEcdhEs(
      algPointer,
      ephemeralKey.toInt(),
      recipientKey.toInt(),
      algIdByteBufferPtr.ref,
      apuByteBufferPtr.ref,
      apvByteBufferPtr.ref,
      boolToInt(receive),
      outPtr,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final value = LocalKeyHandle.fromPointer(errorCode, outPtr);

    return AskarResult<LocalKeyHandle>(errorCode, value);
  } finally {
    freePointer(outPtr);
    freePointer(algPointer);
    freeByteBufferPointer(algIdByteBufferPtr);
    freeByteBufferPointer(apuByteBufferPtr);
    freeByteBufferPointer(apvByteBufferPtr);
  }
}

AskarResult<int> askarKeyEntryListCount(KeyEntryListHandle handle) {
  Pointer<Int32> countPointer = calloc<Int32>();
  try {
    final funcResult = nativeAskarKeyEntryListCount(handle.toInt(), countPointer);

    final errorCode = ErrorCode.fromInt(funcResult);

    final count = (errorCode == ErrorCode.success) ? countPointer.value : 0;

    return AskarResult<int>(errorCode, count);
  } finally {
    freePointer(countPointer);
  }
}

void askarKeyEntryListFree(KeyEntryListHandle handle) {
  nativeAskarKeyEntryListFree(handle.toInt());
}

AskarResult<String> askarKeyEntryListGetAlgorithm(KeyEntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  try {
    final result =
        nativeAskarKeyEntryListGetAlgorithm(handle.toInt(), index, utf8PtPointer);

    final errorCode = ErrorCode.fromInt(result);

    final String value =
        (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freeDoublePointer(utf8PtPointer);
  }
}

AskarResult<String> askarKeyEntryListGetMetadata(KeyEntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  try {
    final funcResult = nativeAskarKeyEntryListGetMetadata(
      handle.toInt(),
      index,
      utf8PtPointer,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final String value =
        (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freeDoublePointer(utf8PtPointer);
  }
}

AskarResult<String> askarKeyEntryListGetName(KeyEntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  try {
    final result = nativeAskarKeyEntryListGetName(handle.toInt(), index, utf8PtPointer);

    final errorCode = ErrorCode.fromInt(result);

    final String value =
        (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freeDoublePointer(utf8PtPointer);
  }
}

AskarResult<String> askarKeyEntryListGetTags(KeyEntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  try {
    final result = nativeAskarKeyEntryListGetTags(handle.toInt(), index, utf8PtPointer);

    final errorCode = ErrorCode.fromInt(result);

    final value =
        (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freeDoublePointer(utf8PtPointer);
  }
}

AskarResult<LocalKeyHandle> askarKeyEntryListLoadLocal(
    KeyEntryListHandle handle, int index) {
  Pointer<IntPtr> outPtr = calloc<IntPtr>();

  try {
    final funcResult = nativeAskarKeyEntryListLoadLocal(handle.toInt(), index, outPtr);

    final errorCode = ErrorCode.fromInt(funcResult);

    final out = LocalKeyHandle.fromPointer(errorCode, outPtr);

    return AskarResult<LocalKeyHandle>(errorCode, out);
  } finally {
    freePointer(outPtr);
  }
}

void askarKeyFree(LocalKeyHandle handle) {
  nativeAskarKeyFree(handle.toInt());
}

AskarResult<LocalKeyHandle> askarKeyFromJwk(String jwk) {
  Pointer<NativeLocalKeyHandle> outPtr = calloc<NativeLocalKeyHandle>();

  Pointer<NativeByteBuffer> jwkByteBufferPtr = nullptr;

  try {
    jwkByteBufferPtr = stringToByteBuffer(jwk);

    final errorCode =
        ErrorCode.fromInt(nativeAskarKeyFromJwk(jwkByteBufferPtr.ref, outPtr));

    final value = LocalKeyHandle.fromPointer(errorCode, outPtr);

    return AskarResult<LocalKeyHandle>(errorCode, value);
  } finally {
    freePointer(outPtr);
    freeByteBufferPointer(jwkByteBufferPtr);
  }
}

AskarResult<LocalKeyHandle> askarKeyFromKeyExchange(
  KeyAlgorithm alg,
  LocalKeyHandle skHandle,
  LocalKeyHandle pkHandle,
) {
  Pointer<NativeLocalKeyHandle> localKeyHandlePtr = calloc<NativeLocalKeyHandle>();

  Pointer<Utf8> algPointer = nullptr;

  try {
    algPointer = alg.value.toNativeUtf8();

    final result = nativeAskarKeyFromKeyExchange(
      algPointer,
      skHandle.toInt(),
      pkHandle.toInt(),
      localKeyHandlePtr,
    );

    final errorCode = ErrorCode.fromInt(result);

    final localKeyHandle = LocalKeyHandle.fromPointer(errorCode, localKeyHandlePtr);

    return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
  } finally {
    freePointer(localKeyHandlePtr);
    freePointer(algPointer);
  }
}

AskarResult<LocalKeyHandle> askarKeyFromPublicBytes(
  KeyAlgorithm algorithm,
  Uint8List publicBytes,
) {
  Pointer<NativeLocalKeyHandle> localKeyHandlePtr = calloc<NativeLocalKeyHandle>();

  Pointer<Utf8> algPointer = nullptr;
  Pointer<NativeByteBuffer> byteBufferPointer = nullptr;

  try {
    algPointer = algorithm.value.toNativeUtf8();
    byteBufferPointer = bytesListToByteBuffer(publicBytes);

    final funcResult = nativeAskarKeyFromPublicBytes(
      algPointer,
      byteBufferPointer.ref,
      localKeyHandlePtr,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final localKeyHandle = LocalKeyHandle.fromPointer(errorCode, localKeyHandlePtr);

    return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
  } finally {
    freePointer(localKeyHandlePtr);
    freePointer(algPointer);
    freeByteBufferPointer(byteBufferPointer);
  }
}

AskarResult<LocalKeyHandle> askarKeyFromSecretBytes(
  KeyAlgorithm algorithm,
  Uint8List secret,
) {
  Pointer<NativeLocalKeyHandle> localKeyHandlePtr = calloc<NativeLocalKeyHandle>();

  Pointer<Utf8> algPointer = nullptr;
  Pointer<NativeByteBuffer> byteBufferPointer = nullptr;

  try {
    algPointer = algorithm.value.toNativeUtf8();
    byteBufferPointer = bytesListToByteBuffer(secret);

    final funcResult = nativeAskarKeyFromSecretBytes(
      algPointer,
      byteBufferPointer.ref,
      localKeyHandlePtr,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final localKeyHandle = LocalKeyHandle.fromPointer(errorCode, localKeyHandlePtr);

    return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
  } finally {
    freePointer(localKeyHandlePtr);
    freePointer(algPointer);
    freeByteBufferPointer(byteBufferPointer);
  }
}

AskarResult<LocalKeyHandle> askarKeyFromSeed(
    KeyAlgorithm alg, Uint8List seed, KeyMethod method) {
  Pointer<NativeLocalKeyHandle> localKeyHandlePtr = calloc<NativeLocalKeyHandle>();
  Pointer<Utf8> algPointer = nullptr;
  Pointer<NativeByteBuffer> byteBufferPointer = nullptr;
  Pointer<Utf8> methodPointer = nullptr;

  try {
    algPointer = alg.value.toNativeUtf8();
    byteBufferPointer = bytesListToByteBuffer(seed);
    methodPointer = method.value.toNativeUtf8();

    final result = nativeAskarKeyFromSeed(
      algPointer,
      byteBufferPointer.ref,
      methodPointer,
      localKeyHandlePtr,
    );

    final errorCode = ErrorCode.fromInt(result);
    final localKeyHandle = LocalKeyHandle.fromPointer(errorCode, localKeyHandlePtr);
    return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
  } finally {
    freePointer(algPointer);
    freePointer(methodPointer);
    freeByteBufferPointer(byteBufferPointer);
    freePointer(localKeyHandlePtr);
  }
}

AskarResult<LocalKeyHandle> askarKeyGenerate(
    KeyAlgorithm alg, KeyBackend keyBackend, bool ephemeral) {
  Pointer<NativeLocalKeyHandle> localKeyHandlePointer = calloc<NativeLocalKeyHandle>();

  Pointer<Utf8> algPointer = nullptr;
  Pointer<Utf8> keyBackendPointer = nullptr;

  try {
    algPointer = alg.value.toNativeUtf8();
    keyBackendPointer = keyBackend.value.toNativeUtf8();

    final funcResult = nativeAskarKeyGenerate(
      algPointer,
      keyBackendPointer,
      boolToInt(ephemeral),
      localKeyHandlePointer,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final localKeyHandle = LocalKeyHandle.fromPointer(errorCode, localKeyHandlePointer);

    return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
  } finally {
    freePointer(localKeyHandlePointer);
    freePointer(algPointer);
    freePointer(keyBackendPointer);
  }
}

AskarResult<String> askarKeyGetAlgorithm(LocalKeyHandle handle) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  try {
    final funcResult = nativeAskarKeyGetAlgorithm(handle.toInt(), utf8PtPointer);

    final errorCode = ErrorCode.fromInt(funcResult);

    final String value =
        (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freeDoublePointer(utf8PtPointer);
  }
}

AskarResult<bool> askarKeyGetEphemeral(
  LocalKeyHandle handle,
) {
  Pointer<Int8> intPointer = calloc<Int8>();
  try {
    final result = nativeAskarKeyGetEphemeral(handle.toInt(), intPointer);

    final errorCode = ErrorCode.fromInt(result);

    final int output = (errorCode == ErrorCode.success) ? intPointer.value.toInt() : 0;

    return AskarResult<bool>(errorCode, intToBool(output));
  } finally {
    freePointer(intPointer);
  }
}

AskarResult<String> askarKeyGetJwkPublic(
  LocalKeyHandle handle,
  KeyAlgorithm algorithm,
) {
  Pointer<Pointer<Utf8>> out = calloc<Pointer<Utf8>>();

  Pointer<Utf8> algPtr = nullptr;

  try {
    algPtr = algorithm.value.toNativeUtf8();

    final funcResult = nativeAskarKeyGetJwkPublic(
      handle.toInt(),
      algPtr,
      out,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final String value = (errorCode == ErrorCode.success) ? out.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freeDoublePointer(out);
    freePointer(algPtr);
  }
}

ErrorCode askarKeyGetJwkSecret(
  LocalKeyHandle handle,
  Pointer<NativeSecretBuffer> out,
) {
  final result = nativeAskarKeyGetJwkSecret(
    handle.toInt(),
    out,
  );

  return ErrorCode.fromInt(result);
}

AskarResult<String> askarKeyGetJwkThumbprint(
  LocalKeyHandle handle,
  KeyAlgorithm alg,
) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  Pointer<Utf8> algPointer = nullptr;

  try {
    algPointer = alg.value.toNativeUtf8();

    final funcResult = nativeAskarKeyGetJwkThumbprint(
      handle.toInt(),
      algPointer,
      utf8PtPointer,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final String value =
        (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freeDoublePointer(utf8PtPointer);
    freePointer(algPointer);
  }
}

AskarResult<Uint8List> askarKeyGetPublicBytes(LocalKeyHandle handle) {
  Pointer<NativeSecretBuffer> secretBufferPtr = calloc<NativeSecretBuffer>();

  try {
    final funcResult = nativeAskarKeyGetPublicBytes(
      handle.toInt(),
      secretBufferPtr,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final value = (errorCode == ErrorCode.success)
        ? secretBufferToBytesList(secretBufferPtr.ref)
        : Uint8List(0);

    return AskarResult<Uint8List>(errorCode, value);
  } finally {
    freeSecretBufferPointer(secretBufferPtr);
  }
}

AskarResult<Uint8List> askarKeyGetSecretBytes(LocalKeyHandle handle) {
  Pointer<NativeSecretBuffer> secretBufferPtr = calloc<NativeSecretBuffer>();

  try {
    final funcResult = nativeAskarKeyGetSecretBytes(
      handle.toInt(),
      secretBufferPtr,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final value = (errorCode == ErrorCode.success)
        ? secretBufferToBytesList(secretBufferPtr.ref)
        : Uint8List(0);

    return AskarResult<Uint8List>(errorCode, value);
  } finally {
    freeSecretBufferPointer(secretBufferPtr);
  }
}

AskarResult<Uint8List> askarKeySignMessage(
  LocalKeyHandle handle,
  Uint8List message,
  SignatureAlgorithm sigType,
) {
  Pointer<NativeSecretBuffer> secretBufferPointer = calloc<NativeSecretBuffer>();

  Pointer<Utf8> sigTypePointer = nullptr;
  Pointer<NativeByteBuffer> byteBufferPointer = nullptr;

  try {
    sigTypePointer = sigType.value.toNativeUtf8();
    byteBufferPointer = bytesListToByteBuffer(message);

    NativeByteBuffer byteBuffer = byteBufferPointer.ref;

    final funcResult = nativeAskarKeySignMessage(
      handle.toInt(),
      byteBuffer,
      sigTypePointer,
      secretBufferPointer,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final value = (errorCode == ErrorCode.success)
        ? secretBufferToBytesList(secretBufferPointer.ref)
        : Uint8List(0);

    return AskarResult<Uint8List>(errorCode, value);
  } finally {
    freeSecretBufferPointer(secretBufferPointer);
    freePointer(sigTypePointer);
    freeByteBufferPointer(byteBufferPointer);
  }
}

AskarResult<LocalKeyHandle> askarKeyUnwrapKey(
    LocalKeyHandle handle, KeyAlgorithm algorithm, Uint8List ciphertext,
    {Uint8List? nonce, Uint8List? tag}) {
  Pointer<NativeLocalKeyHandle> out = calloc<NativeLocalKeyHandle>();

  Pointer<Utf8> algPtr = nullptr;
  Pointer<NativeByteBuffer> cipherByteBufferPtr = nullptr;
  Pointer<NativeByteBuffer> nonceByteBufferPtr = nullptr;
  Pointer<NativeByteBuffer> tagByteBufferPtr = nullptr;

  try {
    algPtr = algorithm.value.toNativeUtf8();
    cipherByteBufferPtr = bytesListToByteBuffer(ciphertext);
    nonceByteBufferPtr = bytesListToByteBuffer(nonce);
    tagByteBufferPtr = bytesListToByteBuffer(tag);

    final funcResult = nativeAskarKeyUnwrapKey(
      handle.toInt(),
      algPtr,
      cipherByteBufferPtr.ref,
      nonceByteBufferPtr.ref,
      tagByteBufferPtr.ref,
      out,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final value = LocalKeyHandle.fromPointer(errorCode, out);

    return AskarResult<LocalKeyHandle>(errorCode, value);
  } finally {
    freePointer(out);
    freePointer(algPtr);
    freeByteBufferPointer(cipherByteBufferPtr);
    freeByteBufferPointer(nonceByteBufferPtr);
    freeByteBufferPointer(tagByteBufferPtr);
  }
}

AskarResult<bool> askarKeyVerifySignature(
  LocalKeyHandle handle,
  Uint8List message,
  Uint8List signature,
  SignatureAlgorithm sigType,
) {
  Pointer<Int8> intPointer = calloc<Int8>();

  Pointer<Utf8> sigTypePointer = nullptr;
  Pointer<NativeByteBuffer> messageAsByteBufferPt = nullptr;
  Pointer<NativeByteBuffer> signatureAsByteBufferPt = nullptr;

  try {
    sigTypePointer = sigType.value.toNativeUtf8();
    messageAsByteBufferPt = bytesListToByteBuffer(message);
    signatureAsByteBufferPt = bytesListToByteBuffer(signature);

    final funcResult = nativeAskarKeyVerifySignature(
      handle.toInt(),
      messageAsByteBufferPt.ref,
      signatureAsByteBufferPt.ref,
      sigTypePointer,
      intPointer,
    );

    final errorCode = ErrorCode.fromInt(funcResult);

    final int output = (errorCode == ErrorCode.success) ? intPointer.value.toInt() : 0;

    return AskarResult<bool>(errorCode, intToBool(output));
  } finally {
    freePointer(intPointer);
    freePointer(sigTypePointer);
    freeByteBufferPointer(messageAsByteBufferPt);
    freeByteBufferPointer(signatureAsByteBufferPt);
  }
}

AskarResult<EncryptedBuffer> askarKeyWrapKey(LocalKeyHandle handle, LocalKeyHandle other,
    {Uint8List? nonce}) {
  Pointer<NativeEncryptedBuffer> encryptedBufferPtr = calloc<NativeEncryptedBuffer>();

  Pointer<NativeByteBuffer> byteBufferPointer = nullptr;

  try {
    byteBufferPointer = bytesListToByteBuffer(nonce);

    final errorCode = ErrorCode.fromInt(nativeAskarKeyWrapKey(
      handle.toInt(),
      other.toInt(),
      byteBufferPointer.ref,
      encryptedBufferPtr,
    ));

    final value = (errorCode == ErrorCode.success)
        ? readNativeEncryptedBuffer(encryptedBufferPtr.ref)
        : EncryptedBuffer(Uint8List.fromList([]), 0, 0);

    return AskarResult<EncryptedBuffer>(errorCode, value);
  } finally {
    freeEncryptedBufferPointer(encryptedBufferPtr);
    freeByteBufferPointer(byteBufferPointer);
  }
}

AskarResult<StringListHandle> askarKeyGetSupportedBackends() {
  Pointer<NativeStringListHandle> handlePtr = calloc<NativeStringListHandle>();

  try {
    final errorCode = ErrorCode.fromInt(nativeAskarKeyGetSupportedBackends(handlePtr));

    StringListHandle handle = (errorCode == ErrorCode.success) ? handlePtr.value : 0;

    return AskarResult<StringListHandle>(errorCode, handle);
  } finally {
    freePointer(handlePtr);
  }
}

ErrorCode askarScanFree(ScanHandle handle) {
  final result = nativeAskarScanFree(handle.toInt());
  return ErrorCode.fromInt(result);
}

Future<AskarResult<EntryListHandle>> askarScanNext(ScanHandle handle) async {
  final callback = newCallbackWithHandle();

  final initialResult = nativeAskarScanNext(
      handle.toInt(), callback.nativeCallable.nativeFunction, callback.id);

  final completedResult = await callback.handleResult(initialResult);

  return AskarResult<EntryListHandle>(
      completedResult.errorCode, EntryListHandle(completedResult.value));
}

Future<AskarResult<ScanHandle>> askarScanStart(StoreHandle handle,
    {String? profile, String? category, Map? tagFilter, int? offset, int? limit}) async {
  Pointer<Utf8> profilePointer = nullptr;
  Pointer<Utf8> categoryPointer = nullptr;
  Pointer<Utf8> tagFilterPointer = nullptr;

  try {
    profilePointer = (profile ?? "").toNativeUtf8();
    categoryPointer = (category ?? "").toNativeUtf8();
    tagFilterPointer = jsonEncode(tagFilter).toNativeUtf8();

    final callback = newCallbackWithHandle();

    final initialResult = nativeAskarScanStart(
      handle.toInt(),
      profilePointer,
      categoryPointer,
      tagFilterPointer,
      (offset ?? 0),
      (limit ?? 0),
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    final completedResult = await callback.handleResult(initialResult);

    return AskarResult<ScanHandle>(
        completedResult.errorCode, ScanHandle(completedResult.value));
  } finally {
    freePointer(profilePointer);
    freePointer(categoryPointer);
    freePointer(tagFilterPointer);
  }
}

Future<AskarCallbackBlankResult> askarSessionClose(
    SessionHandle handle, bool commit) async {
  final callback = newCallbackWithoutHandle();

  final result = nativeAskarSessionClose(handle.toInt(), boolToInt(commit),
      callback.nativeCallable.nativeFunction, callback.id);

  return await callback.handleResult(result);
}

Future<AskarResult<int>> askarSessionCount(SessionHandle handle, String category,
    {Map<String, dynamic>? tagFilter}) async {
  Pointer<Utf8> categoryPointer = nullptr;
  Pointer<Utf8> tagFilterPointer = nullptr;

  try {
    categoryPointer = category.toNativeUtf8();
    tagFilterPointer = jsonEncode(tagFilter).toNativeUtf8();

    final callback = newCallbackWithInt64();

    final result = nativeAskarSessionCount(
      handle.toInt(),
      categoryPointer,
      tagFilterPointer,
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    final callbackResult = await callback.handleResult(result);

    return AskarResult(callbackResult.errorCode, callbackResult.value);
  } finally {
    freePointer(categoryPointer);
    freePointer(tagFilterPointer);
  }
}

Future<AskarResult<EntryListHandle>> askarSessionFetch(
  SessionHandle handle,
  String category,
  String name,
  bool forUpdate,
) async {
  Pointer<Utf8> categoryPointer = nullptr;
  Pointer<Utf8> namePointer = nullptr;

  try {
    categoryPointer = category.toNativeUtf8();
    namePointer = name.toNativeUtf8();

    final callback = newCallbackWithHandle();

    final initialResult = nativeAskarSessionFetch(
      handle.toInt(),
      categoryPointer,
      namePointer,
      boolToInt(forUpdate),
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    final callbackResult = await callback.handleResult(initialResult);

    if (callbackResult.errorCode == ErrorCode.success && callbackResult.value == 0) {
      throw Exception(
          "Invalid handle. This means that the function call succeeded but none was found.");
    }

    return AskarResult<EntryListHandle>(
        callbackResult.errorCode, EntryListHandle(callbackResult.value));
  } finally {
    freePointer(categoryPointer);
    freePointer(namePointer);
  }
}

Future<AskarResult<EntryListHandle>> askarSessionFetchAll(
    SessionHandle handle, String category,
    {required bool forUpdate, Map? tagFilter, int? limit}) async {
  Pointer<Utf8> categoryPtr = nullptr;
  Pointer<Utf8> tagFilterPtr = nullptr;

  try {
    categoryPtr = category.toNativeUtf8();
    tagFilterPtr = jsonEncode(tagFilter).toNativeUtf8();

    final callback = newCallbackWithHandle();

    final result = nativeAskarSessionFetchAll(
      handle.toInt(),
      categoryPtr,
      tagFilterPtr,
      (limit ?? 0),
      boolToInt(forUpdate),
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    final callbackResult = await callback.handleResult(result);

    return AskarResult<EntryListHandle>(
        callbackResult.errorCode, EntryListHandle(callbackResult.value));
  } finally {
    freePointer(categoryPtr);
    freePointer(tagFilterPtr);
  }
}

Future<AskarResult<KeyEntryListHandle>> askarSessionFetchAllKeys(SessionHandle handle,
    {required bool forUpdate,
    KeyAlgorithm? algorithm,
    String? thumbprint,
    Map? tagFilter,
    int? limit}) async {
  Pointer<Utf8> algPointer = nullptr;
  Pointer<Utf8> thumbprintPointer = nullptr;
  Pointer<Utf8> tagFilterPointer = nullptr;

  final algorithmStr = (algorithm == null) ? "" : algorithm.value;

  try {
    algPointer = algorithmStr.toNativeUtf8();
    thumbprintPointer = (thumbprint ?? "").toNativeUtf8();
    tagFilterPointer = jsonEncode(tagFilter ?? {}).toNativeUtf8();

    final callback = newCallbackWithHandle();

    final initialResult = nativeAskarSessionFetchAllKeys(
      handle.toInt(),
      algPointer,
      thumbprintPointer,
      tagFilterPointer,
      (limit ?? 0),
      boolToInt(forUpdate),
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    final completedResult = await callback.handleResult(initialResult);

    return AskarResult(
        completedResult.errorCode, KeyEntryListHandle(completedResult.value));
  } finally {
    freePointer(algPointer);
    freePointer(thumbprintPointer);
    freePointer(tagFilterPointer);
  }
}

Future<AskarResult<KeyEntryListHandle>> askarSessionFetchKey(
    SessionHandle handle, String name, bool forUpdate) async {
  Pointer<Utf8> namePointer = nullptr;

  try {
    namePointer = name.toNativeUtf8();

    final callback = newCallbackWithHandle();

    final initialResult = nativeAskarSessionFetchKey(
      handle.toInt(),
      namePointer,
      boolToInt(forUpdate),
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    final completedResult = await callback.handleResult(initialResult);

    return AskarResult<KeyEntryListHandle>(
        completedResult.errorCode, KeyEntryListHandle(completedResult.value));
  } finally {
    freePointer(namePointer);
  }
}

Future<AskarCallbackResult> askarSessionInsertKey(
    SessionHandle handle, LocalKeyHandle localKeyHandle, String name,
    {String? metadata, Map<String, dynamic>? tags, int? expiryMs}) async {
  Pointer<Utf8> namePointer = nullptr;
  Pointer<Utf8> metadataPointer = nullptr;
  Pointer<Utf8> tagsJsonPointer = nullptr;

  try {
    namePointer = name.toNativeUtf8();
    metadataPointer = (metadata ?? "").toNativeUtf8();
    tagsJsonPointer = jsonEncode(tags ?? {}).toNativeUtf8();

    final callback = newCallbackWithoutHandle();

    final result = nativeAskarSessionInsertKey(
      handle.toInt(),
      localKeyHandle.toInt(),
      namePointer,
      metadataPointer,
      tagsJsonPointer,
      (expiryMs ?? 0),
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    return await callback.handleResult(result);
  } finally {
    freePointer(namePointer);
    freePointer(metadataPointer);
    freePointer(tagsJsonPointer);
  }
}

Future<AskarCallbackResult> askarSessionRemoveAll(SessionHandle handle, String category,
    {Map<String, dynamic>? tagFilter}) async {
  Pointer<Utf8> categoryPointer = nullptr;
  Pointer<Utf8> tagFilterPointer = nullptr;

  try {
    categoryPointer = category.toNativeUtf8();
    tagFilterPointer = jsonEncode(tagFilter).toNativeUtf8();

    final callback = newCallbackWithInt64();

    final result = nativeAskarSessionRemoveAll(
      handle.toInt(),
      categoryPointer,
      tagFilterPointer,
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    return await callback.handleResult(result);
  } finally {
    freePointer(categoryPointer);
    freePointer(tagFilterPointer);
  }
}

Future<AskarCallbackResult> askarSessionRemoveKey(
  SessionHandle handle,
  String name,
) async {
  Pointer<Utf8> namePointer = nullptr;

  try {
    namePointer = name.toNativeUtf8();

    final callback = newCallbackWithoutHandle();

    final result = nativeAskarSessionRemoveKey(
      handle.toInt(),
      namePointer,
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    return await callback.handleResult(result);
  } finally {
    freePointer(namePointer);
  }
}

Future<AskarResult<SessionHandle>> askarSessionStart(StoreHandle handle,
    {required bool asTransaction, String? profile}) async {
  Pointer<Utf8> profilePointer = nullptr;

  try {
    profilePointer = (profile ?? "").toNativeUtf8();

    final callback = newCallbackWithHandle();

    final initialResult = nativeAskarSessionStart(
      handle.toInt(),
      profilePointer,
      boolToInt(asTransaction),
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    final completedResult = await callback.handleResult(initialResult);

    return AskarResult(completedResult.errorCode, SessionHandle(completedResult.value));
  } finally {
    freePointer(profilePointer);
  }
}

Future<AskarCallbackResult> askarSessionUpdate(
    SessionHandle handle, EntryOperation operation, String category, String name,
    {String? value, Map<String, dynamic>? tags, int? expiryMs}) async {
  Pointer<Utf8> categoryPointer = nullptr;
  Pointer<Utf8> namePointer = nullptr;
  Pointer<Utf8> tagsPointer = nullptr;
  Pointer<NativeByteBuffer> byteBufferPointer = nullptr;

  try {
    categoryPointer = category.toNativeUtf8();
    namePointer = name.toNativeUtf8();
    tagsPointer = jsonEncode(tags).toNativeUtf8();
    byteBufferPointer = stringToByteBuffer(value ?? "");

    final callback = newCallbackWithoutHandle();

    final result = nativeAskarSessionUpdate(
      handle.toInt(),
      operation.value,
      categoryPointer,
      namePointer,
      byteBufferPointer.ref,
      tagsPointer,
      (expiryMs ?? 0),
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    return await callback.handleResult(result);
  } finally {
    freePointer(categoryPointer);
    freePointer(namePointer);
    freePointer(tagsPointer);
    freeByteBufferPointer(byteBufferPointer);
  }
}

Future<AskarCallbackResult> askarSessionUpdateKey(
  SessionHandle handle,
  String name, {
  String? metadata,
  Map<String, dynamic>? tags,
  int? expiryMs,
}) async {
  Pointer<Utf8> namePointer = nullptr;
  Pointer<Utf8> metadataPointer = nullptr;
  Pointer<Utf8> tagsPointer = nullptr;

  try {
    namePointer = name.toNativeUtf8();

    metadataPointer = (metadata ?? "").toNativeUtf8();
    tagsPointer = jsonEncode(tags ?? {}).toNativeUtf8();

    final callback = newCallbackWithoutHandle();

    final result = nativeAskarSessionUpdateKey(
      handle.toInt(),
      namePointer,
      metadataPointer,
      tagsPointer,
      (expiryMs ?? 0),
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    return await callback.handleResult(result);
  } finally {
    freePointer(namePointer);
    freePointer(metadataPointer);
    freePointer(tagsPointer);
  }
}

Future<AskarCallbackResult> askarStoreClose(StoreHandle handle) async {
  final callback = newCallbackWithoutHandle();

  final result = nativeAskarStoreClose(
    handle.toInt(),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return await callback.handleResult(result);
}

ErrorCode askarStoreCopy(
  StoreHandle handle,
  String targetUri,
  String keyMethod,
  String passKey,
  int recreate,
  Pointer<NativeFunction<AskarStoreCopyCallback>> cb,
  int cbId,
) {
  Pointer<Utf8> targetUriPointer = nullptr;
  Pointer<Utf8> keyMethodPointer = nullptr;
  Pointer<Utf8> passKeyPointer = nullptr;

  try {
    targetUriPointer = targetUri.toNativeUtf8();
    keyMethodPointer = keyMethod.toNativeUtf8();
    passKeyPointer = passKey.toNativeUtf8();

    final result = nativeAskarStoreCopy(
      handle.toInt(),
      targetUriPointer,
      keyMethodPointer,
      passKeyPointer,
      recreate,
      cb,
      cbId,
    );

    return ErrorCode.fromInt(result);
  } finally {
    freePointer(targetUriPointer);
    freePointer(keyMethodPointer);
    freePointer(passKeyPointer);
  }
}

Future<AskarCallbackResult> askarStoreCreateProfile(StoreHandle handle,
    {String? profile}) async {
  Pointer<Utf8> profilePointer = nullptr;

  try {
    profilePointer = (profile ?? "").toNativeUtf8();

    final callback = newCallbackWithPtrUtf8();

    final result = nativeAskarStoreCreateProfile(
      handle.toInt(),
      profilePointer,
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    return await callback.handleResult(result);
  } finally {
    freePointer(profilePointer);
  }
}

AskarResult<String> askarStoreGenerateRawKey({Uint8List? seed}) {
  // Generate a random seed if not provided
  seed ??= generateRandomSeed();

  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  Pointer<NativeByteBuffer> byteBufferPointer = nullptr;

  try {
    byteBufferPointer = bytesListToByteBuffer(seed);

    final funcResult =
        nativeAskarStoreGenerateRawKey(byteBufferPointer.ref, utf8PtPointer);

    final errorCode = ErrorCode.fromInt(funcResult);

    final String value =
        (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

    return AskarResult<String>(errorCode, value);
  } finally {
    freePointer(utf8PtPointer);
    freeByteBufferPointer(byteBufferPointer);
  }
}

Future<AskarCallbackResult> askarStoreGetDefaultProfile(
  StoreHandle handle,
) async {
  final callback = newCallbackWithPtrUtf8();

  final result = nativeAskarStoreGetDefaultProfile(
    handle.toInt(),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return await callback.handleResult(result);
}

Future<AskarResult<String>> askarStoreGetProfileName(
  StoreHandle handle,
) async {
  final callback = newCallbackWithPtrUtf8();

  final initialResult = nativeAskarStoreGetProfileName(
    handle.toInt(),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  final completedResult = await callback.handleResult(initialResult);

  return AskarResult(completedResult.errorCode, completedResult.value);
}

Future<AskarCallbackBlankResult> askarStoreSetDefaultProfile(
    StoreHandle handle, String profile) async {
  Pointer<Utf8> profilePointer = nullptr;

  try {
    profilePointer = profile.toNativeUtf8();

    final callback = newCallbackWithoutHandle();

    final result = nativeAskarStoreSetDefaultProfile(
      handle.toInt(),
      profilePointer,
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    return await callback.handleResult(result);
  } finally {
    freePointer(profilePointer);
  }
}

Future<AskarResult<StringListHandle>> askarStoreListProfiles(
  StoreHandle handle,
) async {
  final callback = newCallbackWithHandle();

  final initialResult = nativeAskarStoreListProfiles(
    handle.toInt(),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  final completedResult = await callback.handleResult(initialResult);

  return AskarResult(completedResult.errorCode, completedResult.value);
}

Future<AskarResult<StoreHandle>> askarStoreOpen(String specUri,
    {StoreKeyMethod? keyMethod, String? passKey, String? profile}) async {
  Pointer<Utf8> specUriPointer = nullptr;
  Pointer<Utf8> keyMethodPointer = nullptr;
  Pointer<Utf8> passKeyPointer = nullptr;
  Pointer<Utf8> profilePointer = nullptr;

  final keyMethodStr = (keyMethod == null) ? "" : keyMethod.value;

  try {
    specUriPointer = specUri.toNativeUtf8();

    keyMethodPointer = keyMethodStr.toNativeUtf8();
    passKeyPointer = (passKey ?? "").toNativeUtf8();
    profilePointer = (profile ?? "").toNativeUtf8();

    final callback = newCallbackWithHandle();

    final initialResult = nativeAskarStoreOpen(
      specUriPointer,
      keyMethodPointer,
      passKeyPointer,
      profilePointer,
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    final completedResult = await callback.handleResult(initialResult);

    return AskarResult(completedResult.errorCode, StoreHandle(completedResult.value));
  } finally {
    freePointer(specUriPointer);
    freePointer(keyMethodPointer);
    freePointer(passKeyPointer);
    freePointer(profilePointer);
  }
}

Future<AskarResult<StoreHandle>> askarStoreProvision(
  String specUri, {
  required bool recreate,
  StoreKeyMethod? keyMethod,
  String? passKey,
  String? profile,
}) async {
  Pointer<Utf8> specUriPointer = nullptr;
  Pointer<Utf8> keyMethodPointer = nullptr;
  Pointer<Utf8> passKeyPointer = nullptr;
  Pointer<Utf8> profilePointer = nullptr;

  final keyMethodStr = (keyMethod == null) ? "" : keyMethod.value;

  try {
    specUriPointer = specUri.toNativeUtf8();

    keyMethodStr.toNativeUtf8();
    passKeyPointer = (passKey ?? "").toNativeUtf8();
    profilePointer = (profile ?? "").toNativeUtf8();

    final callback = newCallbackWithHandle();

    final initialResult = nativeAskarStoreProvision(
      specUriPointer,
      keyMethodPointer,
      passKeyPointer,
      profilePointer,
      boolToInt(recreate),
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    final completedResult = await callback.handleResult(initialResult);

    return AskarResult(completedResult.errorCode, StoreHandle(completedResult.value));
  } finally {
    freePointer(specUriPointer);
    freePointer(keyMethodPointer);
    freePointer(passKeyPointer);
    freePointer(profilePointer);
  }
}

Future<AskarCallbackResult> askarStoreRekey(StoreHandle handle, String passKey,
    {StoreKeyMethod? keyMethod}) async {
  Pointer<Utf8> passKeyPointer = nullptr;
  Pointer<Utf8> keyMethodPointer = nullptr;

  final keyMethodStr = (keyMethod == null) ? "" : keyMethod.value;

  try {
    passKeyPointer = passKey.toNativeUtf8();
    keyMethodPointer = keyMethodStr.toNativeUtf8();

    final callback = newCallbackWithoutHandle();

    final result = nativeAskarStoreRekey(
      handle.toInt(),
      keyMethodPointer,
      passKeyPointer,
      callback.nativeCallable.nativeFunction,
      callback.id,
    );

    return await callback.handleResult(result);
  } finally {
    freePointer(passKeyPointer);
    freePointer(keyMethodPointer);
  }
}

ErrorCode askarStoreRemove(
  String specUri,
  Pointer<NativeFunction<AskarStoreRemoveCallback>> cb,
  int cbId,
) {
  Pointer<Utf8> specUriPointer = nullptr;

  try {
    specUriPointer = specUri.toNativeUtf8();

    final result = nativeAskarStoreRemove(
      specUriPointer,
      cb,
      cbId,
    );

    return ErrorCode.fromInt(result);
  } finally {
    freePointer(specUriPointer);
  }
}

ErrorCode askarStoreRemoveProfile(
  StoreHandle handle,
  String profile,
  Pointer<NativeFunction<AskarStoreRemoveProfileCallback>> cb,
  int cbId,
) {
  Pointer<Utf8> profilePointer = nullptr;

  try {
    profilePointer = profile.toNativeUtf8();

    final result = nativeAskarStoreRemoveProfile(
      handle.toInt(),
      profilePointer,
      cb,
      cbId,
    );

    return ErrorCode.fromInt(result);
  } finally {
    freePointer(profilePointer);
  }
}

ErrorCode askarMigrateIndySdk(
  String specUri,
  String walletName,
  String walletKey,
  String kdfLevel,
  Pointer<NativeFunction<AskarMigrateIndySdkCallback>> cb,
  int cbId,
) {
  Pointer<Utf8> specUriPointer = nullptr;
  Pointer<Utf8> walletNamePointer = nullptr;
  Pointer<Utf8> walletKeyPointer = nullptr;
  Pointer<Utf8> kdfLevelPointer = nullptr;

  try {
    specUriPointer = specUri.toNativeUtf8();
    walletNamePointer = walletName.toNativeUtf8();
    walletKeyPointer = walletKey.toNativeUtf8();
    kdfLevelPointer = kdfLevel.toNativeUtf8();

    final result = nativeAskarMigrateIndySdk(
      specUriPointer,
      walletNamePointer,
      walletKeyPointer,
      kdfLevelPointer,
      cb,
      cbId,
    );

    return ErrorCode.fromInt(result);
  } finally {
    freePointer(specUriPointer);
    freePointer(walletNamePointer);
    freePointer(walletKeyPointer);
    freePointer(kdfLevelPointer);
  }
}

void freeByteBufferPointer(Pointer<NativeByteBuffer> byteBufferPtr) {
  if (byteBufferPtr == nullptr) return;

  freePointer(byteBufferPtr.ref.data);

  calloc.free(byteBufferPtr);
}

void freeSecretBufferPointer(Pointer<NativeSecretBuffer> secretBufferPtr) {
  if (secretBufferPtr == nullptr) return;

  freePointer(secretBufferPtr.ref.data);

  calloc.free(secretBufferPtr);
}

void freeEncryptedBufferPointer(Pointer<NativeEncryptedBuffer> encryptedBufferPtr) {
  if (encryptedBufferPtr == nullptr) return;

  freePointer(encryptedBufferPtr.ref.buffer.data);

  calloc.free(encryptedBufferPtr);
}

void freeDoublePointer(Pointer<Pointer<NativeType>> doublePointer) {
  if (doublePointer == nullptr) return;

  freePointer(doublePointer.value);

  calloc.free(doublePointer);
}

void freePointer(Pointer<NativeType> pointer) {
  if (pointer != nullptr) {
    calloc.free(pointer);
  }
}
