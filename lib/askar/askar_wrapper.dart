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

AskarResult<int> askarEntryListCount(int entryListHandle) {
  Pointer<Int32> countPointer = calloc<Int32>();

  final funcResult = nativeAskarEntryListCount(entryListHandle, countPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  int count = countPointer.value;

  calloc.free(countPointer);

  return AskarResult<int>(errorCode, count);
}

void askarEntryListFree(int entryListHandle) {
  nativeAskarEntryListFree(entryListHandle);
}

AskarResult<String> askarEntryListGetCategory(int entryListHandle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult =
      nativeAskarEntryListGetCategory(entryListHandle, index, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<String> askarEntryListGetName(int entryListHandle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult = nativeAskarEntryListGetName(entryListHandle, index, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<Map> askarEntryListGetTags(int entryListHandle, int index) {
  Pointer<Pointer<Utf8>> utf8PointerPointer = calloc<Pointer<Utf8>>();

  final funcResult =
      nativeAskarEntryListGetTags(entryListHandle, index, utf8PointerPointer);

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

AskarResult<String> askarEntryListGetValue(int entryListHandle, int index) {
  Pointer<SecretBuffer> secretBufferPointer = calloc<SecretBuffer>();

  final funcResult =
      nativeAskarEntryListGetValue(entryListHandle, index, secretBufferPointer);

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
  Pointer<LocalKeyHandle> out,
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
  Pointer<LocalKeyHandle> out,
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
  Pointer<LocalKeyHandle> out,
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

AskarResult<int> askarKeyEntryListCount(int keyEntryListHandle) {
  Pointer<Int32> countPointer = calloc<Int32>();

  final funcResult = nativeAskarKeyEntryListCount(keyEntryListHandle, countPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  int count = countPointer.value;

  calloc.free(countPointer);

  return AskarResult<int>(errorCode, count);
}

void askarKeyEntryListFree(int keyEntryListHandle) {
  nativeAskarKeyEntryListFree(keyEntryListHandle);
}

AskarResult<String> askarKeyEntryListGetAlgorithm(int keyEntryListHandle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();
  final result =
      nativeAskarKeyEntryListGetAlgorithm(keyEntryListHandle, index, utf8PtPointer);
  final errorCode = ErrorCode.fromInt(result);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<String> askarKeyEntryListGetMetadata(int keyEntryListHandle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult =
      nativeAskarKeyEntryListGetMetadata(keyEntryListHandle, index, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(funcResult);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<String> askarKeyEntryListGetName(int keyEntryListHandle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final result = nativeAskarKeyEntryListGetName(keyEntryListHandle, index, utf8PtPointer);

  final errorCode = ErrorCode.fromInt(result);

  final String value =
      (errorCode == ErrorCode.success) ? utf8PtPointer.value.toDartString() : "";

  calloc.free(utf8PtPointer.value);
  calloc.free(utf8PtPointer);

  return AskarResult<String>(errorCode, value);
}

AskarResult<Map> askarKeyEntryListGetTags(int keyEntryListHandle, int index) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();
  final result = nativeAskarKeyEntryListGetTags(keyEntryListHandle, index, utf8PtPointer);
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

void askarKeyFree(int localKeyHandle) {
  nativeAskarKeyFree(localKeyHandle);
}

ErrorCode askarKeyFromJwk(Pointer<ByteBuffer> jwk, Pointer<LocalKeyHandle> out) {
  final result = nativeAskarKeyFromJwk(jwk, out);
  return ErrorCode.fromInt(result);
}

ErrorCode askarKeyFromKeyExchange(
  String alg,
  LocalKeyHandle skHandle,
  LocalKeyHandle pkHandle,
  Pointer<LocalKeyHandle> out,
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
  Pointer<LocalKeyHandle> out,
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

AskarResult<int> askarKeyFromSecretBytes(
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

  return AskarResult<int>(errorCode, localKeyHandle);
}

ErrorCode askarKeyFromSeed(
  String alg,
  Pointer<ByteBuffer> seed,
  String method,
  Pointer<LocalKeyHandle> out,
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

AskarResult<int> askarKeyGenerate(
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

  return AskarResult<int>(errorCode, localKeyHandle);
}

AskarResult<String> askarKeyGetAlgorithm(int localKeyHandle) {
  Pointer<Pointer<Utf8>> utf8PtPointer = calloc<Pointer<Utf8>>();

  final funcResult = nativeAskarKeyGetAlgorithm(localKeyHandle, utf8PtPointer);

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

ErrorCode askarKeyGetJwkThumbprint(
  LocalKeyHandle handle,
  String alg,
  Pointer<Pointer<Utf8>> out,
) {
  final algPointer = alg.toNativeUtf8();

  final result = nativeAskarKeyGetJwkThumbprint(
    handle,
    algPointer,
    out,
  );

  calloc.free(algPointer);

  return ErrorCode.fromInt(result);
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

ErrorCode askarKeyGetSecretBytes(
  LocalKeyHandle handle,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyGetSecretBytes(
    handle,
    out,
  );

  return ErrorCode.fromInt(result);
}

AskarResult<Uint8List> askarKeySignMessage(
  int localKeyHandle,
  Uint8List message,
  SignatureAlgorithm sigType,
) {
  Pointer<SecretBuffer> secretBufferPointer = calloc<SecretBuffer>();

  final sigTypePointer = sigType.value.toNativeUtf8();
  final byteBufferPointer = bytesListToByteBuffer(message);

  ByteBuffer byteBuffer = byteBufferPointer.ref;

  final funcResult = nativeAskarKeySignMessage(
    localKeyHandle,
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
  Pointer<LocalKeyHandle> out,
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
  int localKeyHandle,
  Uint8List message,
  Uint8List signature,
  SignatureAlgorithm sigType,
) {
  Pointer<Int8> intPointer = calloc<Int8>();

  final sigTypePointer = sigType.value.toNativeUtf8();

  final messageAsByteBufferPt = bytesListToByteBuffer(message);
  final signatureAsByteBufferPt = bytesListToByteBuffer(signature);

  final funcResult = nativeAskarKeyVerifySignature(
    localKeyHandle,
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

ErrorCode askarKeyGetSupportedBackends(Pointer<StringListHandle> out) {
  final result = nativeAskarKeyGetSupportedBackends(out);
  return ErrorCode.fromInt(result);
}

ErrorCode askarScanFree(int scanHandle) {
  final result = nativeAskarScanFree(scanHandle);
  return ErrorCode.fromInt(result);
}

ErrorCode askarScanNext(
  int scanHandle,
  Pointer<NativeFunction<AskarScanNextCallback>> cb,
  int cbId,
) {
  final result = nativeAskarScanNext(scanHandle, cb, cbId);
  return ErrorCode.fromInt(result);
}

ErrorCode askarScanStart(
  int scanHandle,
  String profile,
  String category,
  String tagFilter,
  int offset,
  int limit,
  Pointer<NativeFunction<AskarScanStartCallback>> cb,
  int cbId,
) {
  final profilePointer = profile.toNativeUtf8();
  final categoryPointer = category.toNativeUtf8();
  final tagFilterPointer = tagFilter.toNativeUtf8();

  final result = nativeAskarScanStart(
    scanHandle,
    profilePointer,
    categoryPointer,
    tagFilterPointer,
    offset,
    limit,
    cb,
    cbId,
  );

  calloc.free(profilePointer);
  calloc.free(categoryPointer);
  calloc.free(tagFilterPointer);

  return ErrorCode.fromInt(result);
}

Future<CallbackResult> askarSessionClose(
  int sessionHandle,
  bool commit,
) async {
  final callback = newCallbackWithoutHandle(() => {});

  final result = nativeAskarSessionClose(sessionHandle, boolToInt(commit),
      callback.nativeCallable.nativeFunction, callback.id);

  return await callback.handleResult(result);
}

Future<CallbackResult> askarSessionCount(
  int sessionHandle,
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
    sessionHandle,
    categoryPointer,
    tagFilterPointer,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

Future<CallbackResult> askarSessionFetch(
  int sessionHandle,
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
    sessionHandle,
    categoryPointer,
    namePointer,
    boolToInt(forUpdate),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  final callbackResult = await callback.handleResult(result);

  if (callbackResult.errorCode == ErrorCode.success && callbackResult.handle == 0) {
    throw Exception(
        "Invalid handle. This means that the function call succeeded but none was found.");
  }

  return callbackResult;
}

ErrorCode askarSessionFetchAll(
  int sessionHandle,
  String category,
  String tagFilter,
  int limit,
  int forUpdate,
  Pointer<NativeFunction<AskarSessionFetchAllCallback>> cb,
  int cbId,
) {
  final categoryPointer = category.toNativeUtf8();
  final tagFilterPointer = tagFilter.toNativeUtf8();

  final result = nativeAskarSessionFetchAll(
    sessionHandle,
    categoryPointer,
    tagFilterPointer,
    limit,
    forUpdate,
    cb,
    cbId,
  );

  calloc.free(categoryPointer);
  calloc.free(tagFilterPointer);

  return ErrorCode.fromInt(result);
}

ErrorCode askarSessionFetchAllKeys(
  int sessionHandle,
  String alg,
  String thumbprint,
  String tagFilter,
  int limit,
  int forUpdate,
  Pointer<NativeFunction<AskarSessionFetchAllKeysCallback>> cb,
  int cbId,
) {
  final algPointer = alg.toNativeUtf8();
  final thumbprintPointer = thumbprint.toNativeUtf8();
  final tagFilterPointer = tagFilter.toNativeUtf8();

  final result = nativeAskarSessionFetchAllKeys(
    sessionHandle,
    algPointer,
    thumbprintPointer,
    tagFilterPointer,
    limit,
    forUpdate,
    cb,
    cbId,
  );

  calloc.free(algPointer);
  calloc.free(thumbprintPointer);
  calloc.free(tagFilterPointer);

  return ErrorCode.fromInt(result);
}

Future<CallbackResult> askarSessionFetchKey(
    int sessionHandle, String name, bool forUpdate) async {
  final namePointer = name.toNativeUtf8();

  void cleanup() {
    calloc.free(namePointer);
  }

  final callback = newCallbackWithHandle(cleanup);

  final result = nativeAskarSessionFetchKey(
    sessionHandle,
    namePointer,
    boolToInt(forUpdate),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return await callback.handleResult(result);
}

Future<CallbackResult> askarSessionInsertKey(int sessionHandle, int localKeyHandle,
    String name, String metadata, Map tags, int expiryMs) {
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
    sessionHandle,
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
  int sessionHandle,
  String category,
  String tagFilter,
  Pointer<NativeFunction<AskarSessionRemoveAllCallback>> cb,
  int cbId,
) {
  final categoryPointer = category.toNativeUtf8();
  final tagFilterPointer = tagFilter.toNativeUtf8();

  final result = nativeAskarSessionRemoveAll(
    sessionHandle,
    categoryPointer,
    tagFilterPointer,
    cb,
    cbId,
  );

  calloc.free(categoryPointer);
  calloc.free(tagFilterPointer);

  return ErrorCode.fromInt(result);
}

Future<CallbackResult> askarSessionRemoveKey(
  int sessionHandle,
  String name,
) async {
  final namePointer = name.toNativeUtf8();

  void cleanup() {
    calloc.free(namePointer);
  }

  final callback = newCallbackWithoutHandle(cleanup);

  final result = nativeAskarSessionRemoveKey(
    sessionHandle,
    namePointer,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return await callback.handleResult(result);
}

Future<CallbackResult> askarSessionStart(
    int storeHandle, String profile, bool asTransaction) {
  final profilePointer = profile.toNativeUtf8();

  void cleanup() {
    calloc.free(profilePointer);
  }

  final callback = newCallbackWithHandle(cleanup);

  final result = nativeAskarSessionStart(
    storeHandle,
    profilePointer,
    boolToInt(asTransaction),
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

Future<CallbackResult> askarSessionUpdate(
  int sessionHandle,
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
    sessionHandle,
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

Future<CallbackResult> askarSessionUpdateKey(
  int sessionHandle,
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
    sessionHandle,
    namePointer,
    metadataPointer,
    tagsPointer,
    expiryMs,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

Future<CallbackResult> askarStoreClose(int storeHandle) {
  final callback = newCallbackWithoutHandle(() => {});

  final result = nativeAskarStoreClose(
      storeHandle, callback.nativeCallable.nativeFunction, callback.id);

  return callback.handleResult(result);
}

ErrorCode askarStoreCopy(
  int storeHandle,
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
    storeHandle,
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

Future<CallbackResult> askarStoreCreateProfile(
  int storeHandle,
  String profile,
) async {
  final profilePointer = profile.toNativeUtf8();

  void cleanup() {
    calloc.free(profilePointer);
  }

  final callback = newCallbackWithPtrUtf8(cleanup);

  final result = nativeAskarStoreCreateProfile(
    storeHandle,
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

ErrorCode askarStoreGetDefaultProfile(
  int storeHandle,
  Pointer<NativeFunction<AskarStoreGetDefaultProfileCallback>> cb,
  int cbId,
) {
  final result = nativeAskarStoreGetDefaultProfile(storeHandle, cb, cbId);
  return ErrorCode.fromInt(result);
}

ErrorCode askarStoreListProfiles(
  int storeHandle,
  Pointer<NativeFunction<AskarStoreListProfilesCallback>> cb,
  int cbId,
) {
  final result = nativeAskarStoreListProfiles(storeHandle, cb, cbId);
  return ErrorCode.fromInt(result);
}

Future<CallbackResult> askarStoreOpen(
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

Future<CallbackResult> askarStoreProvision(
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
  int storeHandle,
  String keyMethod,
  String passKey,
  Pointer<NativeFunction<AskarStoreRekeyCallback>> cb,
  int cbId,
) {
  final keyMethodPointer = keyMethod.toNativeUtf8();
  final passKeyPointer = passKey.toNativeUtf8();

  final result = nativeAskarStoreRekey(
    storeHandle,
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
  int storeHandle,
  String profile,
  Pointer<NativeFunction<AskarStoreRemoveProfileCallback>> cb,
  int cbId,
) {
  final profilePointer = profile.toNativeUtf8();

  final result = nativeAskarStoreRemoveProfile(
    storeHandle,
    profilePointer,
    cb,
    cbId,
  );

  calloc.free(profilePointer);

  return ErrorCode.fromInt(result);
}

ErrorCode askarStoreSetDefaultProfile(
  int storeHandle,
  String profile,
  Pointer<NativeFunction<AskarStoreSetDefaultProfileCallback>> cb,
  int cbId,
) {
  final profilePointer = profile.toNativeUtf8();

  final result = nativeAskarStoreSetDefaultProfile(
    storeHandle,
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
