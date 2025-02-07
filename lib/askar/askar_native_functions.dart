// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:import_so_libaskar/askar/askar_wrapper.dart';

base class NativeByteBuffer extends Struct {
  @Int64()
  external int len;

  external Pointer<Uint8> data;
}

base class NativeSecretBuffer extends Struct {
  @Int64()
  external int len;

  external Pointer<Uint8> data;
}

base class NativeEncryptedBuffer extends Struct {
  external NativeSecretBuffer buffer;

  @Int64()
  external int tag_pos;

  @Int64()
  external int nonce_pos;
}

base class NativeAeadParams extends Struct {
  @Int32()
  external int nonce_length;

  @Int32()
  external int tag_length;
}

base class NativeOptionEnabledCallbackStruct extends Struct {
  external Pointer<NativeFunction<OptionEnabledCallback>> callback;
}

base class NativeOptionFlushCallbackStruct extends Struct {
  external Pointer<NativeFunction<OptionFlushCallback>> callback;
}

typedef NativeCallbackId = Int64;

typedef NativeScanHandle = IntPtr;
typedef NativeStoreHandle = IntPtr;
typedef NativeSessionHandle = IntPtr;
typedef NativeEntryListHandle = IntPtr;
typedef NativeLocalKeyHandle = IntPtr;
typedef NativeKeyEntryListHandle = IntPtr;
typedef NativeStringListHandle = IntPtr;

typedef LogCallback = Void Function(
    Pointer<Void> context,
    Int32 level,
    Pointer<Utf8> target,
    Pointer<Utf8> message,
    Pointer<Utf8> module_path,
    Pointer<Utf8> file,
    Int32 line);

typedef OptionEnabledCallback = Void Function(Pointer<Void> context);

typedef OptionFlushCallback = Void Function(Pointer<Void> context);

//
// Native Functions
//

final DynamicLibrary nativeLib =
    Platform.isIOS ? DynamicLibrary.process() : DynamicLibrary.open(getLibAskarPath());

String getLibAskarPath() {
  return Platform.isAndroid
      ? 'libaries_askar.so'
      : 'linux/libaries_askar/libaries_askar.so';
}

final Pointer<Utf8> Function() nativeAskarVersion = nativeLib
    .lookup<NativeFunction<Pointer<Utf8> Function()>>('askar_version')
    .asFunction();

final int Function(Pointer<Pointer<Utf8>> error_json_p) nativeAskarGetCurrentError =
    nativeLib
        .lookup<NativeFunction<Int32 Function(Pointer<Pointer<Utf8>> error_json_p)>>(
            'askar_get_current_error')
        .asFunction();

final void Function(Pointer<NativeSecretBuffer> buffer) nativeAskarBufferFree = nativeLib
    .lookup<NativeFunction<Void Function(Pointer<NativeSecretBuffer> buffer)>>(
        'askar_buffer_free')
    .asFunction();

final void Function() nativeAskarClearCustomLogger = nativeLib
    .lookup<NativeFunction<Void Function()>>('askar_clear_custom_logger')
    .asFunction();

typedef AskarSetCustomLoggerNative = Int32 Function(
  Pointer<Void> context,
  Pointer<NativeFunction<LogCallback>> log,
  Pointer<NativeOptionEnabledCallbackStruct> enabled,
  Pointer<NativeOptionFlushCallbackStruct> flush,
  Int32 max_level,
);

final int Function(
  Pointer<Void> context,
  Pointer<NativeFunction<LogCallback>> log,
  Pointer<NativeOptionEnabledCallbackStruct> enabled,
  Pointer<NativeOptionFlushCallbackStruct> flush,
  int max_level,
) nativeAskarSetCustomLogger = nativeLib
    .lookup<NativeFunction<AskarSetCustomLoggerNative>>('askar_set_custom_logger')
    .asFunction();

final int Function() nativeAskarSetDefaultLogger = nativeLib
    .lookup<NativeFunction<Int32 Function()>>('askar_set_default_logger')
    .asFunction();

final int Function(int max_level) nativeAskarSetMaxLogLevel = nativeLib
    .lookup<NativeFunction<Int32 Function(Int32 max_level)>>('askar_set_max_log_level')
    .asFunction();

typedef AskarEntryListCountNative = Int32 Function(
    NativeEntryListHandle handle, Pointer<Int32> count);

final int Function(EntryListHandle handle, Pointer<Int32> count)
    nativeAskarEntryListCount = nativeLib
        .lookup<NativeFunction<AskarEntryListCountNative>>('askar_entry_list_count')
        .asFunction();

typedef AskarEntryListFreeNative = Void Function(NativeEntryListHandle handle);

final void Function(EntryListHandle handle) nativeAskarEntryListFree = nativeLib
    .lookup<NativeFunction<AskarEntryListFreeNative>>('askar_entry_list_free')
    .asFunction();

typedef AskarEntryListGetCategoryNative = Int32 Function(
  NativeEntryListHandle handle,
  Int32 index,
  Pointer<Pointer<Utf8>> category,
);

final int Function(
  EntryListHandle handle,
  int index,
  Pointer<Pointer<Utf8>> category,
) nativeAskarEntryListGetCategory = nativeLib
    .lookup<NativeFunction<AskarEntryListGetCategoryNative>>(
        'askar_entry_list_get_category')
    .asFunction();

typedef AskarEntryListGetNameNative = Int32 Function(
  NativeEntryListHandle handle,
  Int32 index,
  Pointer<Pointer<Utf8>> name,
);

final int Function(
  EntryListHandle handle,
  int index,
  Pointer<Pointer<Utf8>> name,
) nativeAskarEntryListGetName = nativeLib
    .lookup<NativeFunction<AskarEntryListGetNameNative>>('askar_entry_list_get_name')
    .asFunction();

typedef AskarEntryListGetTagsNative = Int32 Function(
  NativeEntryListHandle handle,
  Int32 index,
  Pointer<Pointer<Utf8>> tags,
);

final int Function(
  EntryListHandle handle,
  int index,
  Pointer<Pointer<Utf8>> tags,
) nativeAskarEntryListGetTags = nativeLib
    .lookup<NativeFunction<AskarEntryListGetTagsNative>>('askar_entry_list_get_tags')
    .asFunction();

typedef AskarEntryListGetValueNative = Int32 Function(
  NativeEntryListHandle handle,
  Int32 index,
  Pointer<NativeSecretBuffer> value,
);

final int Function(
  EntryListHandle handle,
  int index,
  Pointer<NativeSecretBuffer> value,
) nativeAskarEntryListGetValue = nativeLib
    .lookup<NativeFunction<AskarEntryListGetValueNative>>('askar_entry_list_get_value')
    .asFunction();

typedef AskarStringListCountNative = Int32 Function(
  NativeStringListHandle handle,
  Pointer<Int32> count,
);

final int Function(
  StringListHandle handle,
  Pointer<Int32> count,
) nativeAskarStringListCount = nativeLib
    .lookup<NativeFunction<AskarStringListCountNative>>('askar_string_list_count')
    .asFunction();

typedef AskarStringListFreeNative = Void Function(NativeStringListHandle handle);

final void Function(StringListHandle handle) nativeAskarStringListFree = nativeLib
    .lookup<NativeFunction<AskarStringListFreeNative>>('askar_string_list_free')
    .asFunction();

typedef AskarStringListGetItemNative = Int32 Function(
  NativeStringListHandle handle,
  Int32 index,
  Pointer<Pointer<Utf8>> item,
);

final int Function(
  StringListHandle handle,
  int index,
  Pointer<Pointer<Utf8>> item,
) nativeAskarStringListGetItem = nativeLib
    .lookup<NativeFunction<AskarStringListGetItemNative>>('askar_string_list_get_item')
    .asFunction();

typedef AskarKeyAeadDecryptNative = Int32 Function(
  NativeLocalKeyHandle handle,
  NativeByteBuffer ciphertext,
  NativeByteBuffer nonce,
  NativeByteBuffer tag,
  NativeByteBuffer aad,
  Pointer<NativeSecretBuffer> out,
);

final int Function(
  LocalKeyHandle handle,
  NativeByteBuffer ciphertext,
  NativeByteBuffer nonce,
  NativeByteBuffer tag,
  NativeByteBuffer aad,
  Pointer<NativeSecretBuffer> out,
) nativeAskarKeyAeadDecrypt = nativeLib
    .lookup<NativeFunction<AskarKeyAeadDecryptNative>>('askar_key_aead_decrypt')
    .asFunction();

typedef AskarKeyAeadEncryptNative = Int32 Function(
  NativeLocalKeyHandle handle,
  NativeByteBuffer message,
  NativeByteBuffer nonce,
  NativeByteBuffer aad,
  Pointer<NativeEncryptedBuffer> out,
);

final int Function(
  LocalKeyHandle handle,
  NativeByteBuffer message,
  NativeByteBuffer nonce,
  NativeByteBuffer aad,
  Pointer<NativeEncryptedBuffer> out,
) nativeAskarKeyAeadEncrypt = nativeLib
    .lookup<NativeFunction<AskarKeyAeadEncryptNative>>('askar_key_aead_encrypt')
    .asFunction();

typedef AskarKeyAeadGetPaddingNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Int64 msg_len,
  Pointer<Int32> out,
);

final int Function(
  LocalKeyHandle handle,
  int msg_len,
  Pointer<Int32> out,
) nativeAskarKeyAeadGetPadding = nativeLib
    .lookup<NativeFunction<AskarKeyAeadGetPaddingNative>>('askar_key_aead_get_padding')
    .asFunction();

typedef AskarKeyAeadGetParamsNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<NativeAeadParams> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<NativeAeadParams> out,
) nativeAskarKeyAeadGetParams = nativeLib
    .lookup<NativeFunction<AskarKeyAeadGetParamsNative>>('askar_key_aead_get_params')
    .asFunction();

typedef AskarKeyAeadRandomNonceNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<NativeSecretBuffer> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<NativeSecretBuffer> out,
) nativeAskarKeyAeadRandomNonce = nativeLib
    .lookup<NativeFunction<AskarKeyAeadRandomNonceNative>>('askar_key_aead_random_nonce')
    .asFunction();

typedef AskarKeyConvertNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<Utf8> alg,
  Pointer<NativeLocalKeyHandle> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<Utf8> alg,
  Pointer<NativeLocalKeyHandle> out,
) nativeAskarKeyConvert = nativeLib
    .lookup<NativeFunction<AskarKeyConvertNative>>('askar_key_convert')
    .asFunction();

typedef AskarKeyCryptoBoxNative = Int32 Function(
  NativeLocalKeyHandle recip_key,
  NativeLocalKeyHandle sender_key,
  Pointer<NativeByteBuffer> message,
  Pointer<NativeByteBuffer> nonce,
  Pointer<NativeSecretBuffer> out,
);

final int Function(
  LocalKeyHandle recip_key,
  LocalKeyHandle sender_key,
  Pointer<NativeByteBuffer> message,
  Pointer<NativeByteBuffer> nonce,
  Pointer<NativeSecretBuffer> out,
) nativeAskarKeyCryptoBox = nativeLib
    .lookup<NativeFunction<AskarKeyCryptoBoxNative>>('askar_key_crypto_box')
    .asFunction();

typedef AskarKeyCryptoBoxOpenNative = Int32 Function(
  NativeLocalKeyHandle recip_key,
  NativeLocalKeyHandle sender_key,
  Pointer<NativeByteBuffer> message,
  Pointer<NativeByteBuffer> nonce,
  Pointer<NativeSecretBuffer> out,
);

final int Function(
  LocalKeyHandle recip_key,
  LocalKeyHandle sender_key,
  Pointer<NativeByteBuffer> message,
  Pointer<NativeByteBuffer> nonce,
  Pointer<NativeSecretBuffer> out,
) nativeAskarKeyCryptoBoxOpen = nativeLib
    .lookup<NativeFunction<AskarKeyCryptoBoxOpenNative>>('askar_key_crypto_box_open')
    .asFunction();

typedef AskarKeyCryptoBoxRandomNonceNative = Int32 Function(
  Pointer<NativeSecretBuffer> out,
);

final int Function(
  Pointer<NativeSecretBuffer> out,
) nativeAskarKeyCryptoBoxRandomNonce = nativeLib
    .lookup<NativeFunction<AskarKeyCryptoBoxRandomNonceNative>>(
        'askar_key_crypto_box_random_nonce')
    .asFunction();

typedef AskarKeyCryptoBoxSealNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<NativeByteBuffer> message,
  Pointer<NativeSecretBuffer> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<NativeByteBuffer> message,
  Pointer<NativeSecretBuffer> out,
) nativeAskarKeyCryptoBoxSeal = nativeLib
    .lookup<NativeFunction<AskarKeyCryptoBoxSealNative>>('askar_key_crypto_box_seal')
    .asFunction();

typedef AskarKeyCryptoBoxSealOpenNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<NativeByteBuffer> ciphertext,
  Pointer<NativeSecretBuffer> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<NativeByteBuffer> ciphertext,
  Pointer<NativeSecretBuffer> out,
) nativeAskarKeyCryptoBoxSealOpen = nativeLib
    .lookup<NativeFunction<AskarKeyCryptoBoxSealOpenNative>>(
        'askar_key_crypto_box_seal_open')
    .asFunction();

typedef AskarKeyDeriveEcdh1puNative = Int32 Function(
  Pointer<Utf8> alg,
  NativeLocalKeyHandle ephem_key,
  NativeLocalKeyHandle sender_key,
  NativeLocalKeyHandle recip_key,
  Pointer<NativeByteBuffer> alg_id,
  Pointer<NativeByteBuffer> apu,
  Pointer<NativeByteBuffer> apv,
  Pointer<NativeByteBuffer> cc_tag,
  Int8 receive,
  Pointer<NativeLocalKeyHandle> out,
);

final int Function(
  Pointer<Utf8> alg,
  LocalKeyHandle ephem_key,
  LocalKeyHandle sender_key,
  LocalKeyHandle recip_key,
  Pointer<NativeByteBuffer> alg_id,
  Pointer<NativeByteBuffer> apu,
  Pointer<NativeByteBuffer> apv,
  Pointer<NativeByteBuffer> cc_tag,
  int receive,
  Pointer<NativeLocalKeyHandle> out,
) nativeAskarKeyDeriveEcdh1pu = nativeLib
    .lookup<NativeFunction<AskarKeyDeriveEcdh1puNative>>('askar_key_derive_ecdh_1pu')
    .asFunction();

typedef AskarKeyDeriveEcdhEsNative = Int32 Function(
  Pointer<Utf8> alg,
  NativeLocalKeyHandle ephem_key,
  NativeLocalKeyHandle recip_key,
  NativeByteBuffer alg_id,
  NativeByteBuffer apu,
  NativeByteBuffer apv,
  Int8 receive,
  Pointer<NativeLocalKeyHandle> out,
);

final int Function(
  Pointer<Utf8> alg,
  LocalKeyHandle ephem_key,
  LocalKeyHandle recip_key,
  NativeByteBuffer alg_id,
  NativeByteBuffer apu,
  NativeByteBuffer apv,
  int receive,
  Pointer<NativeLocalKeyHandle> out,
) nativeAskarKeyDeriveEcdhEs = nativeLib
    .lookup<NativeFunction<AskarKeyDeriveEcdhEsNative>>('askar_key_derive_ecdh_es')
    .asFunction();

typedef AskarKeyEntryListCountNative = Int32 Function(
  NativeKeyEntryListHandle handle,
  Pointer<Int32> count,
);

final int Function(
  KeyEntryListHandle handle,
  Pointer<Int32> count,
) nativeAskarKeyEntryListCount = nativeLib
    .lookup<NativeFunction<AskarKeyEntryListCountNative>>('askar_key_entry_list_count')
    .asFunction();

typedef AskarKeyEntryListFreeNative = Void Function(NativeKeyEntryListHandle handle);

final void Function(KeyEntryListHandle handle) nativeAskarKeyEntryListFree = nativeLib
    .lookup<NativeFunction<AskarKeyEntryListFreeNative>>('askar_key_entry_list_free')
    .asFunction();

typedef AskarKeyEntryListGetAlgorithmNative = Int32 Function(
  NativeKeyEntryListHandle handle,
  Int32 index,
  Pointer<Pointer<Utf8>> alg,
);

final int Function(
  KeyEntryListHandle handle,
  int index,
  Pointer<Pointer<Utf8>> alg,
) nativeAskarKeyEntryListGetAlgorithm = nativeLib
    .lookup<NativeFunction<AskarKeyEntryListGetAlgorithmNative>>(
        'askar_key_entry_list_get_algorithm')
    .asFunction();

typedef AskarKeyEntryListGetMetadataNative = Int32 Function(
  NativeKeyEntryListHandle handle,
  Int32 index,
  Pointer<Pointer<Utf8>> metadata,
);

final int Function(
  KeyEntryListHandle handle,
  int index,
  Pointer<Pointer<Utf8>> metadata,
) nativeAskarKeyEntryListGetMetadata = nativeLib
    .lookup<NativeFunction<AskarKeyEntryListGetMetadataNative>>(
        'askar_key_entry_list_get_metadata')
    .asFunction();

typedef AskarKeyEntryListGetNameNative = Int32 Function(
  NativeKeyEntryListHandle handle,
  Int32 index,
  Pointer<Pointer<Utf8>> name,
);

final int Function(
  KeyEntryListHandle handle,
  int index,
  Pointer<Pointer<Utf8>> name,
) nativeAskarKeyEntryListGetName = nativeLib
    .lookup<NativeFunction<AskarKeyEntryListGetNameNative>>(
        'askar_key_entry_list_get_name')
    .asFunction();

typedef AskarKeyEntryListGetTagsNative = Int32 Function(
  NativeKeyEntryListHandle handle,
  Int32 index,
  Pointer<Pointer<Utf8>> tags,
);

final int Function(
  KeyEntryListHandle handle,
  int index,
  Pointer<Pointer<Utf8>> tags,
) nativeAskarKeyEntryListGetTags = nativeLib
    .lookup<NativeFunction<AskarKeyEntryListGetTagsNative>>(
        'askar_key_entry_list_get_tags')
    .asFunction();

typedef AskarKeyEntryListLoadLocalNative = Int32 Function(
  NativeKeyEntryListHandle handle,
  Int32 index,
  Pointer<NativeLocalKeyHandle> out,
);

final int Function(
  int handle,
  int index,
  Pointer<NativeLocalKeyHandle> out,
) nativeAskarKeyEntryListLoadLocal = nativeLib
    .lookup<NativeFunction<AskarKeyEntryListLoadLocalNative>>(
        'askar_key_entry_list_load_local')
    .asFunction();

typedef AskarKeyFreeNative = Void Function(NativeLocalKeyHandle handle);

final void Function(LocalKeyHandle handle) nativeAskarKeyFree =
    nativeLib.lookup<NativeFunction<AskarKeyFreeNative>>('askar_key_free').asFunction();

typedef AskarKeyFromJwkNative = Int32 Function(
  NativeByteBuffer jwk,
  Pointer<NativeLocalKeyHandle> out,
);

final int Function(
  NativeByteBuffer jwk,
  Pointer<NativeLocalKeyHandle> out,
) nativeAskarKeyFromJwk = nativeLib
    .lookup<NativeFunction<AskarKeyFromJwkNative>>('askar_key_from_jwk')
    .asFunction();

typedef AskarKeyFromKeyExchangeNative = Int32 Function(
  Pointer<Utf8> alg,
  NativeLocalKeyHandle sk_handle,
  NativeLocalKeyHandle pk_handle,
  Pointer<NativeLocalKeyHandle> out,
);

final int Function(
  Pointer<Utf8> alg,
  LocalKeyHandle sk_handle,
  LocalKeyHandle pk_handle,
  Pointer<NativeLocalKeyHandle> out,
) nativeAskarKeyFromKeyExchange = nativeLib
    .lookup<NativeFunction<AskarKeyFromKeyExchangeNative>>('askar_key_from_key_exchange')
    .asFunction();

typedef AskarKeyFromPublicBytesNative = Int32 Function(
  Pointer<Utf8> alg,
  Pointer<NativeByteBuffer> public_,
  Pointer<NativeLocalKeyHandle> out,
);

final int Function(
  Pointer<Utf8> alg,
  Pointer<NativeByteBuffer> public_,
  Pointer<NativeLocalKeyHandle> out,
) nativeAskarKeyFromPublicBytes = nativeLib
    .lookup<NativeFunction<AskarKeyFromPublicBytesNative>>('askar_key_from_public_bytes')
    .asFunction();

typedef AskarKeyFromSecretBytesNative = Int32 Function(
  Pointer<Utf8> alg,
  NativeByteBuffer secret,
  Pointer<IntPtr> out,
);

final int Function(
  Pointer<Utf8> alg,
  NativeByteBuffer secret,
  Pointer<IntPtr> out,
) nativeAskarKeyFromSecretBytes = nativeLib
    .lookup<NativeFunction<AskarKeyFromSecretBytesNative>>('askar_key_from_secret_bytes')
    .asFunction();

typedef AskarKeyFromSeedNative = Int32 Function(
  Pointer<Utf8> alg,
  Pointer<NativeByteBuffer> seed,
  Pointer<Utf8> method,
  Pointer<NativeLocalKeyHandle> out,
);

final int Function(
  Pointer<Utf8> alg,
  Pointer<NativeByteBuffer> seed,
  Pointer<Utf8> method,
  Pointer<NativeLocalKeyHandle> out,
) nativeAskarKeyFromSeed = nativeLib
    .lookup<NativeFunction<AskarKeyFromSeedNative>>('askar_key_from_seed')
    .asFunction();

typedef AskarKeyGenerateNative = Int32 Function(
  Pointer<Utf8> alg,
  Pointer<Utf8> key_backend,
  Int8 ephemeral,
  Pointer<Int64> out,
);

final int Function(
  Pointer<Utf8> alg,
  Pointer<Utf8> key_backend,
  int ephemeral,
  Pointer<Int64> out,
) nativeAskarKeyGenerate = nativeLib
    .lookup<NativeFunction<AskarKeyGenerateNative>>('askar_key_generate')
    .asFunction();

typedef AskarKeyGetAlgorithmNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<Pointer<Utf8>> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<Pointer<Utf8>> out,
) nativeAskarKeyGetAlgorithm = nativeLib
    .lookup<NativeFunction<AskarKeyGetAlgorithmNative>>('askar_key_get_algorithm')
    .asFunction();

typedef AskarKeyGetEphemeralNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<Int8> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<Int8> out,
) nativeAskarKeyGetEphemeral = nativeLib
    .lookup<NativeFunction<AskarKeyGetEphemeralNative>>('askar_key_get_ephemeral')
    .asFunction();

typedef AskarKeyGetJwkPublicNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<Utf8> alg,
  Pointer<Pointer<Utf8>> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<Utf8> alg,
  Pointer<Pointer<Utf8>> out,
) nativeAskarKeyGetJwkPublic = nativeLib
    .lookup<NativeFunction<AskarKeyGetJwkPublicNative>>('askar_key_get_jwk_public')
    .asFunction();

typedef AskarKeyGetJwkSecretNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<NativeSecretBuffer> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<NativeSecretBuffer> out,
) nativeAskarKeyGetJwkSecret = nativeLib
    .lookup<NativeFunction<AskarKeyGetJwkSecretNative>>('askar_key_get_jwk_secret')
    .asFunction();

typedef AskarKeyGetJwkThumbprintNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<Utf8> alg,
  Pointer<Pointer<Utf8>> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<Utf8> alg,
  Pointer<Pointer<Utf8>> out,
) nativeAskarKeyGetJwkThumbprint = nativeLib
    .lookup<NativeFunction<AskarKeyGetJwkThumbprintNative>>(
        'askar_key_get_jwk_thumbprint')
    .asFunction();

typedef AskarKeyGetPublicBytesNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<NativeSecretBuffer> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<NativeSecretBuffer> out,
) nativeAskarKeyGetPublicBytes = nativeLib
    .lookup<NativeFunction<AskarKeyGetPublicBytesNative>>('askar_key_get_public_bytes')
    .asFunction();

typedef AskarKeyGetSecretBytesNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<NativeSecretBuffer> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<NativeSecretBuffer> out,
) nativeAskarKeyGetSecretBytes = nativeLib
    .lookup<NativeFunction<AskarKeyGetSecretBytesNative>>('askar_key_get_secret_bytes')
    .asFunction();

typedef AskarKeySignMessageNative = Int32 Function(
  NativeLocalKeyHandle handle,
  NativeByteBuffer message,
  Pointer<Utf8> sig_type,
  Pointer<NativeSecretBuffer> out,
);

final int Function(
  LocalKeyHandle handle,
  NativeByteBuffer message,
  Pointer<Utf8> sig_type,
  Pointer<NativeSecretBuffer> out,
) nativeAskarKeySignMessage = nativeLib
    .lookup<NativeFunction<AskarKeySignMessageNative>>('askar_key_sign_message')
    .asFunction();

typedef AskarKeyUnwrapKeyNative = Int32 Function(
  NativeLocalKeyHandle handle,
  Pointer<Utf8> alg,
  NativeByteBuffer ciphertext,
  NativeByteBuffer nonce,
  NativeByteBuffer tag,
  Pointer<NativeLocalKeyHandle> out,
);

final int Function(
  LocalKeyHandle handle,
  Pointer<Utf8> alg,
  NativeByteBuffer ciphertext,
  NativeByteBuffer nonce,
  NativeByteBuffer tag,
  Pointer<NativeLocalKeyHandle> out,
) nativeAskarKeyUnwrapKey = nativeLib
    .lookup<NativeFunction<AskarKeyUnwrapKeyNative>>('askar_key_unwrap_key')
    .asFunction();

typedef AskarKeyVerifySignatureNative = Int32 Function(
  NativeLocalKeyHandle handle,
  NativeByteBuffer message,
  NativeByteBuffer signature,
  Pointer<Utf8> sig_type,
  Pointer<Int8> out,
);

final int Function(
  LocalKeyHandle handle,
  NativeByteBuffer message,
  NativeByteBuffer signature,
  Pointer<Utf8> sig_type,
  Pointer<Int8> out,
) nativeAskarKeyVerifySignature = nativeLib
    .lookup<NativeFunction<AskarKeyVerifySignatureNative>>('askar_key_verify_signature')
    .asFunction();

typedef AskarKeyWrapKeyNative = Int32 Function(
  NativeLocalKeyHandle handle,
  NativeLocalKeyHandle other,
  NativeByteBuffer nonce,
  Pointer<NativeEncryptedBuffer> out,
);

final int Function(
  LocalKeyHandle handle,
  LocalKeyHandle other,
  NativeByteBuffer nonce,
  Pointer<NativeEncryptedBuffer> out,
) nativeAskarKeyWrapKey = nativeLib
    .lookup<NativeFunction<AskarKeyWrapKeyNative>>('askar_key_wrap_key')
    .asFunction();

typedef AskarKeyGetSupportedBackendsNative = Int32 Function(
  Pointer<NativeStringListHandle> out,
);

final int Function(
  Pointer<NativeStringListHandle> out,
) nativeAskarKeyGetSupportedBackends = nativeLib
    .lookup<NativeFunction<AskarKeyGetSupportedBackendsNative>>(
        'askar_key_get_supported_backends')
    .asFunction();

typedef AskarScanFreeNative = Int32 Function(
  NativeScanHandle scanHandle,
);

final int Function(
  ScanHandle handle,
) nativeAskarScanFree =
    nativeLib.lookup<NativeFunction<AskarScanFreeNative>>('askar_scan_free').asFunction();

typedef AskarScanNextCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  NativeEntryListHandle results,
);

typedef AskarScanNextNative = Int32 Function(
  NativeScanHandle handle,
  Pointer<NativeFunction<AskarScanNextCallback>> cb,
  Int64 cb_id,
);

final int Function(
  ScanHandle handle,
  Pointer<NativeFunction<AskarScanNextCallback>> cb,
  int cb_id,
) nativeAskarScanNext =
    nativeLib.lookup<NativeFunction<AskarScanNextNative>>('askar_scan_next').asFunction();

typedef AskarScanStartCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  NativeScanHandle handle,
);

typedef AskarScanStartNative = Int32 Function(
  NativeStoreHandle handle,
  Pointer<Utf8> profile,
  Pointer<Utf8> category,
  Pointer<Utf8> tag_filter,
  Int64 offset,
  Int64 limit,
  Pointer<NativeFunction<AskarScanStartCallback>> cb,
  Int64 cb_id,
);

final int Function(
  ScanHandle handle,
  Pointer<Utf8> profile,
  Pointer<Utf8> category,
  Pointer<Utf8> tag_filter,
  int offset,
  int limit,
  Pointer<NativeFunction<AskarScanStartCallback>> cb,
  int cb_id,
) nativeAskarScanStart = nativeLib
    .lookup<NativeFunction<AskarScanStartNative>>('askar_scan_start')
    .asFunction();

typedef AskarSessionCloseCallback = Void Function(
  Int64 cb_id,
  Int32 err,
);

typedef AskarSessionCloseNative = Int32 Function(
  NativeSessionHandle handle,
  Int8 commit,
  Pointer<NativeFunction<AskarSessionCloseCallback>> cb,
  Int64 cb_id,
);

final int Function(
  SessionHandle handle,
  int commit,
  Pointer<NativeFunction<AskarSessionCloseCallback>> cb,
  int cb_id,
) nativeAskarSessionClose = nativeLib
    .lookup<NativeFunction<AskarSessionCloseNative>>('askar_session_close')
    .asFunction();

typedef AskarSessionCountCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  Int64 count,
);

typedef AskarSessionCountNative = Int32 Function(
  NativeSessionHandle handle,
  Pointer<Utf8> category,
  Pointer<Utf8> tag_filter,
  Pointer<NativeFunction<AskarSessionCountCallback>> cb,
  Int64 cb_id,
);

final int Function(
  SessionHandle handle,
  Pointer<Utf8> category,
  Pointer<Utf8> tag_filter,
  Pointer<NativeFunction<AskarSessionCountCallback>> cb,
  int cb_id,
) nativeAskarSessionCount = nativeLib
    .lookup<NativeFunction<AskarSessionCountNative>>('askar_session_count')
    .asFunction();

typedef AskarSessionFetchCallback = Void Function(
  NativeCallbackId cb_id,
  Int32 err,
  IntPtr results,
);

typedef AskarSessionFetchNative = Int32 Function(
  NativeSessionHandle handle,
  Pointer<Utf8> category,
  Pointer<Utf8> name,
  Int8 for_update,
  Pointer<NativeFunction<AskarSessionFetchCallback>> cb,
  Int64 cb_id,
);

final int Function(
  SessionHandle handle,
  Pointer<Utf8> category,
  Pointer<Utf8> name,
  int for_update,
  Pointer<NativeFunction<AskarSessionFetchCallback>> cb,
  int cb_id,
) nativeAskarSessionFetch = nativeLib
    .lookup<NativeFunction<AskarSessionFetchNative>>('askar_session_fetch')
    .asFunction();

typedef AskarSessionFetchAllCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  NativeEntryListHandle results,
);

typedef AskarSessionFetchAllNative = Int32 Function(
  NativeSessionHandle handle,
  Pointer<Utf8> category,
  Pointer<Utf8> tag_filter,
  Int64 limit,
  Int8 for_update,
  Pointer<NativeFunction<AskarSessionFetchAllCallback>> cb,
  Int64 cb_id,
);

final int Function(
  SessionHandle handle,
  Pointer<Utf8> category,
  Pointer<Utf8> tag_filter,
  int limit,
  int for_update,
  Pointer<NativeFunction<AskarSessionFetchAllCallback>> cb,
  int cb_id,
) nativeAskarSessionFetchAll = nativeLib
    .lookup<NativeFunction<AskarSessionFetchAllNative>>('askar_session_fetch_all')
    .asFunction();

typedef AskarSessionFetchAllKeysCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  NativeKeyEntryListHandle results,
);

typedef AskarSessionFetchAllKeysNative = Int32 Function(
  NativeSessionHandle handle,
  Pointer<Utf8> alg,
  Pointer<Utf8> thumbprint,
  Pointer<Utf8> tag_filter,
  Int64 limit,
  Int8 for_update,
  Pointer<NativeFunction<AskarSessionFetchAllKeysCallback>> cb,
  Int64 cb_id,
);

final int Function(
  SessionHandle handle,
  Pointer<Utf8> alg,
  Pointer<Utf8> thumbprint,
  Pointer<Utf8> tag_filter,
  int limit,
  int for_update,
  Pointer<NativeFunction<AskarSessionFetchAllKeysCallback>> cb,
  int cb_id,
) nativeAskarSessionFetchAllKeys = nativeLib
    .lookup<NativeFunction<AskarSessionFetchAllKeysNative>>(
        'askar_session_fetch_all_keys')
    .asFunction();

typedef AskarSessionFetchKeyCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  IntPtr results,
);

typedef AskarSessionFetchKeyNative = Int32 Function(
  NativeSessionHandle handle,
  Pointer<Utf8> name,
  Int8 for_update,
  Pointer<NativeFunction<AskarSessionFetchKeyCallback>> cb,
  Int64 cb_id,
);

final int Function(
  SessionHandle handle,
  Pointer<Utf8> name,
  int for_update,
  Pointer<NativeFunction<AskarSessionFetchKeyCallback>> cb,
  int cb_id,
) nativeAskarSessionFetchKey = nativeLib
    .lookup<NativeFunction<AskarSessionFetchKeyNative>>('askar_session_fetch_key')
    .asFunction();

typedef AskarSessionInsertKeyCallback = Void Function(
  Int64 cb_id,
  Int32 err,
);

typedef AskarSessionInsertKeyNative = Int32 Function(
  IntPtr handle,
  IntPtr key_handle,
  Pointer<Utf8> name,
  Pointer<Utf8> metadata,
  Pointer<Utf8> tags,
  Int64 expiry_ms,
  Pointer<NativeFunction<AskarSessionInsertKeyCallback>> cb,
  Int64 cb_id,
);

final int Function(
  int handle,
  int key_handle,
  Pointer<Utf8> name,
  Pointer<Utf8> metadata,
  Pointer<Utf8> tags,
  int expiry_ms,
  Pointer<NativeFunction<AskarSessionInsertKeyCallback>> cb,
  int cb_id,
) nativeAskarSessionInsertKey = nativeLib
    .lookup<NativeFunction<AskarSessionInsertKeyNative>>('askar_session_insert_key')
    .asFunction();

typedef AskarSessionRemoveAllCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  Int64 removed,
);

typedef AskarSessionRemoveAllNative = Int32 Function(
  NativeSessionHandle handle,
  Pointer<Utf8> category,
  Pointer<Utf8> tag_filter,
  Pointer<NativeFunction<AskarSessionRemoveAllCallback>> cb,
  Int64 cb_id,
);

final int Function(
  int handle,
  Pointer<Utf8> category,
  Pointer<Utf8> tag_filter,
  Pointer<NativeFunction<AskarSessionRemoveAllCallback>> cb,
  int cb_id,
) nativeAskarSessionRemoveAll = nativeLib
    .lookup<NativeFunction<AskarSessionRemoveAllNative>>('askar_session_remove_all')
    .asFunction();

typedef AskarSessionRemoveKeyCallback = Void Function(
  Int64 cb_id,
  Int32 err,
);

typedef AskarSessionRemoveKeyNative = Int32 Function(
  NativeSessionHandle handle,
  Pointer<Utf8> name,
  Pointer<NativeFunction<AskarSessionRemoveKeyCallback>> cb,
  Int64 cb_id,
);

final int Function(
  int handle,
  Pointer<Utf8> name,
  Pointer<NativeFunction<AskarSessionRemoveKeyCallback>> cb,
  int cb_id,
) nativeAskarSessionRemoveKey = nativeLib
    .lookup<NativeFunction<AskarSessionRemoveKeyNative>>('askar_session_remove_key')
    .asFunction();

typedef AskarSessionUpdateCallback = Void Function(
  Int64 cb_id,
  Int32 err,
);

typedef AskarSessionStartNative = Int32 Function(
  NativeStoreHandle handle,
  Pointer<Utf8> profile,
  Int8 as_transaction,
  Pointer<NativeFunction<Void Function(NativeCallbackId, Int32, NativeSessionHandle)>> cb,
  NativeCallbackId cb_id,
);

final int Function(
  StoreHandle handle,
  Pointer<Utf8> profile,
  int as_transaction,
  Pointer<NativeFunction<Void Function(NativeCallbackId, Int32, NativeSessionHandle)>> cb,
  int cb_id,
) nativeAskarSessionStart = nativeLib
    .lookup<NativeFunction<AskarSessionStartNative>>('askar_session_start')
    .asFunction();

typedef AskarSessionUpdateNative = Int32 Function(
  NativeSessionHandle handle,
  Int8 operation,
  Pointer<Utf8> category,
  Pointer<Utf8> name,
  NativeByteBuffer value,
  Pointer<Utf8> tags,
  Int64 expiry_ms,
  Pointer<NativeFunction<AskarSessionUpdateCallback>> cb,
  Int64 cb_id,
);

final int Function(
  SessionHandle handle,
  int operation,
  Pointer<Utf8> category,
  Pointer<Utf8> name,
  NativeByteBuffer value,
  Pointer<Utf8> tags,
  int expiry_ms,
  Pointer<NativeFunction<AskarSessionUpdateCallback>> cb,
  int cb_id,
) nativeAskarSessionUpdate = nativeLib
    .lookup<NativeFunction<AskarSessionUpdateNative>>('askar_session_update')
    .asFunction();

typedef AskarSessionUpdateKeyCallback = Void Function(
  Int64 cb_id,
  Int32 err,
);

typedef AskarSessionUpdateKeyNative = Int32 Function(
  NativeSessionHandle handle,
  Pointer<Utf8> name,
  Pointer<Utf8> metadata,
  Pointer<Utf8> tags,
  Int64 expiry_ms,
  Pointer<NativeFunction<AskarSessionUpdateKeyCallback>> cb,
  Int64 cb_id,
);

final int Function(
  SessionHandle handle,
  Pointer<Utf8> name,
  Pointer<Utf8> metadata,
  Pointer<Utf8> tags,
  int expiry_ms,
  Pointer<NativeFunction<AskarSessionUpdateKeyCallback>> cb,
  int cb_id,
) nativeAskarSessionUpdateKey = nativeLib
    .lookup<NativeFunction<AskarSessionUpdateKeyNative>>('askar_session_update_key')
    .asFunction();

typedef AskarStoreCloseCallback = Void Function(
  Int64 cb_id,
  Int32 err,
);

typedef AskarStoreCloseNative = Int32 Function(
  NativeStoreHandle handle,
  Pointer<NativeFunction<AskarStoreCloseCallback>> cb,
  Int64 cb_id,
);

final int Function(
  StoreHandle handle,
  Pointer<NativeFunction<AskarStoreCloseCallback>> cb,
  int cb_id,
) nativeAskarStoreClose = nativeLib
    .lookup<NativeFunction<AskarStoreCloseNative>>('askar_store_close')
    .asFunction();

typedef AskarStoreCopyCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  NativeStoreHandle handle,
);

typedef AskarStoreCopyNative = Int32 Function(
  NativeStoreHandle handle,
  Pointer<Utf8> target_uri,
  Pointer<Utf8> key_method,
  Pointer<Utf8> pass_key,
  Int8 recreate,
  Pointer<NativeFunction<AskarStoreCopyCallback>> cb,
  Int64 cb_id,
);

final int Function(
  StoreHandle handle,
  Pointer<Utf8> target_uri,
  Pointer<Utf8> key_method,
  Pointer<Utf8> pass_key,
  int recreate,
  Pointer<NativeFunction<AskarStoreCopyCallback>> cb,
  int cb_id,
) nativeAskarStoreCopy = nativeLib
    .lookup<NativeFunction<AskarStoreCopyNative>>('askar_store_copy')
    .asFunction();

typedef AskarStoreCreateProfileCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  Pointer<Utf8> result_p,
);

typedef AskarStoreCreateProfileNative = Int32 Function(
  NativeStoreHandle handle,
  Pointer<Utf8> profile,
  Pointer<NativeFunction<AskarStoreCreateProfileCallback>> cb,
  Int64 cb_id,
);

final int Function(
  StoreHandle handle,
  Pointer<Utf8> profile,
  Pointer<NativeFunction<AskarStoreCreateProfileCallback>> cb,
  int cb_id,
) nativeAskarStoreCreateProfile = nativeLib
    .lookup<NativeFunction<AskarStoreCreateProfileNative>>('askar_store_create_profile')
    .asFunction();

typedef AskarStoreGenerateRawKeyNative = Int32 Function(
  NativeByteBuffer seed,
  Pointer<Pointer<Utf8>> out,
);

final int Function(
  NativeByteBuffer seed,
  Pointer<Pointer<Utf8>> out,
) nativeAskarStoreGenerateRawKey = nativeLib
    .lookup<NativeFunction<AskarStoreGenerateRawKeyNative>>(
        'askar_store_generate_raw_key')
    .asFunction();

typedef AskarStoreGetProfileNameCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  Pointer<Utf8> name,
);

typedef AskarStoreGetProfileNameNative = Int32 Function(
  NativeStoreHandle handle,
  Pointer<NativeFunction<AskarStoreGetProfileNameCallback>> cb,
  Int64 cb_id,
);

final int Function(
  int handle,
  Pointer<NativeFunction<AskarStoreGetProfileNameCallback>> cb,
  int cb_id,
) nativeAskarStoreGetProfileName = nativeLib
    .lookup<NativeFunction<AskarStoreGetProfileNameNative>>(
        'askar_store_get_profile_name')
    .asFunction();

typedef AskarStoreGetDefaultProfileCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  Pointer<Utf8> profile,
);

typedef AskarStoreGetDefaultProfileNative = Int32 Function(
  NativeStoreHandle handle,
  Pointer<NativeFunction<AskarStoreGetDefaultProfileCallback>> cb,
  Int64 cb_id,
);

final int Function(
  StoreHandle handle,
  Pointer<NativeFunction<AskarStoreGetDefaultProfileCallback>> cb,
  int cb_id,
) nativeAskarStoreGetDefaultProfile = nativeLib
    .lookup<NativeFunction<AskarStoreGetDefaultProfileNative>>(
        'askar_store_get_default_profile')
    .asFunction();

typedef AskarStoreListProfilesCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  NativeStringListHandle results,
);

typedef AskarStoreListProfilesNative = Int32 Function(
  NativeStoreHandle handle,
  Pointer<NativeFunction<AskarStoreListProfilesCallback>> cb,
  Int64 cb_id,
);

final int Function(
  int handle,
  Pointer<NativeFunction<AskarStoreListProfilesCallback>> cb,
  int cb_id,
) nativeAskarStoreListProfiles = nativeLib
    .lookup<NativeFunction<AskarStoreListProfilesNative>>('askar_store_list_profiles')
    .asFunction();

typedef AskarStoreOpenCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  NativeStoreHandle handle,
);

typedef AskarStoreOpenNative = Int32 Function(
  Pointer<Utf8> spec_uri,
  Pointer<Utf8> key_method,
  Pointer<Utf8> pass_key,
  Pointer<Utf8> profile,
  Pointer<NativeFunction<Void Function(Int64, Int32, NativeStoreHandle)>> cb,
  Int64 cb_id,
);

final int Function(
  Pointer<Utf8> spec_uri,
  Pointer<Utf8> key_method,
  Pointer<Utf8> pass_key,
  Pointer<Utf8> profile,
  Pointer<NativeFunction<Void Function(Int64, Int32, NativeStoreHandle)>> cb,
  int cb_id,
) nativeAskarStoreOpen = nativeLib
    .lookup<NativeFunction<AskarStoreOpenNative>>('askar_store_open')
    .asFunction();

typedef ProvisionCallback = Void Function(
    NativeCallbackId a, Int32 b, NativeStoreHandle c);

typedef AskarStoreProvisionNative = Int32 Function(
  Pointer<Utf8> spec_uri,
  Pointer<Utf8> key_method,
  Pointer<Utf8> pass_key,
  Pointer<Utf8> profile,
  Int8 recreate,
  Pointer<NativeFunction<ProvisionCallback>> cb,
  NativeCallbackId cb_id,
);

final int Function(
  Pointer<Utf8> spec_uri,
  Pointer<Utf8> key_method,
  Pointer<Utf8> pass_key,
  Pointer<Utf8> profile,
  int recreate,
  Pointer<NativeFunction<ProvisionCallback>> cb,
  int cb_id,
) nativeAskarStoreProvision = nativeLib
    .lookup<NativeFunction<AskarStoreProvisionNative>>('askar_store_provision')
    .asFunction();

typedef AskarStoreRekeyCallback = Void Function(
  Int64 cb_id,
  Int32 err,
);

typedef AskarStoreRekeyNative = Int32 Function(
  NativeStoreHandle handle,
  Pointer<Utf8> key_method,
  Pointer<Utf8> pass_key,
  Pointer<NativeFunction<AskarStoreRekeyCallback>> cb,
  Int64 cb_id,
);

final int Function(
  StoreHandle handle,
  Pointer<Utf8> key_method,
  Pointer<Utf8> pass_key,
  Pointer<NativeFunction<AskarStoreRekeyCallback>> cb,
  int cb_id,
) nativeAskarStoreRekey = nativeLib
    .lookup<NativeFunction<AskarStoreRekeyNative>>('askar_store_rekey')
    .asFunction();

typedef AskarStoreRemoveCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  Int8 removed,
);

typedef AskarStoreRemoveNative = Int32 Function(
  Pointer<Utf8> spec_uri,
  Pointer<NativeFunction<AskarStoreRemoveCallback>> cb,
  Int64 cb_id,
);

final int Function(
  Pointer<Utf8> spec_uri,
  Pointer<NativeFunction<AskarStoreRemoveCallback>> cb,
  int cb_id,
) nativeAskarStoreRemove = nativeLib
    .lookup<NativeFunction<AskarStoreRemoveNative>>('askar_store_remove')
    .asFunction();

typedef AskarStoreRemoveProfileCallback = Void Function(
  Int64 cb_id,
  Int32 err,
  Int8 removed,
);

typedef AskarStoreRemoveProfileNative = Int32 Function(
  NativeStoreHandle handle,
  Pointer<Utf8> profile,
  Pointer<NativeFunction<AskarStoreRemoveProfileCallback>> cb,
  Int64 cb_id,
);

final int Function(
  StoreHandle handle,
  Pointer<Utf8> profile,
  Pointer<NativeFunction<AskarStoreRemoveProfileCallback>> cb,
  int cb_id,
) nativeAskarStoreRemoveProfile = nativeLib
    .lookup<NativeFunction<AskarStoreRemoveProfileNative>>('askar_store_remove_profile')
    .asFunction();

typedef AskarStoreSetDefaultProfileCallback = Void Function(
  Int64 cb_id,
  Int32 err,
);

typedef AskarStoreSetDefaultProfileNative = Int32 Function(
  NativeStoreHandle handle,
  Pointer<Utf8> profile,
  Pointer<NativeFunction<AskarStoreSetDefaultProfileCallback>> cb,
  Int64 cb_id,
);

final int Function(
  StoreHandle handle,
  Pointer<Utf8> profile,
  Pointer<NativeFunction<AskarStoreSetDefaultProfileCallback>> cb,
  int cb_id,
) nativeAskarStoreSetDefaultProfile = nativeLib
    .lookup<NativeFunction<AskarStoreSetDefaultProfileNative>>(
        'askar_store_set_default_profile')
    .asFunction();

typedef AskarMigrateIndySdkCallback = Void Function(
  Int64 cb_id,
  Int32 err,
);

typedef AskarMigrateIndySdkNative = Int32 Function(
  Pointer<Utf8> spec_uri,
  Pointer<Utf8> wallet_name,
  Pointer<Utf8> wallet_key,
  Pointer<Utf8> kdf_level,
  Pointer<NativeFunction<AskarMigrateIndySdkCallback>> cb,
  Int64 cb_id,
);

final int Function(
  Pointer<Utf8> spec_uri,
  Pointer<Utf8> wallet_name,
  Pointer<Utf8> wallet_key,
  Pointer<Utf8> kdf_level,
  Pointer<NativeFunction<AskarMigrateIndySdkCallback>> cb,
  int cb_id,
) nativeAskarMigrateIndySdk = nativeLib
    .lookup<NativeFunction<AskarMigrateIndySdkNative>>('askar_migrate_indy_sdk')
    .asFunction();
