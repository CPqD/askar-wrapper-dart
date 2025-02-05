import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:import_so_libaskar/askar/askar_callbacks.dart';
import 'package:import_so_libaskar/askar/enums/askar_entry_operation.dart';
import 'package:import_so_libaskar/askar/enums/askar_error_code.dart';
import 'package:import_so_libaskar/askar/enums/askar_key_algorithm.dart';
import 'package:import_so_libaskar/askar/enums/askar_key_backend.dart';
import 'package:import_so_libaskar/askar/enums/askar_signature_algorithm.dart';
import 'package:import_so_libaskar/askar/enums/askar_store_key_method.dart';

import 'askar_native_functions.dart';
import 'askar_utils.dart';

final class AskarResult<T> {
  final ErrorCode errorCode;
  final T value;

  AskarResult(this.errorCode, this.value);
}

typedef LocalKeyHandle = int;
typedef ScanHandle = int;
typedef StoreHandle = int;
typedef SessionHandle = int;
typedef EntryListHandle = int;
typedef KeyEntryListHandle = int;
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

void askarBufferFree(Pointer<SecretBuffer> buffer) {
  nativeAskarBufferFree(buffer);
}

void askarClearCustomLogger() {
  nativeAskarClearCustomLogger();
}

ErrorCode askarSetCustomLogger(
  Pointer<Void> context,
  Pointer<NativeFunction<LogCallback>> log,
  Pointer<OptionEnabledCallbackStruct> enabled,
  Pointer<OptionFlushCallbackStruct> flush,
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

  final funcResult = nativeAskarEntryListCount(handle, countPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  int count = countPointer.value;

  calloc.free(countPointer);

  return AskarResult<int>(errorCode, count);
}

void askarEntryListFree(EntryListHandle handle) {
  nativeAskarEntryListFree(handle);
}

AskarResult<String> askarEntryListGetCategory(EntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult = nativeAskarEntryListGetCategory(handle, index, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<String> askarEntryListGetName(EntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult = nativeAskarEntryListGetName(handle, index, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<Map> askarEntryListGetTags(EntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PointerPointer = calloc<Pointer<Utf8>>();

  final funcResult = nativeAskarEntryListGetTags(handle, index, utf8PointerPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  Map value = {};

  if (errorCode == ErrorCode.success) {
    String mapString = utf8PointerPointer.value.toDartString();
    value = jsonDecode(mapString);
  }

  calloc.free(utf8PointerPointer.value);
  calloc.free(utf8PointerPointer);

  return AskarResult<Map>(errorCode, value);
}

AskarResult<String> askarEntryListGetValue(EntryListHandle handle, int index) {
  Pointer<SecretBuffer> secretBufferPointer = calloc<SecretBuffer>();

  final funcResult = nativeAskarEntryListGetValue(handle, index, secretBufferPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value = (errorCode == ErrorCode.success)
      ? secretBufferToString(secretBufferPointer.ref)
      : "";

  calloc.free(secretBufferPointer.ref.data);
  calloc.free(secretBufferPointer);

  return AskarResult<String>(errorCode, value);
}

ErrorCode askarStringListCount(StringListHandle handle, int count) {
  final countPointer = calloc<Int32>();
  countPointer.value = count;

  final result = nativeAskarStringListCount(handle, countPointer);

  final errorCode = ErrorCode.fromInt(result);
  count = countPointer.value;

  calloc.free(countPointer);

  return errorCode;
}

void askarStringListFree(StringListHandle handle) {
  nativeAskarStringListFree(handle);
}

ErrorCode askarStringListGetItem(
    StringListHandle handle, int index, Pointer<Pointer<Utf8>> item) {
  final result = nativeAskarStringListGetItem(handle, index, item);
  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyAeadDecrypt(
  LocalKeyHandle handle,
  Pointer<ByteBuffer> ciphertext,
  Pointer<ByteBuffer> nonce,
  Pointer<ByteBuffer> tag,
  Pointer<ByteBuffer> aad,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyAeadDecrypt(
    handle,
    ciphertext,
    nonce,
    tag,
    aad,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyAeadEncrypt(
  LocalKeyHandle handle,
  Pointer<ByteBuffer> message,
  Pointer<ByteBuffer> nonce,
  Pointer<ByteBuffer> aad,
  Pointer<EncryptedBuffer> out,
) {
  final result = nativeAskarKeyAeadEncrypt(
    handle,
    message,
    nonce,
    aad,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyAeadGetPadding(
  LocalKeyHandle handle,
  int msgLen,
  Pointer<Int32> out,
) {
  final result = nativeAskarKeyAeadGetPadding(
    handle,
    msgLen,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyAeadGetParams(
  LocalKeyHandle handle,
  Pointer<AeadParams> out,
) {
  final result = nativeAskarKeyAeadGetParams(
    handle,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyAeadRandomNonce(
  LocalKeyHandle handle,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyAeadRandomNonce(
    handle,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyConvert(
  LocalKeyHandle handle,
  String alg,
  Pointer<NativeLocalKeyHandle> out,
) {
  final algPointer = alg.toNativeUtf8();

  final result = nativeAskarKeyConvert(
    handle,
    algPointer,
    out,
  );

  calloc.free(algPointer);

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyCryptoBox(
  LocalKeyHandle recipKey,
  LocalKeyHandle senderKey,
  Pointer<ByteBuffer> message,
  Pointer<ByteBuffer> nonce,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyCryptoBox(
    recipKey,
    senderKey,
    message,
    nonce,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyCryptoBoxOpen(
  LocalKeyHandle recipKey,
  LocalKeyHandle senderKey,
  Pointer<ByteBuffer> message,
  Pointer<ByteBuffer> nonce,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyCryptoBoxOpen(
    recipKey,
    senderKey,
    message,
    nonce,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyCryptoBoxRandomNonce(
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyCryptoBoxRandomNonce(
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyCryptoBoxSeal(
  LocalKeyHandle handle,
  Pointer<ByteBuffer> message,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyCryptoBoxSeal(
    handle,
    message,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyCryptoBoxSealOpen(
  LocalKeyHandle handle,
  Pointer<ByteBuffer> ciphertext,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyCryptoBoxSealOpen(
    handle,
    ciphertext,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyDeriveEcdh1pu(
  String alg,
  LocalKeyHandle ephemKey,
  LocalKeyHandle senderKey,
  LocalKeyHandle recipKey,
  Pointer<ByteBuffer> algId,
  Pointer<ByteBuffer> apu,
  Pointer<ByteBuffer> apv,
  Pointer<ByteBuffer> ccTag,
  int receive,
  Pointer<NativeLocalKeyHandle> out,
) {
  final algPointer = alg.toNativeUtf8();

  final result = nativeAskarKeyDeriveEcdh1pu(
    algPointer,
    ephemKey,
    senderKey,
    recipKey,
    algId,
    apu,
    apv,
    ccTag,
    receive,
    out,
  );

  calloc.free(algPointer);

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyDeriveEcdhEs(
  String alg,
  LocalKeyHandle ephemKey,
  LocalKeyHandle recipKey,
  Pointer<ByteBuffer> algId,
  Pointer<ByteBuffer> apu,
  Pointer<ByteBuffer> apv,
  int receive,
  Pointer<NativeLocalKeyHandle> out,
) {
  final algPointer = alg.toNativeUtf8();

  final result = nativeAskarKeyDeriveEcdhEs(
    algPointer,
    ephemKey,
    recipKey,
    algId,
    apu,
    apv,
    receive,
    out,
  );

  calloc.free(algPointer);

  return ErrorCode.fromInt(result);
}

AskarResult<int> askarKeyEntryListCount(KeyEntryListHandle handle) {
  Pointer<Int32> countPointer = calloc<Int32>();

  final funcResult = nativeAskarKeyEntryListCount(handle, countPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  int count = countPointer.value;

  calloc.free(countPointer);

  return AskarResult<int>(errorCode, count);
}

void askarKeyEntryListFree(KeyEntryListHandle handle) {
  nativeAskarKeyEntryListFree(handle);
}

AskarResult<String> askarKeyEntryListGetAlgorithm(KeyEntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();
  final result = nativeAskarKeyEntryListGetAlgorithm(handle, index, utf8PtPointer);
  final errorCode = ErrorCode.fromInt(result);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<String> askarKeyEntryListGetMetadata(KeyEntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult = nativeAskarKeyEntryListGetMetadata(handle, index, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<String> askarKeyEntryListGetName(KeyEntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final result = nativeAskarKeyEntryListGetName(handle, index, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(result);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<Map> askarKeyEntryListGetTags(KeyEntryListHandle handle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();
  final result = nativeAskarKeyEntryListGetTags(handle, index, utf8PtPointer);
  final errorCode = ErrorCode.fromInt(result);

  Map value = {};

  if (errorCode == ErrorCode.success) {
    String mapString = utf8PtPointer.value.toDartString();
    value = jsonDecode(mapString);
  }
  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<Map>(errorCode, value);
}

AskarResult<int> askarKeyEntryListLoadLocal(int keyEntryListHandle, int index) {
  Pointer<IntPtr> outPtr = calloc<IntPtr>();

  final funcResult = nativeAskarKeyEntryListLoadLocal(keyEntryListHandle, index, outPtr);

  final errorCode = ErrorCode.fromInt(funcResult);

  final out = outPtr.value;

  calloc.free(outPtr);

  return AskarResult<int>(errorCode, out);
}

void askarKeyFree(LocalKeyHandle handle) {
  nativeAskarKeyFree(handle);
}

ErrorCode askarKeyFromJwk(Pointer<ByteBuffer> jwk, Pointer<NativeLocalKeyHandle> out) {
  final result = nativeAskarKeyFromJwk(jwk, out);
  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyFromKeyExchange(
  String alg,
  LocalKeyHandle skHandle,
  LocalKeyHandle pkHandle,
  Pointer<NativeLocalKeyHandle> out,
) {
  final algPointer = alg.toNativeUtf8();

  final result = nativeAskarKeyFromKeyExchange(
    algPointer,
    skHandle,
    pkHandle,
    out,
  );

  calloc.free(algPointer);

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyFromPublicBytes(
  String alg,
  Pointer<ByteBuffer> public_,
  Pointer<NativeLocalKeyHandle> out,
) {
  final algPointer = alg.toNativeUtf8();

  final result = nativeAskarKeyFromPublicBytes(
    algPointer,
    public_,
    out,
  );

  calloc.free(algPointer);

  return ErrorCode.fromInt(result);
}

AskarResult<LocalKeyHandle> askarKeyFromSecretBytes(
  KeyAlgorithm algorithm,
  Uint8List secret,
) {
  Pointer<IntPtr> localKeyHandlePtr = calloc<IntPtr>();

  final algPointer = algorithm.value.toNativeUtf8();
  final byteBufferPointer = bytesListToByteBuffer(secret);

  final funcResult = nativeAskarKeyFromSecretBytes(
    algPointer,
    byteBufferPointer.ref,
    localKeyHandlePtr,
  );

  final errorCode = ErrorCode.fromInt(funcResult);

  final localKeyHandle = localKeyHandlePtr.value;

  calloc.free(byteBufferPointer.ref.data);
  calloc.free(byteBufferPointer);
  calloc.free(localKeyHandlePtr);

  return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
}

ErrorCode askarKeyFromSeed(
  String alg,
  Pointer<ByteBuffer> seed,
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
  Pointer<Int64> localKeyHandlePointer = calloc<Int64>();

  final algPointer = alg.value.toNativeUtf8();
  final keyBackendPointer = keyBackend.value.toNativeUtf8();

  final funcResult = nativeAskarKeyGenerate(
      algPointer, keyBackendPointer, boolToInt(ephemeral), localKeyHandlePointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final int localKeyHandle =
      (errorCode == ErrorCode.success) ? localKeyHandlePointer.value.toInt() : -1;

  calloc.free(algPointer);
  calloc.free(keyBackendPointer);
  calloc.free(localKeyHandlePointer);

  return AskarResult<LocalKeyHandle>(errorCode, localKeyHandle);
}

AskarResult<String> askarKeyGetAlgorithm(LocalKeyHandle handle) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult = nativeAskarKeyGetAlgorithm(handle, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

ErrorCode askarKeyGetEphemeral(LocalKeyHandle handle, Pointer<Int8> out) {
  final result = nativeAskarKeyGetEphemeral(handle, out);
  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyGetJwkPublic(
  LocalKeyHandle handle,
  String alg,
  Pointer<Pointer<Utf8>> out,
) {
  final algPointer = alg.toNativeUtf8();

  final result = nativeAskarKeyGetJwkPublic(
    handle,
    algPointer,
    out,
  );

  calloc.free(algPointer);

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyGetJwkSecret(
  LocalKeyHandle handle,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyGetJwkSecret(
    handle,
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
    handle,
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

ErrorCode askarKeyGetPublicBytes(
  LocalKeyHandle handle,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyGetPublicBytes(
    handle,
    out,
  );

  return ErrorCode.fromInt(result);
}

AskarResult<Uint8List> askarKeyGetSecretBytes(LocalKeyHandle handle) {
  Pointer<SecretBuffer> secretBufferPtr = calloc<SecretBuffer>();

  final funcResult = nativeAskarKeyGetSecretBytes(
    handle,
    secretBufferPtr,
  );

  final errorCode = ErrorCode.fromInt(funcResult);

  final value = Uint8List.fromList(secretBufferToBytesList(secretBufferPtr.ref));

  calloc.free(secretBufferPtr.ref.data);
  calloc.free(secretBufferPtr);

  return AskarResult<Uint8List>(errorCode, value);
}

AskarResult<Uint8List> askarKeySignMessage(
  LocalKeyHandle handle,
  Uint8List message,
  SignatureAlgorithm sigType,
) {
  Pointer<SecretBuffer> secretBufferPointer = calloc<SecretBuffer>();

  final sigTypePointer = sigType.value.toNativeUtf8();
  final byteBufferPointer = bytesListToByteBuffer(message);

  ByteBuffer byteBuffer = byteBufferPointer.ref;

  final funcResult = nativeAskarKeySignMessage(
    handle,
    byteBuffer,
    sigTypePointer,
    secretBufferPointer,
  );

  final errorCode = ErrorCode.fromInt(funcResult);

  final value = Uint8List.fromList(secretBufferToBytesList(secretBufferPointer.ref));

  calloc.free(sigTypePointer);
  calloc.free(byteBufferPointer.ref.data);
  calloc.free(byteBufferPointer);
  calloc.free(secretBufferPointer.ref.data);
  calloc.free(secretBufferPointer);

  return AskarResult<Uint8List>(errorCode, value);
}

ErrorCode askarKeyUnwrapKey(
  LocalKeyHandle handle,
  String alg,
  Pointer<ByteBuffer> ciphertext,
  Pointer<ByteBuffer> nonce,
  Pointer<ByteBuffer> tag,
  Pointer<NativeLocalKeyHandle> out,
) {
  final algPointer = alg.toNativeUtf8();

  final result = nativeAskarKeyUnwrapKey(
    handle,
    algPointer,
    ciphertext,
    nonce,
    tag,
    out,
  );

  calloc.free(algPointer);

  return ErrorCode.fromInt(result);
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
    handle,
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

ErrorCode askarKeyWrapKey(
  LocalKeyHandle handle,
  LocalKeyHandle other,
  Pointer<ByteBuffer> nonce,
  Pointer<EncryptedBuffer> out,
) {
  final result = nativeAskarKeyWrapKey(
    handle,
    other,
    nonce,
    out,
  );

  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyGetSupportedBackends(Pointer<NativeStringListHandle> out) {
  final result = nativeAskarKeyGetSupportedBackends(out);
  return ErrorCode.fromInt(result);
}

ErrorCode askarScanFree(ScanHandle handle) {
  final result = nativeAskarScanFree(handle);
  return ErrorCode.fromInt(result);
}

Future<AskarCallbackResult> askarScanNext(
  ScanHandle handle,
) async {
  final callback = newCallbackWithHandle(() => {});

  final result =
      nativeAskarScanNext(handle, callback.nativeCallable.nativeFunction, callback.id);

  return await callback.handleResult(result);
}

Future<AskarCallbackResult> askarScanStart(
  ScanHandle handle,
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

  final result = nativeAskarScanStart(
    handle,
    profilePointer,
    categoryPointer,
    tagFilterPointer,
    offset,
    limit,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return await callback.handleResult(result);
}

Future<AskarCallbackBlankResult> askarSessionClose(
  SessionHandle handle,
  bool commit,
) async {
  final callback = newCallbackWithoutHandle(() => {});

  final result = nativeAskarSessionClose(
      handle, boolToInt(commit), callback.nativeCallable.nativeFunction, callback.id);

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
    handle,
    categoryPointer,
    tagFilterPointer,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

Future<AskarCallbackResult> askarSessionFetch(
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

  final result = nativeAskarSessionFetch(
    handle,
    categoryPointer,
    namePointer,
    boolToInt(forUpdate),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  final callbackResult = await callback.handleResult(result);

  if (callbackResult.errorCode == ErrorCode.success && callbackResult.value == 0) {
    throw Exception(
        "Invalid handle. This means that the function call succeeded but none was found.");
  }

  return callbackResult;
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
    handle,
    categoryPtr,
    tagFilterPtr,
    limit,
    boolToInt(forUpdate),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  final callbackResult = await callback.handleResult(result);

  return AskarResult<EntryListHandle>(callbackResult.errorCode, callbackResult.value);
}

Future<AskarCallbackResult> askarSessionFetchAllKeys(
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

  final result = nativeAskarSessionFetchAllKeys(
    handle,
    algPointer,
    thumbprintPointer,
    tagFilterPointer,
    limit,
    boolToInt(forUpdate),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return await callback.handleResult(result);
}

Future<AskarCallbackResult> askarSessionFetchKey(
    SessionHandle handle, String name, bool forUpdate) async {
  final namePointer = name.toNativeUtf8();

  void cleanup() {
    calloc.free(namePointer);
  }

  final callback = newCallbackWithHandle(cleanup);

  final result = nativeAskarSessionFetchKey(
    handle,
    namePointer,
    boolToInt(forUpdate),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return await callback.handleResult(result);
}

Future<AskarCallbackResult> askarSessionInsertKey(SessionHandle handle,
    int localKeyHandle, String name, String metadata, Map tags, int expiryMs) {
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
    handle,
    localKeyHandle,
    namePointer,
    metadataPointer,
    tagsJsonPointer,
    expiryMs,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

ErrorCode askarSessionRemoveAll(
  SessionHandle handle,
  String category,
  String tagFilter,
  Pointer<NativeFunction<AskarSessionRemoveAllCallback>> cb,
  int cbId,
) {
  final categoryPointer = category.toNativeUtf8();
  final tagFilterPointer = tagFilter.toNativeUtf8();

  final result = nativeAskarSessionRemoveAll(
    handle,
    categoryPointer,
    tagFilterPointer,
    cb,
    cbId,
  );

  calloc.free(categoryPointer);
  calloc.free(tagFilterPointer);

  return ErrorCode.fromInt(result);
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
    handle,
    namePointer,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return await callback.handleResult(result);
}

Future<AskarCallbackResult> askarSessionStart(
    StoreHandle handle, String profile, bool asTransaction) {
  final profilePointer = profile.toNativeUtf8();

  void cleanup() {
    calloc.free(profilePointer);
  }

  final callback = newCallbackWithHandle(cleanup);

  final result = nativeAskarSessionStart(
    handle,
    profilePointer,
    boolToInt(asTransaction),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
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
  ByteBuffer byteBuffer = byteBufferPointer.ref;

  void cleanup() {
    calloc.free(categoryPointer);
    calloc.free(namePointer);
    calloc.free(byteBufferPointer.ref.data);
    calloc.free(byteBufferPointer);
    calloc.free(tagsPointer);
  }

  final callback = newCallbackWithoutHandle(cleanup);

  final result = nativeAskarSessionUpdate(
    handle,
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
    handle,
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

  final result =
      nativeAskarStoreClose(handle, callback.nativeCallable.nativeFunction, callback.id);

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
    handle,
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
    handle,
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
  void cleanup() {}

  final callback = newCallbackWithPtrUtf8(cleanup);

  final result = nativeAskarStoreGetDefaultProfile(
    handle,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return await callback.handleResult(result);
}

ErrorCode askarStoreListProfiles(
  StoreHandle handle,
  Pointer<NativeFunction<AskarStoreListProfilesCallback>> cb,
  int cbId,
) {
  final result = nativeAskarStoreListProfiles(handle, cb, cbId);
  return ErrorCode.fromInt(result);
}

Future<AskarCallbackResult> askarStoreOpen(
  String specUri,
  StoreKeyMethod keyMethod,
  String passKey,
  String profile,
) {
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

  final result = nativeAskarStoreOpen(
    specUriPointer,
    keyMethodPointer,
    passKeyPointer,
    profilePointer,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

Future<AskarCallbackResult> askarStoreProvision(
  String specUri,
  StoreKeyMethod keyMethod,
  String passKey,
  String profile,
  bool recreate,
) {
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

  final result = nativeAskarStoreProvision(
    specUriPointer,
    keyMethodPointer,
    passKeyPointer,
    profilePointer,
    boolToInt(recreate),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

ErrorCode askarStoreRekey(
  StoreHandle handle,
  String keyMethod,
  String passKey,
  Pointer<NativeFunction<AskarStoreRekeyCallback>> cb,
  int cbId,
) {
  final keyMethodPointer = keyMethod.toNativeUtf8();
  final passKeyPointer = passKey.toNativeUtf8();

  final result = nativeAskarStoreRekey(
    handle,
    keyMethodPointer,
    passKeyPointer,
    cb,
    cbId,
  );

  calloc.free(keyMethodPointer);
  calloc.free(passKeyPointer);

  return ErrorCode.fromInt(result);
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
    handle,
    profilePointer,
    cb,
    cbId,
  );

  calloc.free(profilePointer);

  return ErrorCode.fromInt(result);
}

ErrorCode askarStoreSetDefaultProfile(
  StoreHandle handle,
  String profile,
  Pointer<NativeFunction<AskarStoreSetDefaultProfileCallback>> cb,
  int cbId,
) {
  final profilePointer = profile.toNativeUtf8();

  final result = nativeAskarStoreSetDefaultProfile(
    handle,
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
