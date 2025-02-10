import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:import_so_libaskar/askar/askar_callbacks.dart';
import 'package:import_so_libaskar/askar/crypto/askar_encrypted_buffer.dart';
import 'package:import_so_libaskar/askar/crypto/askar_handles.dart';
import 'package:import_so_libaskar/askar/enums/askar_entry_operation.dart';
import 'package:import_so_libaskar/askar/enums/askar_error_code.dart';
import 'package:import_so_libaskar/askar/enums/askar_key_algorithm.dart';
import 'package:import_so_libaskar/askar/enums/askar_key_backend.dart';
import 'package:import_so_libaskar/askar/enums/askar_signature_algorithm.dart';
import 'package:import_so_libaskar/askar/enums/askar_store_key_method.dart';
import 'package:import_so_libaskar/askar/exceptions/exceptions.dart';

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
  Pointer<Utf8> resultPointer = nativeAskarVersion();
  return resultPointer.toDartString();
}

AskarResult<String> askarGetCurrentError() {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult = nativeAskarGetCurrentError(utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
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

  final funcResult = nativeAskarEntryListCount(handle.toInt(), countPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  int count = countPointer.value;

  calloc.free(countPointer);

  return AskarResult<int>(errorCode, count);
}

void askarEntryListFree(EntryListHandle handle) {
  nativeAskarEntryListFree(handle.toInt());
}

AskarResult<String> askarEntryListGetCategory(EntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult =
      nativeAskarEntryListGetCategory(handle.toInt(), index, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<String> askarEntryListGetName(EntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult = nativeAskarEntryListGetName(handle.toInt(), index, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<Map<String, dynamic>> askarEntryListGetTags(
    EntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PointerPointer = calloc<Pointer<Utf8>>();

  final funcResult =
      nativeAskarEntryListGetTags(handle.toInt(), index, utf8PointerPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  Map<String, dynamic> value = {};

  if (errorCode == ErrorCode.success) {
    String mapString = utf8PointerPointer.value.toDartString();
    value = jsonDecode(mapString);
  }

  calloc.free(utf8PointerPointer.value);
  calloc.free(utf8PointerPointer);

  return AskarResult<Map<String, dynamic>>(errorCode, value);
}

AskarResult<Uint8List> askarEntryListGetValue(EntryListHandle handle, int index) {
  Pointer<NativeSecretBuffer> secretBufferPointer = calloc<NativeSecretBuffer>();

  final funcResult =
      nativeAskarEntryListGetValue(handle.toInt(), index, secretBufferPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final Uint8List value = (errorCode == ErrorCode.success)
      ? secretBufferToBytesList(secretBufferPointer.ref)
      : Uint8List(0);

  calloc.free(secretBufferPointer.ref.data);
  calloc.free(secretBufferPointer);

  return AskarResult<Uint8List>(errorCode, value);
}

AskarResult<int> askarStringListCount(StringListHandle handle) {
  Pointer<Int32> countPtr = calloc<Int32>();

  final errorCode = ErrorCode.fromInt(nativeAskarStringListCount(handle, countPtr));
  final count = countPtr.value;

  calloc.free(countPtr);

  return AskarResult<int>(errorCode, count);
}

void askarStringListFree(StringListHandle handle) {
  nativeAskarStringListFree(handle);
}

AskarResult<String> askarStringListGetItem(StringListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtrPointer = calloc<Pointer<Utf8>>();

  final errorCode =
      ErrorCode.fromInt(nativeAskarStringListGetItem(handle, index, utf8PtrPointer));

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtrPointer.value.toDartString() : "";

  calloc.free(utf8PtrPointer.value);
  calloc.free(utf8PtrPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<Uint8List> askarKeyAeadDecrypt(
    LocalKeyHandle handle, Uint8List ciphertext, Uint8List nonce,
    {Uint8List? tag, Uint8List? aad}) {
  aad ??= Uint8List(0);

  Pointer<NativeByteBuffer> ciphertextPtr = bytesListToByteBuffer(ciphertext);
  Pointer<NativeByteBuffer> noncePtr = bytesListToByteBuffer(nonce);
  Pointer<NativeByteBuffer> tagPtr = bytesListToByteBuffer(tag);
  Pointer<NativeByteBuffer> aadPtr = bytesListToByteBuffer(aad);
  Pointer<NativeSecretBuffer> secretBufferPointer = calloc<NativeSecretBuffer>();

  final funcResult = nativeAskarKeyAeadDecrypt(
    handle.toInt(),
    ciphertextPtr.ref,
    noncePtr.ref,
    tagPtr.ref,
    aadPtr.ref,
    secretBufferPointer,
  );

  final errorCode = ErrorCode.fromInt(funcResult);
  final decryptedData = secretBufferToBytesList(secretBufferPointer.ref);

  calloc.free(secretBufferPointer);
  calloc.free(ciphertextPtr.ref.data);
  calloc.free(ciphertextPtr);
  calloc.free(noncePtr.ref.data);
  calloc.free(noncePtr);
  calloc.free(tagPtr.ref.data);
  calloc.free(tagPtr);
  calloc.free(aadPtr.ref.data);
  calloc.free(aadPtr);

  return AskarResult<Uint8List>(errorCode, decryptedData);
}

AskarResult<AskarEncryptedBuffer> askarKeyAeadEncrypt(
    LocalKeyHandle localKeyHandle, Uint8List message,
    {Uint8List? nonce, Uint8List? aad}) {
  final randomNonce = askarKeyAeadRandomNonce(localKeyHandle);
  nonce ??= randomNonce.value;
  aad ??= Uint8List(0);

  Pointer<NativeByteBuffer> messagePtr = bytesListToByteBuffer(message);
  Pointer<NativeByteBuffer> noncePtr = bytesListToByteBuffer(nonce);
  Pointer<NativeByteBuffer> aadPtr = bytesListToByteBuffer(aad);
  Pointer<NativeEncryptedBuffer> outPtr = calloc<NativeEncryptedBuffer>();

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
      : AskarEncryptedBuffer(Uint8List.fromList([]), 0, 0);

  calloc.free(messagePtr.ref.data);
  calloc.free(noncePtr.ref.data);
  calloc.free(aadPtr.ref.data);
  calloc.free(messagePtr);
  calloc.free(noncePtr);
  calloc.free(aadPtr);
  calloc.free(outPtr);

  return AskarResult<AskarEncryptedBuffer>(errorCode, value);
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

AskarResult<Uint8List> askarKeyAeadRandomNonce(
  LocalKeyHandle handle,
) {
  Pointer<NativeSecretBuffer> secretBufferPtr = calloc<NativeSecretBuffer>();

  final funcResult = nativeAskarKeyAeadRandomNonce(
    handle.toInt(),
    secretBufferPtr,
  );

  final errorCode = ErrorCode.fromInt(funcResult);

  final value = secretBufferToBytesList(secretBufferPtr.ref);

  calloc.free(secretBufferPtr.ref.data);
  calloc.free(secretBufferPtr);

  return AskarResult<Uint8List>(errorCode, value);
}

AskarResult<LocalKeyHandle> askarKeyConvert(
  LocalKeyHandle handle,
  KeyAlgorithm alg,
) {
  Pointer<NativeLocalKeyHandle> localKeyHandlePtr = calloc<NativeLocalKeyHandle>();

  final algPointer = alg.value.toNativeUtf8();

  final result = nativeAskarKeyConvert(
    handle.toInt(),
    algPointer,
    localKeyHandlePtr,
  );

  final errorCode = ErrorCode.fromInt(result);

  final localKeyHandle = LocalKeyHandle.fromPointer(errorCode, localKeyHandlePtr);

  calloc.free(algPointer);
  calloc.free(localKeyHandlePtr);

  return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
}

ErrorCode askarKeyCryptoBox(
  LocalKeyHandle recipKey,
  LocalKeyHandle senderKey,
  Pointer<NativeByteBuffer> message,
  Pointer<NativeByteBuffer> nonce,
  Pointer<NativeSecretBuffer> out,
) {
  final result = nativeAskarKeyCryptoBox(
    recipKey.toInt(),
    senderKey.toInt(),
    message,
    nonce,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyCryptoBoxOpen(
  LocalKeyHandle recipKey,
  LocalKeyHandle senderKey,
  Pointer<NativeByteBuffer> message,
  Pointer<NativeByteBuffer> nonce,
  Pointer<NativeSecretBuffer> out,
) {
  final result = nativeAskarKeyCryptoBoxOpen(
    recipKey.toInt(),
    senderKey.toInt(),
    message,
    nonce,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyCryptoBoxRandomNonce(
  Pointer<NativeSecretBuffer> out,
) {
  final result = nativeAskarKeyCryptoBoxRandomNonce(
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyCryptoBoxSeal(
  LocalKeyHandle handle,
  Pointer<NativeByteBuffer> message,
  Pointer<NativeSecretBuffer> out,
) {
  final result = nativeAskarKeyCryptoBoxSeal(
    handle.toInt(),
    message,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyCryptoBoxSealOpen(
  LocalKeyHandle handle,
  Pointer<NativeByteBuffer> ciphertext,
  Pointer<NativeSecretBuffer> out,
) {
  final result = nativeAskarKeyCryptoBoxSealOpen(
    handle.toInt(),
    ciphertext,
    out,
  );

  return ErrorCode.fromInt(result);
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

  final algPointer = algorithm.value.toNativeUtf8();
  final algIdByteBufferPtr = bytesListToByteBuffer(algId);
  final apuByteBufferPtr = bytesListToByteBuffer(apu);
  final apvByteBufferPtr = bytesListToByteBuffer(apv);
  final ccTagByteBufferPtr = bytesListToByteBuffer(ccTag);

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

  calloc.free(algIdByteBufferPtr.ref.data);
  calloc.free(algIdByteBufferPtr);
  calloc.free(apuByteBufferPtr.ref.data);
  calloc.free(apuByteBufferPtr);
  calloc.free(apvByteBufferPtr.ref.data);
  calloc.free(apvByteBufferPtr);
  calloc.free(ccTagByteBufferPtr.ref.data);
  calloc.free(ccTagByteBufferPtr);
  calloc.free(algPointer);
  calloc.free(outPtr);

  return AskarResult<LocalKeyHandle>(errorCode, value);
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

  final algPointer = algorithm.value.toNativeUtf8();
  final algIdByteBufferPtr = bytesListToByteBuffer(algId);
  final apuByteBufferPtr = bytesListToByteBuffer(apu);
  final apvByteBufferPtr = bytesListToByteBuffer(apv);

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

  calloc.free(algIdByteBufferPtr.ref.data);
  calloc.free(algIdByteBufferPtr);
  calloc.free(apuByteBufferPtr.ref.data);
  calloc.free(apuByteBufferPtr);
  calloc.free(apvByteBufferPtr.ref.data);
  calloc.free(apvByteBufferPtr);
  calloc.free(algPointer);
  calloc.free(outPtr);

  return AskarResult<LocalKeyHandle>(errorCode, value);
}

AskarResult<int> askarKeyEntryListCount(KeyEntryListHandle handle) {
  Pointer<Int32> countPointer = calloc<Int32>();

  final funcResult = nativeAskarKeyEntryListCount(handle.toInt(), countPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  int count = countPointer.value;

  calloc.free(countPointer);

  return AskarResult<int>(errorCode, count);
}

void askarKeyEntryListFree(KeyEntryListHandle handle) {
  nativeAskarKeyEntryListFree(handle.toInt());
}

AskarResult<String> askarKeyEntryListGetAlgorithm(KeyEntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();
  final result =
      nativeAskarKeyEntryListGetAlgorithm(handle.toInt(), index, utf8PtPointer);
  final errorCode = ErrorCode.fromInt(result);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<String> askarKeyEntryListGetMetadata(KeyEntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult =
      nativeAskarKeyEntryListGetMetadata(handle.toInt(), index, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<String> askarKeyEntryListGetName(KeyEntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final result = nativeAskarKeyEntryListGetName(handle.toInt(), index, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(result);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<Map<String, dynamic>> askarKeyEntryListGetTags(
    KeyEntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();
  final result = nativeAskarKeyEntryListGetTags(handle.toInt(), index, utf8PtPointer);
  final errorCode = ErrorCode.fromInt(result);

  Map<String, dynamic> value = {};

  if (errorCode == ErrorCode.success) {
    String mapString = utf8PtPointer.value.toDartString();
    value = jsonDecode(mapString);
  }
  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<Map<String, dynamic>>(errorCode, value);
}

AskarResult<LocalKeyHandle> askarKeyEntryListLoadLocal(
    KeyEntryListHandle handle, int index) {
  Pointer<IntPtr> outPtr = calloc<IntPtr>();

  final funcResult = nativeAskarKeyEntryListLoadLocal(handle.toInt(), index, outPtr);

  final errorCode = ErrorCode.fromInt(funcResult);

  final out = LocalKeyHandle.fromPointer(errorCode, outPtr);

  calloc.free(outPtr);

  return AskarResult<LocalKeyHandle>(errorCode, out);
}

void askarKeyFree(LocalKeyHandle handle) {
  nativeAskarKeyFree(handle.toInt());
}

AskarResult<LocalKeyHandle> askarKeyFromJwk(String jwk) {
  Pointer<NativeLocalKeyHandle> outPtr = calloc<NativeLocalKeyHandle>();

  final jwkByteBufferPtr = stringToByteBuffer(jwk);

  final errorCode =
      ErrorCode.fromInt(nativeAskarKeyFromJwk(jwkByteBufferPtr.ref, outPtr));

  final value = LocalKeyHandle.fromPointer(errorCode, outPtr);

  calloc.free(outPtr);
  calloc.free(jwkByteBufferPtr.ref.data);
  calloc.free(jwkByteBufferPtr);

  return AskarResult<LocalKeyHandle>(errorCode, value);
}

AskarResult<LocalKeyHandle> askarKeyFromKeyExchange(
  KeyAlgorithm alg,
  LocalKeyHandle skHandle,
  LocalKeyHandle pkHandle,
) {
  Pointer<NativeLocalKeyHandle> localKeyHandlePtr = calloc<NativeLocalKeyHandle>();

  final algPointer = alg.value.toNativeUtf8();

  final result = nativeAskarKeyFromKeyExchange(
    algPointer,
    skHandle.toInt(),
    pkHandle.toInt(),
    localKeyHandlePtr,
  );

  final errorCode = ErrorCode.fromInt(result);

  final localKeyHandle = LocalKeyHandle.fromPointer(errorCode, localKeyHandlePtr);

  calloc.free(algPointer);
  calloc.free(localKeyHandlePtr);

  return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
}

AskarResult<LocalKeyHandle> askarKeyFromPublicBytes(
  KeyAlgorithm algorithm,
  Uint8List publicBytes,
) {
  Pointer<NativeLocalKeyHandle> localKeyHandlePtr = calloc<NativeLocalKeyHandle>();

  final algPointer = algorithm.value.toNativeUtf8();
  final byteBufferPointer = bytesListToByteBuffer(publicBytes);

  final funcResult = nativeAskarKeyFromPublicBytes(
    algPointer,
    byteBufferPointer.ref,
    localKeyHandlePtr,
  );

  final errorCode = ErrorCode.fromInt(funcResult);

  final localKeyHandle = LocalKeyHandle.fromPointer(errorCode, localKeyHandlePtr);

  calloc.free(algPointer);
  calloc.free(localKeyHandlePtr);
  calloc.free(byteBufferPointer.ref.data);
  calloc.free(byteBufferPointer);

  return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
}

AskarResult<LocalKeyHandle> askarKeyFromSecretBytes(
  KeyAlgorithm algorithm,
  Uint8List secret,
) {
  Pointer<NativeLocalKeyHandle> localKeyHandlePtr = calloc<NativeLocalKeyHandle>();

  final algPointer = algorithm.value.toNativeUtf8();
  final byteBufferPointer = bytesListToByteBuffer(secret);

  final funcResult = nativeAskarKeyFromSecretBytes(
    algPointer,
    byteBufferPointer.ref,
    localKeyHandlePtr,
  );

  final errorCode = ErrorCode.fromInt(funcResult);

  final localKeyHandle = LocalKeyHandle.fromPointer(errorCode, localKeyHandlePtr);

  calloc.free(byteBufferPointer.ref.data);
  calloc.free(byteBufferPointer);
  calloc.free(localKeyHandlePtr);

  return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
}

ErrorCode askarKeyFromSeed(
  String alg,
  Pointer<NativeByteBuffer> seed,
  String method,
  Pointer<NativeLocalKeyHandle> out,
) {
  final algPointer = alg.toNativeUtf8();
  final methodPointer = method.toNativeUtf8();

  final result = nativeAskarKeyFromSeed(
    algPointer,
    seed,
    methodPointer,
    out,
  );

  calloc.free(algPointer);
  calloc.free(methodPointer);

  return ErrorCode.fromInt(result);
}

AskarResult<LocalKeyHandle> askarKeyGenerate(
    KeyAlgorithm alg, KeyBackend keyBackend, bool ephemeral) {
  Pointer<NativeLocalKeyHandle> localKeyHandlePointer = calloc<NativeLocalKeyHandle>();

  final algPointer = alg.value.toNativeUtf8();
  final keyBackendPointer = keyBackend.value.toNativeUtf8();

  final funcResult = nativeAskarKeyGenerate(
      algPointer, keyBackendPointer, boolToInt(ephemeral), localKeyHandlePointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final localKeyHandle = LocalKeyHandle.fromPointer(errorCode, localKeyHandlePointer);

  calloc.free(algPointer);
  calloc.free(keyBackendPointer);
  calloc.free(localKeyHandlePointer);

  return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
}

AskarResult<String> askarKeyGetAlgorithm(LocalKeyHandle handle) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult = nativeAskarKeyGetAlgorithm(handle.toInt(), utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

ErrorCode askarKeyGetEphemeral(LocalKeyHandle handle, Pointer<Int8> out) {
  final result = nativeAskarKeyGetEphemeral(handle.toInt(), out);
  return ErrorCode.fromInt(result);
}

AskarResult<String> askarKeyGetJwkPublic(
  LocalKeyHandle handle,
  KeyAlgorithm algorithm,
) {
  Pointer<Pointer<Utf8>> out = calloc<Pointer<Utf8>>();

  final algPtr = algorithm.value.toNativeUtf8();

  final funcResult = nativeAskarKeyGetJwkPublic(
    handle.toInt(),
    algPtr,
    out,
  );

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value = (errorCode == ErrorCode.success) ? out.value.toDartString() : "";

  calloc.free(algPtr);
  calloc.free(out.value);
  calloc.free(out);

  return AskarResult<String>(errorCode, value);
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

  final algPointer = alg.value.toNativeUtf8();

  final funcResult = nativeAskarKeyGetJwkThumbprint(
    handle.toInt(),
    algPointer,
    utf8PtPointer,
  );

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(algPointer);
  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<Uint8List> askarKeyGetPublicBytes(LocalKeyHandle handle) {
  Pointer<NativeSecretBuffer> secretBufferPtr = calloc<NativeSecretBuffer>();

  final funcResult = nativeAskarKeyGetPublicBytes(
    handle.toInt(),
    secretBufferPtr,
  );

  final errorCode = ErrorCode.fromInt(funcResult);

  final value = secretBufferToBytesList(secretBufferPtr.ref);

  calloc.free(secretBufferPtr.ref.data);
  calloc.free(secretBufferPtr);

  return AskarResult<Uint8List>(errorCode, value);
}

AskarResult<Uint8List> askarKeyGetSecretBytes(LocalKeyHandle handle) {
  Pointer<NativeSecretBuffer> secretBufferPtr = calloc<NativeSecretBuffer>();

  final funcResult = nativeAskarKeyGetSecretBytes(
    handle.toInt(),
    secretBufferPtr,
  );

  final errorCode = ErrorCode.fromInt(funcResult);

  final value = secretBufferToBytesList(secretBufferPtr.ref);

  calloc.free(secretBufferPtr.ref.data);
  calloc.free(secretBufferPtr);

  return AskarResult<Uint8List>(errorCode, value);
}

AskarResult<Uint8List> askarKeySignMessage(
  LocalKeyHandle handle,
  Uint8List message,
  SignatureAlgorithm sigType,
) {
  Pointer<NativeSecretBuffer> secretBufferPointer = calloc<NativeSecretBuffer>();

  final sigTypePointer = sigType.value.toNativeUtf8();
  final byteBufferPointer = bytesListToByteBuffer(message);

  NativeByteBuffer byteBuffer = byteBufferPointer.ref;

  final funcResult = nativeAskarKeySignMessage(
    handle.toInt(),
    byteBuffer,
    sigTypePointer,
    secretBufferPointer,
  );

  final errorCode = ErrorCode.fromInt(funcResult);

  final value = secretBufferToBytesList(secretBufferPointer.ref);

  calloc.free(sigTypePointer);
  calloc.free(byteBufferPointer.ref.data);
  calloc.free(byteBufferPointer);
  calloc.free(secretBufferPointer.ref.data);
  calloc.free(secretBufferPointer);

  return AskarResult<Uint8List>(errorCode, value);
}

AskarResult<LocalKeyHandle> askarKeyUnwrapKey(
    LocalKeyHandle handle, KeyAlgorithm algorithm, Uint8List ciphertext,
    {Uint8List? nonce, Uint8List? tag}) {
  Pointer<NativeLocalKeyHandle> out = calloc<NativeLocalKeyHandle>();

  final algPtr = algorithm.value.toNativeUtf8();
  final cipherByteBufferPtr = bytesListToByteBuffer(ciphertext);
  final nonceByteBufferPtr = bytesListToByteBuffer(nonce);
  final tagByteBufferPtr = bytesListToByteBuffer(tag);

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

  calloc.free(cipherByteBufferPtr.ref.data);
  calloc.free(cipherByteBufferPtr);
  calloc.free(nonceByteBufferPtr.ref.data);
  calloc.free(nonceByteBufferPtr);
  calloc.free(tagByteBufferPtr.ref.data);
  calloc.free(tagByteBufferPtr);
  calloc.free(algPtr);
  calloc.free(out);

  return AskarResult<LocalKeyHandle>(errorCode, value);
}

AskarResult<bool> askarKeyVerifySignature(
  LocalKeyHandle handle,
  Uint8List message,
  Uint8List signature,
  SignatureAlgorithm sigType,
) {
  Pointer<Int8> intPointer = calloc<Int8>();

  final sigTypePointer = sigType.value.toNativeUtf8();

  final messageAsByteBufferPt = bytesListToByteBuffer(message);
  final signatureAsByteBufferPt = bytesListToByteBuffer(signature);

  final funcResult = nativeAskarKeyVerifySignature(
    handle.toInt(),
    messageAsByteBufferPt.ref,
    signatureAsByteBufferPt.ref,
    sigTypePointer,
    intPointer,
  );

  final errorCode = ErrorCode.fromInt(funcResult);

  final int output = (errorCode == ErrorCode.success) ? intPointer.value.toInt() : 0;

  calloc.free(intPointer);
  calloc.free(sigTypePointer);
  calloc.free(messageAsByteBufferPt.ref.data);
  calloc.free(messageAsByteBufferPt);
  calloc.free(signatureAsByteBufferPt.ref.data);
  calloc.free(signatureAsByteBufferPt);

  return AskarResult<bool>(errorCode, intToBool(output));
}

AskarResult<AskarEncryptedBuffer> askarKeyWrapKey(
    LocalKeyHandle handle, LocalKeyHandle other,
    {Uint8List? nonce}) {
  Pointer<NativeEncryptedBuffer> encryptedBufferPtr = calloc<NativeEncryptedBuffer>();

  final byteBufferPointer = bytesListToByteBuffer(nonce);

  final errorCode = ErrorCode.fromInt(nativeAskarKeyWrapKey(
    handle.toInt(),
    other.toInt(),
    byteBufferPointer.ref,
    encryptedBufferPtr,
  ));

  final value = (errorCode == ErrorCode.success)
      ? readNativeEncryptedBuffer(encryptedBufferPtr.ref)
      : AskarEncryptedBuffer(Uint8List.fromList([]), 0, 0);

  calloc.free(byteBufferPointer.ref.data);
  calloc.free(byteBufferPointer);
  calloc.free(encryptedBufferPtr.ref.buffer.data);
  calloc.free(encryptedBufferPtr);

  return AskarResult<AskarEncryptedBuffer>(errorCode, value);
}

AskarResult<StringListHandle> askarKeyGetSupportedBackends() {
  Pointer<NativeStringListHandle> handlePtr = calloc<NativeStringListHandle>();

  final errorCode = ErrorCode.fromInt(nativeAskarKeyGetSupportedBackends(handlePtr));

  StringListHandle handle = handlePtr.value;

  calloc.free(handlePtr);

  return AskarResult<StringListHandle>(errorCode, handle);
}

ErrorCode askarScanFree(ScanHandle handle) {
  final result = nativeAskarScanFree(handle.toInt());
  return ErrorCode.fromInt(result);
}

Future<AskarResult<EntryListHandle>> askarScanNext(
  ScanHandle handle,
) async {
  final callback = newCallbackWithHandle(() => {});

  final initialResult = nativeAskarScanNext(
      handle.toInt(), callback.nativeCallable.nativeFunction, callback.id);

  final completedResult = await callback.handleResult(initialResult);

  return AskarResult<EntryListHandle>(
      completedResult.errorCode, EntryListHandle(completedResult.value));
}

Future<AskarResult<ScanHandle>> askarScanStart(
  StoreHandle handle,
  String profile,
  String category,
  Map tagFilter,
  int offset,
  int limit,
) async {
  final profilePointer = profile.toNativeUtf8();
  final categoryPointer = category.toNativeUtf8();
  final tagFilterPointer = jsonEncode(tagFilter).toNativeUtf8();

  void cleanup() {
    calloc.free(profilePointer);
    calloc.free(categoryPointer);
    calloc.free(tagFilterPointer);
  }

  final callback = newCallbackWithHandle(cleanup);

  final initialResult = nativeAskarScanStart(
    handle.toInt(),
    profilePointer,
    categoryPointer,
    tagFilterPointer,
    offset,
    limit,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  final completedResult = await callback.handleResult(initialResult);

  return AskarResult<ScanHandle>(
      completedResult.errorCode, ScanHandle(completedResult.value));
}

Future<AskarCallbackBlankResult> askarSessionClose(
  SessionHandle handle,
  bool commit,
) async {
  final callback = newCallbackWithoutHandle(() => {});

  final result = nativeAskarSessionClose(handle.toInt(), boolToInt(commit),
      callback.nativeCallable.nativeFunction, callback.id);

  return await callback.handleResult(result);
}

Future<AskarCallbackResult> askarSessionCount(
  SessionHandle handle,
  String category,
  Map<String, String> tagFilter,
) {
  String jsonString = jsonEncode(tagFilter);

  final categoryPointer = category.toNativeUtf8();
  final tagFilterPointer = jsonString.toNativeUtf8();

  void cleanup() {
    calloc.free(categoryPointer);
    calloc.free(tagFilterPointer);
  }

  final callback = newCallbackWithInt64(cleanup);

  final result = nativeAskarSessionCount(
    handle.toInt(),
    categoryPointer,
    tagFilterPointer,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

Future<AskarResult<EntryListHandle>> askarSessionFetch(
  SessionHandle handle,
  String category,
  String name,
  bool forUpdate,
) async {
  final categoryPointer = category.toNativeUtf8();
  final namePointer = name.toNativeUtf8();

  void cleanup() {
    calloc.free(categoryPointer);
    calloc.free(namePointer);
  }

  final callback = newCallbackWithHandle(cleanup);

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
}

Future<AskarResult<EntryListHandle>> askarSessionFetchAll(
  SessionHandle handle,
  String category,
  Map tagFilter,
  int limit,
  bool forUpdate,
) async {
  final categoryPtr = category.toNativeUtf8();
  final tagFilterPtr = jsonEncode(tagFilter).toNativeUtf8();

  void cleanup() {
    calloc.free(categoryPtr);
    calloc.free(tagFilterPtr);
  }

  final callback = newCallbackWithHandle(cleanup);

  final result = nativeAskarSessionFetchAll(
    handle.toInt(),
    categoryPtr,
    tagFilterPtr,
    limit,
    boolToInt(forUpdate),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  final callbackResult = await callback.handleResult(result);

  return AskarResult<EntryListHandle>(
      callbackResult.errorCode, EntryListHandle(callbackResult.value));
}

Future<AskarResult<KeyEntryListHandle>> askarSessionFetchAllKeys(
  SessionHandle handle,
  KeyAlgorithm algorithm,
  String thumbprint,
  Map tagFilter,
  int limit,
  bool forUpdate,
) async {
  final algPointer = algorithm.value.toNativeUtf8();
  final thumbprintPointer = thumbprint.toNativeUtf8();
  final tagFilterPointer = jsonEncode(tagFilter).toNativeUtf8();

  void cleanup() {
    calloc.free(algPointer);
    calloc.free(thumbprintPointer);
    calloc.free(tagFilterPointer);
  }

  final callback = newCallbackWithHandle(cleanup);

  final initialResult = nativeAskarSessionFetchAllKeys(
    handle.toInt(),
    algPointer,
    thumbprintPointer,
    tagFilterPointer,
    limit,
    boolToInt(forUpdate),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  final completedResult = await callback.handleResult(initialResult);

  return AskarResult(
      completedResult.errorCode, KeyEntryListHandle(completedResult.value));
}

Future<AskarResult<KeyEntryListHandle>> askarSessionFetchKey(
    SessionHandle handle, String name, bool forUpdate) async {
  final namePointer = name.toNativeUtf8();

  void cleanup() {
    calloc.free(namePointer);
  }

  final callback = newCallbackWithHandle(cleanup);

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
}

Future<AskarCallbackResult> askarSessionInsertKey(SessionHandle handle,
    LocalKeyHandle localKeyHandle, String name, String metadata, Map tags, int expiryMs) {
  final namePointer = name.toNativeUtf8();
  final metadataPointer = metadata.toNativeUtf8();
  final tagsJsonPointer = jsonEncode(tags).toNativeUtf8();

  void cleanup() {
    calloc.free(namePointer);
    calloc.free(metadataPointer);
    calloc.free(tagsJsonPointer);
  }

  final callback = newCallbackWithoutHandle(cleanup);

  final result = nativeAskarSessionInsertKey(
    handle.toInt(),
    localKeyHandle.toInt(),
    namePointer,
    metadataPointer,
    tagsJsonPointer,
    expiryMs,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

Future<AskarCallbackResult> askarSessionRemoveAll(
  SessionHandle handle,
  String category,
  Map tagFilter,
) {
  final categoryPointer = category.toNativeUtf8();
  final tagFilterPointer = jsonEncode(tagFilter).toNativeUtf8();

  void cleanup() {
    calloc.free(categoryPointer);
    calloc.free(tagFilterPointer);
  }

  final callback = newCallbackWithInt64(cleanup);

  final result = nativeAskarSessionRemoveAll(
    handle.toInt(),
    categoryPointer,
    tagFilterPointer,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

Future<AskarCallbackResult> askarSessionRemoveKey(
  SessionHandle handle,
  String name,
) async {
  final namePointer = name.toNativeUtf8();

  void cleanup() {
    calloc.free(namePointer);
  }

  final callback = newCallbackWithoutHandle(cleanup);

  final result = nativeAskarSessionRemoveKey(
    handle.toInt(),
    namePointer,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return await callback.handleResult(result);
}

Future<AskarResult<SessionHandle>> askarSessionStart(
    StoreHandle handle, String profile, bool asTransaction) async {
  final profilePointer = profile.toNativeUtf8();

  void cleanup() {
    calloc.free(profilePointer);
  }

  final callback = newCallbackWithHandle(cleanup);

  final initialResult = nativeAskarSessionStart(
    handle.toInt(),
    profilePointer,
    boolToInt(asTransaction),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  final completedResult = await callback.handleResult(initialResult);

  return AskarResult(completedResult.errorCode, SessionHandle(completedResult.value));
}

Future<AskarCallbackResult> askarSessionUpdate(
  SessionHandle handle,
  EntryOperation operation,
  String category,
  String name,
  String value,
  Map<String, String> tags,
  int expiryMs,
) {
  String jsonString = jsonEncode(tags);

  final categoryPointer = category.toNativeUtf8();
  final namePointer = name.toNativeUtf8();
  final tagsPointer = jsonString.toNativeUtf8();
  final byteBufferPointer = stringToByteBuffer(value);

  // Uso da variável byteBuffer
  NativeByteBuffer byteBuffer = byteBufferPointer.ref;

  void cleanup() {
    calloc.free(categoryPointer);
    calloc.free(namePointer);
    calloc.free(byteBufferPointer.ref.data);
    calloc.free(byteBufferPointer);
    calloc.free(tagsPointer);
  }

  final callback = newCallbackWithoutHandle(cleanup);

  final result = nativeAskarSessionUpdate(
    handle.toInt(),
    operation.value,
    categoryPointer,
    namePointer,
    byteBuffer,
    tagsPointer,
    expiryMs,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

Future<AskarCallbackResult> askarSessionUpdateKey(
  SessionHandle handle,
  String name,
  String metadata,
  String tags,
  int expiryMs,
) {
  final namePointer = name.toNativeUtf8();
  final metadataPointer = metadata.toNativeUtf8();
  final tagsPointer = tags.toNativeUtf8();

  void cleanup() {
    calloc.free(metadataPointer);
    calloc.free(namePointer);
    calloc.free(tagsPointer);
  }

  final callback = newCallbackWithoutHandle(cleanup);

  final result = nativeAskarSessionUpdateKey(
    handle.toInt(),
    namePointer,
    metadataPointer,
    tagsPointer,
    expiryMs,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

Future<AskarCallbackResult> askarStoreClose(StoreHandle handle) {
  final callback = newCallbackWithoutHandle(() => {});

  final result = nativeAskarStoreClose(
      handle.toInt(), callback.nativeCallable.nativeFunction, callback.id);

  return callback.handleResult(result);
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
  final targetUriPointer = targetUri.toNativeUtf8();
  final keyMethodPointer = keyMethod.toNativeUtf8();
  final passKeyPointer = passKey.toNativeUtf8();

  final result = nativeAskarStoreCopy(
    handle.toInt(),
    targetUriPointer,
    keyMethodPointer,
    passKeyPointer,
    recreate,
    cb,
    cbId,
  );

  calloc.free(targetUriPointer);
  calloc.free(keyMethodPointer);
  calloc.free(passKeyPointer);

  return ErrorCode.fromInt(result);
}

Future<AskarCallbackResult> askarStoreCreateProfile(
  StoreHandle handle,
  String profile,
) async {
  final profilePointer = profile.toNativeUtf8();

  void cleanup() {
    calloc.free(profilePointer);
  }

  final callback = newCallbackWithPtrUtf8(cleanup);

  final result = nativeAskarStoreCreateProfile(
    handle.toInt(),
    profilePointer,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return await callback.handleResult(result);
}

AskarResult<String> askarStoreGenerateRawKey({Uint8List? seed}) {
  // Generate a random seed if not provided
  seed ??= generateRandomSeed();

  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final byteBufferPointer = bytesListToByteBuffer(seed);

  final funcResult = nativeAskarStoreGenerateRawKey(byteBufferPointer.ref, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);
  calloc.free(byteBufferPointer.ref.data);
  calloc.free(byteBufferPointer);

  return AskarResult<String>(errorCode, value);
}

Future<AskarCallbackResult> askarStoreGetDefaultProfile(
  StoreHandle handle,
) async {
  final callback = newCallbackWithPtrUtf8(() => {});

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
  final callback = newCallbackWithPtrUtf8(() => {});

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
  final profilePointer = profile.toNativeUtf8();

  void cleanup() {
    calloc.free(profilePointer);
  }

  final callback = newCallbackWithoutHandle(cleanup);

  final result = nativeAskarStoreSetDefaultProfile(
    handle.toInt(),
    profilePointer,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return await callback.handleResult(result);
}

Future<AskarResult<StringListHandle>> askarStoreListProfiles(
  StoreHandle handle,
) async {
  final callback = newCallbackWithHandle(() {});

  final initialResult = nativeAskarStoreListProfiles(
      handle.toInt(), callback.nativeCallable.nativeFunction, callback.id);

  final completedResult = await callback.handleResult(initialResult);

  return AskarResult(completedResult.errorCode, completedResult.value);
}

Future<AskarResult<StoreHandle>> askarStoreOpen(
  String specUri,
  StoreKeyMethod keyMethod,
  String passKey,
  String profile,
) async {
  final specUriPointer = specUri.toNativeUtf8();
  final keyMethodPointer = keyMethod.value.toNativeUtf8();
  final passKeyPointer = passKey.toNativeUtf8();
  final profilePointer = profile.toNativeUtf8();

  void cleanup() {
    calloc.free(specUriPointer);
    calloc.free(keyMethodPointer);
    calloc.free(passKeyPointer);
    calloc.free(profilePointer);
  }

  final callback = newCallbackWithHandle(cleanup);

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
}

Future<AskarResult<LocalKeyHandle>> askarStoreProvision(
  String specUri,
  StoreKeyMethod keyMethod,
  String passKey,
  String profile,
  bool recreate,
) async {
  final specUriPointer = specUri.toNativeUtf8();
  final keyMethodPointer = keyMethod.value.toNativeUtf8();
  final passKeyPointer = passKey.toNativeUtf8();
  final profilePointer = profile.toNativeUtf8();

  void cleanup() {
    calloc.free(specUriPointer);
    calloc.free(keyMethodPointer);
    calloc.free(passKeyPointer);
    calloc.free(profilePointer);
  }

  final callback = newCallbackWithHandle(cleanup);

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

  return AskarResult(completedResult.errorCode, LocalKeyHandle(completedResult.value));
}

Future<AskarCallbackResult> askarStoreRekey(
  StoreHandle handle,
  StoreKeyMethod keyMethod,
  String passKey,
) {
  final keyMethodPointer = keyMethod.value.toNativeUtf8();
  final passKeyPointer = passKey.toNativeUtf8();

  void cleanup() {
    calloc.free(keyMethodPointer);
    calloc.free(passKeyPointer);
  }

  final callback = newCallbackWithoutHandle(cleanup);

  final result = nativeAskarStoreRekey(
    handle.toInt(),
    keyMethodPointer,
    passKeyPointer,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

ErrorCode askarStoreRemove(
  String specUri,
  Pointer<NativeFunction<AskarStoreRemoveCallback>> cb,
  int cbId,
) {
  final specUriPointer = specUri.toNativeUtf8();

  final result = nativeAskarStoreRemove(
    specUriPointer,
    cb,
    cbId,
  );

  calloc.free(specUriPointer);

  return ErrorCode.fromInt(result);
}

ErrorCode askarStoreRemoveProfile(
  StoreHandle handle,
  String profile,
  Pointer<NativeFunction<AskarStoreRemoveProfileCallback>> cb,
  int cbId,
) {
  final profilePointer = profile.toNativeUtf8();

  final result = nativeAskarStoreRemoveProfile(
    handle.toInt(),
    profilePointer,
    cb,
    cbId,
  );

  calloc.free(profilePointer);

  return ErrorCode.fromInt(result);
}

ErrorCode askarMigrateIndySdk(
  String specUri,
  String walletName,
  String walletKey,
  String kdfLevel,
  Pointer<NativeFunction<AskarMigrateIndySdkCallback>> cb,
  int cbId,
) {
  final specUriPointer = specUri.toNativeUtf8();
  final walletNamePointer = walletName.toNativeUtf8();
  final walletKeyPointer = walletKey.toNativeUtf8();
  final kdfLevelPointer = kdfLevel.toNativeUtf8();

  final result = nativeAskarMigrateIndySdk(
    specUriPointer,
    walletNamePointer,
    walletKeyPointer,
    kdfLevelPointer,
    cb,
    cbId,
  );

  calloc.free(specUriPointer);
  calloc.free(walletNamePointer);
  calloc.free(walletKeyPointer);
  calloc.free(kdfLevelPointer);

  return ErrorCode.fromInt(result);
}
