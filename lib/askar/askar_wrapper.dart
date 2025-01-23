import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:import_so_libaskar/askar/askar_callbacks.dart';
import 'package:import_so_libaskar/askar/askar_error_code.dart';

import 'askar_native_functions.dart';

String askarVersion() {
  Pointer<Utf8> resultPointer = nativeAskarVersion();
  return resultPointer.toDartString();
}

ErrorCode askarGetCurrentError(Pointer<Pointer<Utf8>> errorJsonPointer) {
  final result = nativeAskarGetCurrentError(errorJsonPointer);
  return intToErrorCode(result);
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

  return intToErrorCode(result);
}

ErrorCode askarSetDefaultLogger() {
  final result = nativeAskarSetDefaultLogger();
  return intToErrorCode(result);
}

ErrorCode askarSetMaxLogLevel(int maxLevel) {
  final result = nativeAskarSetMaxLogLevel(maxLevel);
  return intToErrorCode(result);
}

ErrorCode askarEntryListCount(EntryListHandle handle, int count) {
  final countPointer = calloc<Int32>();
  countPointer.value = count;

  final result = nativeAskarEntryListCount(handle, countPointer);

  calloc.free(countPointer);

  return intToErrorCode(result);
}

void askarEntryListFree(EntryListHandle handle) {
  nativeAskarEntryListFree(handle);
}

ErrorCode askarEntryListGetCategory(
    EntryListHandle handle, int index, Pointer<Pointer<Utf8>> category) {
  final result = nativeAskarEntryListGetCategory(handle, index, category);
  return intToErrorCode(result);
}

ErrorCode askarEntryListGetName(
    EntryListHandle handle, int index, Pointer<Pointer<Utf8>> name) {
  final result = nativeAskarEntryListGetName(handle, index, name);
  return intToErrorCode(result);
}

ErrorCode askarEntryListGetTags(
    EntryListHandle handle, int index, Pointer<Pointer<Utf8>> tags) {
  final result = nativeAskarEntryListGetTags(handle, index, tags);
  return intToErrorCode(result);
}

ErrorCode askarEntryListGetValue(
    EntryListHandle handle, int index, Pointer<SecretBuffer> value) {
  final result = nativeAskarEntryListGetValue(handle, index, value);
  return intToErrorCode(result);
}

ErrorCode askarStringListCount(StringListHandle handle, int count) {
  final countPointer = calloc<Int32>();
  countPointer.value = count;

  final result = nativeAskarStringListCount(handle, countPointer);

  final errorCode = intToErrorCode(result);
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
  return intToErrorCode(result);
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

  return intToErrorCode(result);
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

  return intToErrorCode(result);
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

  return intToErrorCode(result);
}

ErrorCode askarKeyAeadGetParams(
  LocalKeyHandle handle,
  Pointer<AeadParams> out,
) {
  final result = nativeAskarKeyAeadGetParams(
    handle,
    out,
  );

  return intToErrorCode(result);
}

ErrorCode askarKeyAeadRandomNonce(
  LocalKeyHandle handle,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyAeadRandomNonce(
    handle,
    out,
  );

  return intToErrorCode(result);
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

  return intToErrorCode(result);
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

  return intToErrorCode(result);
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

  return intToErrorCode(result);
}

ErrorCode askarKeyCryptoBoxRandomNonce(
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyCryptoBoxRandomNonce(
    out,
  );

  return intToErrorCode(result);
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

  return intToErrorCode(result);
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

  return intToErrorCode(result);
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

  return intToErrorCode(result);
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

  return intToErrorCode(result);
}

ErrorCode askarKeyEntryListCount(KeyEntryListHandle handle, int count) {
  final countPointer = calloc<Int32>();
  countPointer.value = count;

  final result = nativeAskarKeyEntryListCount(handle, countPointer);

  final errorCode = intToErrorCode(result);
  count = countPointer.value;

  calloc.free(countPointer);

  return errorCode;
}

void askarKeyEntryListFree(KeyEntryListHandle handle) {
  nativeAskarKeyEntryListFree(handle);
}

ErrorCode askarKeyEntryListGetAlgorithm(
    KeyEntryListHandle handle, int index, Pointer<Pointer<Utf8>> alg) {
  final result = nativeAskarKeyEntryListGetAlgorithm(handle, index, alg);
  return intToErrorCode(result);
}

ErrorCode askarKeyEntryListGetMetadata(
    KeyEntryListHandle handle, int index, Pointer<Pointer<Utf8>> metadata) {
  final result = nativeAskarKeyEntryListGetMetadata(handle, index, metadata);
  return intToErrorCode(result);
}

ErrorCode askarKeyEntryListGetName(
    KeyEntryListHandle handle, int index, Pointer<Pointer<Utf8>> name) {
  final result = nativeAskarKeyEntryListGetName(handle, index, name);
  return intToErrorCode(result);
}

ErrorCode askarKeyEntryListGetTags(
    KeyEntryListHandle handle, int index, Pointer<Pointer<Utf8>> tags) {
  final result = nativeAskarKeyEntryListGetTags(handle, index, tags);
  return intToErrorCode(result);
}

ErrorCode askarKeyEntryListLoadLocal(
    KeyEntryListHandle handle, int index, Pointer<LocalKeyHandle> out) {
  final result = nativeAskarKeyEntryListLoadLocal(handle, index, out);
  return intToErrorCode(result);
}

void askarKeyFree(LocalKeyHandle handle) {
  nativeAskarKeyFree(handle);
}

ErrorCode askarKeyFromJwk(Pointer<ByteBuffer> jwk, Pointer<LocalKeyHandle> out) {
  final result = nativeAskarKeyFromJwk(jwk, out);
  return intToErrorCode(result);
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

  return intToErrorCode(result);
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

  return intToErrorCode(result);
}

ErrorCode askarKeyFromSecretBytes(
  String alg,
  Pointer<ByteBuffer> secret,
  Pointer<LocalKeyHandle> out,
) {
  final algPointer = alg.toNativeUtf8();

  final result = nativeAskarKeyFromSecretBytes(
    algPointer,
    secret,
    out,
  );

  calloc.free(algPointer);

  return intToErrorCode(result);
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

  return intToErrorCode(result);
}

ErrorCode askarKeyGenerate(
  String alg,
  String keyBackend,
  int ephemeral,
  Pointer<LocalKeyHandle> out,
) {
  final algPointer = alg.toNativeUtf8();
  final keyBackendPointer = keyBackend.toNativeUtf8();

  final result = nativeAskarKeyGenerate(
    algPointer,
    keyBackendPointer,
    ephemeral,
    out,
  );

  calloc.free(algPointer);
  calloc.free(keyBackendPointer);

  return intToErrorCode(result);
}

ErrorCode askarKeyGetAlgorithm(LocalKeyHandle handle, Pointer<Pointer<Utf8>> out) {
  final result = nativeAskarKeyGetAlgorithm(handle, out);
  return intToErrorCode(result);
}

ErrorCode askarKeyGetEphemeral(LocalKeyHandle handle, Pointer<Int8> out) {
  final result = nativeAskarKeyGetEphemeral(handle, out);
  return intToErrorCode(result);
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

  return intToErrorCode(result);
}

ErrorCode askarKeyGetJwkSecret(
  LocalKeyHandle handle,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyGetJwkSecret(
    handle,
    out,
  );

  return intToErrorCode(result);
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

  return intToErrorCode(result);
}

ErrorCode askarKeyGetPublicBytes(
  LocalKeyHandle handle,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyGetPublicBytes(
    handle,
    out,
  );

  return intToErrorCode(result);
}

ErrorCode askarKeyGetSecretBytes(
  LocalKeyHandle handle,
  Pointer<SecretBuffer> out,
) {
  final result = nativeAskarKeyGetSecretBytes(
    handle,
    out,
  );

  return intToErrorCode(result);
}

ErrorCode askarKeySignMessage(
  LocalKeyHandle handle,
  Pointer<ByteBuffer> message,
  String sigType,
  Pointer<SecretBuffer> out,
) {
  final sigTypePointer = sigType.toNativeUtf8();

  final result = nativeAskarKeySignMessage(
    handle,
    message,
    sigTypePointer,
    out,
  );

  calloc.free(sigTypePointer);

  return intToErrorCode(result);
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

  return intToErrorCode(result);
}

ErrorCode askarKeyVerifySignature(
  LocalKeyHandle handle,
  Pointer<ByteBuffer> message,
  Pointer<ByteBuffer> signature,
  String sigType,
  Pointer<Int8> out,
) {
  final sigTypePointer = sigType.toNativeUtf8();

  final result = nativeAskarKeyVerifySignature(
    handle,
    message,
    signature,
    sigTypePointer,
    out,
  );

  calloc.free(sigTypePointer);

  return intToErrorCode(result);
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

  return intToErrorCode(result);
}

ErrorCode askarKeyGetSupportedBackends(Pointer<StringListHandle> out) {
  final result = nativeAskarKeyGetSupportedBackends(out);
  return intToErrorCode(result);
}

ErrorCode askarScanFree(int handle) {
  final result = nativeAskarScanFree(handle);
  return intToErrorCode(result);
}

ErrorCode askarScanNext(
  int handle,
  Pointer<NativeFunction<AskarScanNextCallback>> cb,
  int cbId,
) {
  final result = nativeAskarScanNext(handle, cb, cbId);
  return intToErrorCode(result);
}

ErrorCode askarScanStart(
  int handle,
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
    handle,
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

  return intToErrorCode(result);
}

ErrorCode askarSessionClose(
  int handle,
  int commit,
  Pointer<NativeFunction<AskarSessionCloseCallback>> cb,
  int cbId,
) {
  final result = nativeAskarSessionClose(handle, commit, cb, cbId);
  return intToErrorCode(result);
}

ErrorCode askarSessionCount(
  int handle,
  String category,
  String tagFilter,
  Pointer<NativeFunction<AskarSessionCountCallback>> cb,
  int cbId,
) {
  final categoryPointer = category.toNativeUtf8();
  final tagFilterPointer = tagFilter.toNativeUtf8();

  final result = nativeAskarSessionCount(
    handle,
    categoryPointer,
    tagFilterPointer,
    cb,
    cbId,
  );

  calloc.free(categoryPointer);
  calloc.free(tagFilterPointer);

  return intToErrorCode(result);
}

ErrorCode askarSessionFetch(
  int handle,
  String category,
  String name,
  int forUpdate,
  Pointer<NativeFunction<AskarSessionFetchCallback>> cb,
  int cbId,
) {
  final categoryPointer = category.toNativeUtf8();
  final namePointer = name.toNativeUtf8();

  final result = nativeAskarSessionFetch(
    handle,
    categoryPointer,
    namePointer,
    forUpdate,
    cb,
    cbId,
  );

  calloc.free(categoryPointer);
  calloc.free(namePointer);

  return intToErrorCode(result);
}

ErrorCode askarSessionFetchAll(
  int handle,
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
    handle,
    categoryPointer,
    tagFilterPointer,
    limit,
    forUpdate,
    cb,
    cbId,
  );

  calloc.free(categoryPointer);
  calloc.free(tagFilterPointer);

  return intToErrorCode(result);
}

ErrorCode askarSessionFetchAllKeys(
  int handle,
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
    handle,
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

  return intToErrorCode(result);
}

ErrorCode askarSessionFetchKey(
  int handle,
  String name,
  int forUpdate,
  Pointer<NativeFunction<AskarSessionFetchKeyCallback>> cb,
  int cbId,
) {
  final namePointer = name.toNativeUtf8();

  final result = nativeAskarSessionFetchKey(
    handle,
    namePointer,
    forUpdate,
    cb,
    cbId,
  );

  calloc.free(namePointer);

  return intToErrorCode(result);
}

Future<CallbackResult> askarSessionInsertKey(int handle, LocalKeyHandle keyHandle,
    String name, String metadata, Map<String, String> tags, int expiryMs) {
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
    keyHandle,
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
  int handle,
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

  return intToErrorCode(result);
}

ErrorCode askarSessionRemoveKey(
  int handle,
  String name,
  Pointer<NativeFunction<AskarSessionRemoveKeyCallback>> cb,
  int cbId,
) {
  final namePointer = name.toNativeUtf8();

  final result = nativeAskarSessionRemoveKey(
    handle,
    namePointer,
    cb,
    cbId,
  );

  calloc.free(namePointer);

  return intToErrorCode(result);
}

Future<CallbackResult> askarSessionStart(int handle, String profile, int asTransaction) {
  final profilePointer = profile.toNativeUtf8();

  void cleanup() {
    calloc.free(profilePointer);
  }

  final callback = newCallbackWithHandle(cleanup);

  final result = nativeAskarSessionStart(
    handle,
    profilePointer,
    asTransaction,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

Future<CallbackResult> askarSessionUpdate(
  int handle,
  int operation,
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
    operation,
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

Pointer<ByteBuffer> stringToByteBuffer(String value) {
  // Converter a string para bytes
  List<int> bytes = utf8.encode(value);

  // Alocar memória para os bytes na FFI
  Pointer<Uint8> dataPointer = calloc<Uint8>(bytes.length);

// Copiar os bytes para a memória alocada
  for (int i = 0; i < bytes.length; i++) {
    dataPointer[i] = bytes[i];
  }

  // Alocar memória para o ByteBuffer
  Pointer<ByteBuffer> byteBufferPointer = calloc<ByteBuffer>();

  // Preencher os campos da estrutura
  byteBufferPointer.ref.len = bytes.length;
  byteBufferPointer.ref.data = dataPointer;

  return byteBufferPointer;
}

ErrorCode askarSessionUpdateKey(
  int handle,
  String name,
  String metadata,
  String tags,
  int expiryMs,
  Pointer<NativeFunction<AskarSessionUpdateKeyCallback>> cb,
  int cbId,
) {
  final namePointer = name.toNativeUtf8();
  final metadataPointer = metadata.toNativeUtf8();
  final tagsPointer = tags.toNativeUtf8();

  final result = nativeAskarSessionUpdateKey(
    handle,
    namePointer,
    metadataPointer,
    tagsPointer,
    expiryMs,
    cb,
    cbId,
  );

  calloc.free(namePointer);
  calloc.free(metadataPointer);
  calloc.free(tagsPointer);

  return intToErrorCode(result);
}

Future<CallbackResult> askarStoreClose(int handle) {
  final callback = newCallbackWithoutHandle(() => {});

  final result =
      nativeAskarStoreClose(handle, callback.nativeCallable.nativeFunction, callback.id);

  return callback.handleResult(result);
}

ErrorCode askarStoreCopy(
  int handle,
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

  return intToErrorCode(result);
}

ErrorCode askarStoreCreateProfile(
  int handle,
  String profile,
  Pointer<NativeFunction<AskarStoreCreateProfileCallback>> cb,
  int cbId,
) {
  final profilePointer = profile.toNativeUtf8();

  final result = nativeAskarStoreCreateProfile(
    handle,
    profilePointer,
    cb,
    cbId,
  );

  calloc.free(profilePointer);

  return intToErrorCode(result);
}

ErrorCode askarStoreGenerateRawKey(
  Pointer<ByteBuffer> seed,
  Pointer<Pointer<Utf8>> out,
) {
  final result = nativeAskarStoreGenerateRawKey(seed, out);
  return intToErrorCode(result);
}

ErrorCode askarStoreGetDefaultProfile(
  int handle,
  Pointer<NativeFunction<AskarStoreGetDefaultProfileCallback>> cb,
  int cbId,
) {
  final result = nativeAskarStoreGetDefaultProfile(handle, cb, cbId);
  return intToErrorCode(result);
}

ErrorCode askarStoreGetProfileName(
  int handle,
  Pointer<NativeFunction<AskarStoreGetProfileNameCallback>> cb,
  int cbId,
) {
  final result = nativeAskarStoreGetProfileName(handle, cb, cbId);
  return intToErrorCode(result);
}

ErrorCode askarStoreListProfiles(
  int handle,
  Pointer<NativeFunction<AskarStoreListProfilesCallback>> cb,
  int cbId,
) {
  final result = nativeAskarStoreListProfiles(handle, cb, cbId);
  return intToErrorCode(result);
}

Future<CallbackResult> askarStoreOpen(
  String specUri,
  String keyMethod,
  String passKey,
  String profile,
) {
  final specUriPointer = specUri.toNativeUtf8();
  final keyMethodPointer = keyMethod.toNativeUtf8();
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

base class CallbackParams extends Struct {
  @Int64()
  external int cb_id;

  @Int32()
  external int err;

  @Int64()
  external int handle;
}

Future<CallbackResult> askarStoreProvision(
  String specUri,
  String keyMethod,
  String passKey,
  String profile,
  int recreate,
) {
  final specUriPointer = specUri.toNativeUtf8();
  final keyMethodPointer = keyMethod.toNativeUtf8();
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
    recreate,
    callback.nativeCallable.nativeFunction,
    callback.id,
  );

  return callback.handleResult(result);
}

ErrorCode askarStoreRekey(
  int handle,
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

  return intToErrorCode(result);
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

  return intToErrorCode(result);
}

ErrorCode askarStoreRemoveProfile(
  int handle,
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

  return intToErrorCode(result);
}

ErrorCode askarStoreSetDefaultProfile(
  int handle,
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

  return intToErrorCode(result);
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

  return intToErrorCode(result);
}
