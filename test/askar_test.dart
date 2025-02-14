// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:askar_flutter_sdk/askar/askar_callbacks.dart';
import 'package:askar_flutter_sdk/askar/askar_utils.dart';
import 'package:askar_flutter_sdk/askar/askar_wrapper.dart';
import 'package:askar_flutter_sdk/askar/crypto/aead_params.dart';
import 'package:askar_flutter_sdk/askar/crypto/encrypted_buffer.dart';
import 'package:askar_flutter_sdk/askar/crypto/handles.dart';
import 'package:askar_flutter_sdk/askar/enums/askar_entry_operation.dart';
import 'package:askar_flutter_sdk/askar/enums/askar_error_code.dart';
import 'package:askar_flutter_sdk/askar/enums/askar_key_algorithm.dart';
import 'package:askar_flutter_sdk/askar/enums/askar_key_backend.dart';
import 'package:askar_flutter_sdk/askar/enums/askar_key_method.dart';
import 'package:askar_flutter_sdk/askar/enums/askar_signature_algorithm.dart';
import 'package:askar_flutter_sdk/askar/enums/askar_store_key_method.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Askar Tests', () {
    late String storeKey;
    StoreHandle storeHandle = StoreHandle(0);
    SessionHandle sessionHandle = SessionHandle(0);

    bool isStoreOpen() => storeHandle.toInt() != 0;
    bool isSessionOpen() => sessionHandle.toInt() != 0;

    Future<void> closeStoreIfOpen() async {
      if (isStoreOpen()) {
        await storeCloseTest(storeHandle);
        storeHandle = StoreHandle(0);
      }
    }

    Future<void> closeSessionIfOpen() async {
      if (isSessionOpen()) {
        await sessionCloseTest(sessionHandle);
        sessionHandle = SessionHandle(0);
      }
    }

    setUpAll(() async {
      final result = askarVersion();
      print(result);
      expect(result, equals('0.3.2'));

      final generateKeyResult = askarStoreGenerateRawKeyTest();
      storeKey = generateKeyResult.value;

      await storeProvisionTest(profile: 'rekey', passKey: storeKey);

      final storeOpenResult = await storeOpenTest(profile: 'rekey', passKey: storeKey);
      storeHandle = storeOpenResult.value;
    });

    tearDownAll(() async {
      await closeStoreIfOpen();
    });

    setUp(() async {
      final sessionStartResult = await sessionStartTest(storeHandle);
      sessionHandle = sessionStartResult.value;
    });

    tearDown(() async {
      await closeSessionIfOpen();
    });

    test('Generate a random key with and without custom seed', () async {
      askarStoreGenerateRawKeyTest();

      askarStoreGenerateRawKeyTest(seed: utf8.encode("00000000000000000000000000000My1"));
    });

    test('Key From Seed Test', () async {
      final seed1 = utf8.encode("testseed000000000000000000000001");

      final resultKey1None =
          keyFromSeedTest(KeyAlgorithm.bls12381G1, seed1, KeyMethod.none);
      final resultKey2None = keyFromSeedTest(KeyAlgorithm.bls12381G1, seed1);
      final resultKey3Bls =
          keyFromSeedTest(KeyAlgorithm.bls12381G1, seed1, KeyMethod.blsKeygen);
      final resultKey4Bls =
          keyFromSeedTest(KeyAlgorithm.bls12381G1, seed1, KeyMethod.blsKeygen);

      final a1 =
          keyGetJwkThumbprintTest(resultKey1None.value, KeyAlgorithm.bls12381G1).value;
      final a2 =
          keyGetJwkThumbprintTest(resultKey2None.value, KeyAlgorithm.bls12381G1).value;
      final a3 =
          keyGetJwkThumbprintTest(resultKey3Bls.value, KeyAlgorithm.bls12381G1).value;
      final a4 =
          keyGetJwkThumbprintTest(resultKey4Bls.value, KeyAlgorithm.bls12381G1).value;

      expect(a1, equals(a2));
      expect(a3, equals(a4));
    });

    test('Attempt to read from an unexisting category', () async {
      await sessionFetchTest(sessionHandle, expectSuccess: false);
    });

    test('Writing and reading from session', () async {
      String value = 'foobar';
      String name = 'testEntry';
      String category = 'category-one';
      Map<String, String> tags = {'~plaintag': 'a', 'enctag': 'b'};

      await sessionUpdateTest(
          sessionHandle, EntryOperation.insert, value, tags, name, category);

      await sessionCountTest(sessionHandle, category, tags);

      final sessionFetchResult = await sessionFetchTest(sessionHandle);
      final entryListHandle = sessionFetchResult.value;

      entryListGetValueTest(entryListHandle, 0, expectedValue: utf8.encode(value));
      entryListGetTagsTest(entryListHandle, 0, expectedTags: tags);
      entryListGetNameTest(entryListHandle, 0, expectedName: name);
      entryListGetCategoryTest(entryListHandle, 0, expectedCategory: category);

      askarEntryListFree(entryListHandle);

      await closeSessionIfOpen();

      final scanStartResult = await scanStartTest(storeHandle, category, tags);
      await scanNextTest(scanStartResult.value);
      askarScanFree(scanStartResult.value);
    });

    test('Writing, reading and removing all values', () async {
      String value = 'foobar';
      String name = 'testAll';
      String category = 'category-test-all';
      Map<String, String> tags = {'test-all-1': 'a'};

      final insertCount = 5;

      for (int i = 0; i < insertCount; i++) {
        await sessionUpdateTest(
            sessionHandle, EntryOperation.insert, value, tags, "${name}_$i", category);
      }

      // Should find all inserted keys
      final fetchAllResult = await sessionFetchAllTest(sessionHandle, category, tags);
      entryListCountTest(fetchAllResult.value, expectedValue: insertCount);

      // Should remove all keys
      await sessionRemoveAllTest(sessionHandle, category, tags, expected: insertCount);

      // Should find 0 keys
      final fetchAllResult2 = await sessionFetchAllTest(sessionHandle, category, tags);
      entryListCountTest(fetchAllResult2.value, expectedValue: 0);

      askarEntryListFree(fetchAllResult.value);
      askarEntryListFree(fetchAllResult2.value);
    });

    test('Inserting and reading Key', () async {
      String name = 'testEntry2';
      String metadata = 'meta';
      Map<String, String> tags = {'~plaintag': 'a', 'enctag': 'b'};

      final keyGenerateResult = keyGenerateTest(KeyAlgorithm.ed25519);

      final localKeyHandle = keyGenerateResult.value;

      await sessionInsertKeyTest(sessionHandle, localKeyHandle, name, metadata, tags);

      final fetchKeyResult = await sessionFetchKeyTest(sessionHandle, name);
      final keyEntryListHandle = fetchKeyResult.value;

      keyEntryListGetMetadataTest(keyEntryListHandle, 0, metadata);
      keyEntryListGetNameTest(keyEntryListHandle, 0, expectedValue: name);
      keyEntryListGetTagsTest(keyEntryListHandle, 0, expectedValue: tags);
      keyEntryListGetAlgorithmTest(keyEntryListHandle, 0, expected: KeyAlgorithm.ed25519);
      keyEntryListLoadLocalTest(keyEntryListHandle, 0);

      askarKeyEntryListFree(keyEntryListHandle);
      askarKeyFree(localKeyHandle);

      await expectLater(
          () => keyEntryListGetMetadataTest(fetchKeyResult.value, 0, metadata),
          throwsA(isA<Exception>()),
          reason:
              "Trying to read from keyEntryList after freeing should cause an exception");
    });

    test('Inserting and reading all keys', () async {
      String name = 'testAllKeys';
      String metadata = 'meta';
      Map<String, String> tags = {'tag_a': '1', 'tag_b': '2'};

      final algorithm = KeyAlgorithm.ed25519;

      final keyGenerateResult = keyGenerateTest(algorithm);
      final localKeyHandle = keyGenerateResult.value;

      final thumbprintResult = keyGetJwkThumbprintTest(localKeyHandle, algorithm);

      final publicBytes = keyGetPublicBytesTest(localKeyHandle).value;

      keyGetJwkPublicTest(localKeyHandle, algorithm);

      keyGetJwkSecretTest(localKeyHandle);

      keyFromPublicBytesTest(algorithm, publicBytes).value;

      // Início do keyFromKeyExchangeTest
      final convertedAlgorithm = KeyAlgorithm.x25519;
      final convertedKeyHandle = keyConvertTest(localKeyHandle, convertedAlgorithm).value;

      final convertedKeyGenerateResult = keyGenerateTest(convertedAlgorithm);
      final newKeyHandle = convertedKeyGenerateResult.value;
      keyGetAlgorithmTest(newKeyHandle, expected: convertedAlgorithm);

      final exchangeAlgorithm = KeyAlgorithm.chacha20XC20P;
      final exchangedKeyHandle =
          keyFromKeyExchangeTest(exchangeAlgorithm, convertedKeyHandle, newKeyHandle)
              .value;
      keyGetAlgorithmTest(exchangedKeyHandle, expected: exchangeAlgorithm);
      // Fim do keyFromKeyExchangeTest

      await sessionInsertKeyTest(
          sessionHandle, localKeyHandle, '${name}_1', metadata, tags);

      await sessionInsertKeyTest(
          sessionHandle, localKeyHandle, '${name}_2', metadata, tags);

      await sessionInsertKeyTest(
          sessionHandle, localKeyHandle, '${name}_3', metadata, tags);

      final fetchKeyResult = await sessionFetchAllKeysTest(
          sessionHandle, algorithm, thumbprintResult.value, tags);

      final KeyEntryListHandle keyEntryListHandle = fetchKeyResult.value;

      keyEntryListCountTest(keyEntryListHandle, expectedValue: 3);

      askarKeyEntryListFree(keyEntryListHandle);

      askarKeyFree(localKeyHandle);
      askarKeyFree(newKeyHandle);
    });

    test('Sign Message and Verify Signature', () async {
      final keyGenerateResult = keyGenerateTest(KeyAlgorithm.ed25519);

      final localKeyHandle = keyGenerateResult.value;

      keyGetAlgorithmTest(localKeyHandle, expected: KeyAlgorithm.ed25519);

      final message = utf8.encode("This is a message!");
      final otherMessage = utf8.encode("This is another message!");

      final signAlgorithm = SignatureAlgorithm.edDSA;

      final signResult = keySignMessageTest(localKeyHandle, message, signAlgorithm);

      keyVerifySignatureTest(localKeyHandle, message, signResult.value, signAlgorithm);

      keyVerifySignatureTest(
          localKeyHandle, otherMessage, signResult.value, signAlgorithm,
          expectSuccess: false);

      askarKeyFree(localKeyHandle);
    });

    test('Crypto Box', () async {
      final recipKey = keyGenerateTest(KeyAlgorithm.x25519).value;
      final senderKey = keyGenerateTest(KeyAlgorithm.x25519).value;

      final nonce = keyCryptoBoxRandomNonceTest().value;

      final message = utf8.encode("foobar");

      final messageEncrypted = keyCryptoBoxTest(recipKey, senderKey, message, nonce);

      keyCryptoBoxOpenTest(recipKey, senderKey, messageEncrypted.value, nonce);

      askarKeyFree(recipKey);
      askarKeyFree(senderKey);
    });

    test('Askar Key Wrap and Unwrap', () async {
      Map<String, String> ephemeralJwk = {
        'crv': 'X25519',
        'kty': 'OKP',
        'd': 'x8EVZH4Fwk673_mUujnliJoSrLz0zYzzCWp5GUX2fc8',
        'x': 'k9of_cpAajy0poW5gaixXGs9nHkwg1AFqUAFa39dyBc',
      };

      Map<String, String> aliceJwk = {
        'crv': 'X25519',
        'kty': 'OKP',
        'd': 'i9KuFhSzEBsiv3PKVL5115OCdsqQai5nj_Flzfkw5jU',
        'x': 'Knbm_BcdQr7WIoz-uqit9M0wbcfEr6y-9UfIZ8QnBD4',
      };

      Map<String, String> bobJwk = {
        'crv': 'X25519',
        'kty': 'OKP',
        'd': '1gDirl_r_Y3-qUa3WXHgEXrrEHngWThU3c9zj9A2uBg',
        'x': 'BT7aR0ItXfeDAldeeOlXL_wXqp-j5FltT0vRSG16kRw',
      };

      final ephemeral = keyFromJwkTest(jsonEncode(ephemeralJwk)).value;
      final alice = keyFromJwkTest(jsonEncode(aliceJwk)).value;
      final bob = keyFromJwkTest(jsonEncode(bobJwk)).value;

      final alg = "ECDH-1PU+A128KW";
      final apu = "Alice";
      final apv = "Bob and Charlie";

      final base64urlApu = toBase64Url(utf8.encode(apu));
      final base64urlApv = toBase64Url(utf8.encode(apv));

      expect(base64urlApu, equals('QWxpY2U'));
      expect(base64urlApv, equals('Qm9iIGFuZCBDaGFybGll'));

      Map<String, dynamic> protectedJson = {
        'alg': 'ECDH-1PU+A128KW',
        'enc': 'A256CBC-HS512',
        'apu': 'QWxpY2U',
        'apv': 'Qm9iIGFuZCBDaGFybGll',
        'epk': {
          'kty': 'OKP',
          'crv': 'X25519',
          'x': 'k9of_cpAajy0poW5gaixXGs9nHkwg1AFqUAFa39dyBc'
        },
      };

      final protectedB64 = toBase64Url(utf8.encode(jsonEncode(protectedJson)));
      final protectedB64Bytes = utf8.encode(protectedB64);

      final cek = keyFromSecretBytesTest(
              KeyAlgorithm.aesA256CbcHs512,
              Uint8List.fromList(hex.decode(
                  'fffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0dfdedddcdbdad9d8d7d6d5d4d3d2d1d0cfcecdcccbcac9c8c7c6c5c4c3c2c1c0')))
          .value;

      final iv =
          Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);

      final message = utf8.encode('Three is a magic number.');

      final enc =
          keyAeadEncryptTest(cek, message, nonce: iv, aad: protectedB64Bytes).value;

      final ciphertext = enc.ciphertext;
      final ccTag = enc.tag;

      expect(
          toBase64Url(ciphertext), equals('Az2IWsISEMDJvyc5XRL-3-d-RgNBOGolCsxFFoUXFYw'));

      expect(toBase64Url(ccTag), equals('HLb4fTlm8spGmij3RyOs2gJ4DpHM4hhVRwdF_hGb3WQ'));

      expect(toBase64Url(enc.nonce), equals('AAECAwQFBgcICQoLDA0ODw'));

      final derived = keyDeriveEcdh1puTest(KeyAlgorithm.aesA128Kw, ephemeral, alice, bob,
              utf8.encode(alg), utf8.encode(apu), utf8.encode(apv), ccTag,
              receive: false)
          .value;

      keyGetSecretBytesTest(derived,
          expected: Uint8List.fromList(hex.decode('df4c37a0668306a11e3d6b0074b5d8df')));

      final encryptedKey = keyWrapKeyTest(derived, cek).value.buffer;

      final expectedEncryptedKey = base64Url.decode(
          "pOMVA9_PtoRe7xXW1139NzzN1UhiFoio8lGto9cf0t8PyU-sjNXH8-LIRLycq8CHJQbDwvQeU1cSl55cQ0hGezJu2N9IY0QN");

      expect(encryptedKey, equals(expectedEncryptedKey));

      final derivedReceiver = keyDeriveEcdh1puTest(KeyAlgorithm.aesA128Kw, ephemeral,
              alice, bob, utf8.encode(alg), utf8.encode(apu), utf8.encode(apv), ccTag,
              receive: true)
          .value;

      keyUnwrapKeyTest(derivedReceiver, KeyAlgorithm.aesA256CbcHs512, encryptedKey);

      askarKeyFree(cek);
      askarKeyFree(alice);
      askarKeyFree(bob);
    });

    test('Get Key From Secret Bytes', () async {
      final secret = Uint8List.fromList(hex.decode(
          'fffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0dfdedddcdbdad9d8d7d6d5d4d3d2d1d0cfcecdcccbcac9c8c7c6c5c4c3c2c1c0'));

      final keyFromSecretBytesResult =
          keyFromSecretBytesTest(KeyAlgorithm.aesA256CbcHs512, secret);

      final localKeyHandle = keyFromSecretBytesResult.value;

      keyGetAlgorithmTest(localKeyHandle, expected: KeyAlgorithm.aesA256CbcHs512);

      keyGetSecretBytesTest(localKeyHandle, expected: secret);
    });

    test('Removing Key', () async {
      final keyGenerateResult = keyGenerateTest(KeyAlgorithm.ed25519);
      final localKeyHandle = keyGenerateResult.value;
      String name = 'testEntry3';
      String metadata = 'meta';
      Map<String, String> tags = {'~plaintag': 'a', 'enctag': 'b'};

      await sessionInsertKeyTest(sessionHandle, localKeyHandle, name, metadata, tags);

      final fetchKeyResult =
          await sessionFetchKeyTest(sessionHandle, name, expectSuccess: true);

      await sessionRemoveKeyTest(sessionHandle, name);

      await sessionFetchKeyTest(sessionHandle, name, expectSuccess: false);

      keyEntryListCountTest(fetchKeyResult.value, expectedValue: 0);

      askarKeyEntryListFree(fetchKeyResult.value);
      askarKeyFree(localKeyHandle);
    });
    test('Store Get Default Profile', () async {
      String defaultProfile = 'rekey';
      await storeGetDefaultProfileTest(storeHandle, expectedValue: defaultProfile);
    });

    test('Get Supported Backends', () async {
      final supportedBackendsResult = getSupportedBackendsTest();
      final stringListHandle = supportedBackendsResult.value;

      stringListCountTest(stringListHandle, expectGreaterThan: 0);

      stringListGetItemTest(stringListHandle, 0, expected: KeyBackend.software.value);

      askarStringListFree(stringListHandle);
    });

    test('Key Get Ephemeral', () async {
      final keyGenerateResult = keyGenerateTest(KeyAlgorithm.ed25519);
      final localKeyHandle = keyGenerateResult.value;
      keyGetEphemeralTest(localKeyHandle, false);

      final keyGenerateResult2 = keyGenerateTest(KeyAlgorithm.ed25519, ephemeral: true);
      final localKeyHandle2 = keyGenerateResult2.value;
      keyGetEphemeralTest(localKeyHandle2, true);
    });
  });

  group('Store Profile Tests:', () {
    late StoreHandle storeHandle;
    late String storeKey;
    test('Store Create and Remove Profile', () async {
      final generateKeyResult = askarStoreGenerateRawKeyTest();
      storeKey = generateKeyResult.value;

      await storeProvisionTest(profile: 'rekey', passKey: storeKey);

      final storeOpenResult = await storeOpenTest(profile: 'rekey', passKey: storeKey);
      storeHandle = storeOpenResult.value;

      String profile = 'tenant-b2f768c6-d53b-40ab-8e74-8e4ea50a3d3e';

      await storeCreateProfileTest(storeHandle, profile, expectedValue: profile);

      await askarStoreListProfilesTest(storeHandle);

      await storeRemoveTest();

      await storeRemoveProfileTest(storeHandle, profile);

      await storeCloseTest(storeHandle);
    });

    test('Store Set Default Profile', () async {
      final generateKeyResult = askarStoreGenerateRawKeyTest();
      storeKey = generateKeyResult.value;

      await storeProvisionTest(profile: 'rekey', passKey: storeKey);

      final storeOpenResult = await storeOpenTest(profile: 'rekey', passKey: storeKey);
      storeHandle = storeOpenResult.value;

      String newDefaultProfile = 'rekey2';

      await storeSetDefaultProfileTest(storeHandle, newDefaultProfile);
      await storeGetDefaultProfileTest(storeHandle, expectedValue: newDefaultProfile);

      await storeCloseTest(storeHandle);
    });
  });

  group('Aead Encryption Tests:', () {
    test('Encryption with and without nonce and aad', () {
      final keyGenerateResult = keyGenerateTest(KeyAlgorithm.aesA256Gcm);

      final localKeyHandle = keyGenerateResult.value;

      final message = Uint8List(4);
      final nonce = askarKeyAeadRandomNonce(localKeyHandle);
      final aad = Uint8List(0);

      keyAeadEncryptTest(localKeyHandle, message, nonce: nonce.value, aad: aad);
      keyAeadEncryptTest(localKeyHandle, message);

      askarKeyFree(localKeyHandle);
    });
  });

  group('Key Aead Decryption Tests:', () {
    test('Decryption with and without aad', () {
      final keyGenerateResult = keyGenerateTest(KeyAlgorithm.aesA256Gcm);
      final localKeyHandle = keyGenerateResult.value;
      final nonce = askarKeyAeadRandomNonce(localKeyHandle);
      final aad = Uint8List(0);
      final Uint8List message = Uint8List.fromList([1, 2, 3, 4]);

      final encryptedBuffer = askarKeyAeadEncrypt(
        localKeyHandle,
        message,
        nonce: nonce.value,
      );

      keyAeadDecryptTest(localKeyHandle, encryptedBuffer.value.ciphertext, nonce.value,
          tag: encryptedBuffer.value.tag, aad: aad, expected: message);
      keyAeadDecryptTest(localKeyHandle, encryptedBuffer.value.ciphertext, nonce.value,
          tag: encryptedBuffer.value.tag, expected: message);

      askarKeyFree(localKeyHandle);
    });
  });

  group('Crypto Box Seal Tests:', () {
    test('Crypto Box Seal', () {
      final keyGenerateResult = keyGenerateTest(KeyAlgorithm.x25519);

      final localKeyHandle = keyGenerateResult.value;

      final Uint8List message = Uint8List.fromList([1, 2, 3, 4]);

      final sealed = keyCryptoBoxSealTest(localKeyHandle, message);

      final opened = keyCryptoBoxSealOpenTest(localKeyHandle, sealed.value);

      expect(opened.value, equals(message));

      askarKeyFree(localKeyHandle);
    });
  });

  group('Without Optional Params:', () {
    test('Store Provision and Open', () async {
      final storeProvisionKey = (await storeProvisionTest()).value;

      final storeOpenKey = (await storeOpenTest()).value;

      storeCloseTest(storeProvisionKey);
      storeCloseTest(storeOpenKey);
    });
  });
}

AskarResult<bool> keyGetEphemeralTest(LocalKeyHandle handle,
    [bool expectedValue = false]) {
  final result = askarKeyGetEphemeral(handle);
  printAskarResult('KeyGetEphemeral', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, expectedValue);

  return result;
}

AskarResult<LocalKeyHandle> keyConvertTest(
    LocalKeyHandle handle, KeyAlgorithm algorithm) {
  final result = askarKeyConvert(handle, algorithm);

  printAskarResult('KeyConvert', result);

  expect(result.errorCode, equals(ErrorCode.success));

  return result;
}

AskarResult<EncryptedBuffer> keyAeadEncryptTest(LocalKeyHandle handle, Uint8List message,
    {Uint8List? nonce, Uint8List? aad}) {
  final result = askarKeyAeadEncrypt(handle, message, nonce: nonce, aad: aad);

  printAskarResult('KeyAeadEncrypt', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.buffer.isNotEmpty, equals(true));
  expect(result.value.noncePos, greaterThan(0));
  expect(result.value.tagPos, greaterThan(0));

  return result;
}

AskarResult<Uint8List> keyAeadDecryptTest(
  LocalKeyHandle handle,
  Uint8List ciphertext,
  Uint8List nonce, {
  Uint8List? tag,
  Uint8List? aad,
  required Uint8List expected,
}) {
  final result = askarKeyAeadDecrypt(handle, ciphertext, nonce, tag: tag, aad: aad);

  printAskarResult('KeyAeadDecrypt', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, equals(expected));

  return result;
}

AskarResult<AeadParams> keyAeadGetParamsTest(LocalKeyHandle handle) {
  final result = askarKeyAeadGetParams(handle);

  printAskarResult('KeyAeadGetParamsTest', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.tagLength, greaterThan(0));
  expect(result.value.nonceLength, greaterThan(0));

  return result;
}

Future<AskarResult<StoreHandle>> storeProvisionTest(
    {String? passKey, String? profile}) async {
  final String specUri = 'sqlite://storage.db';

  final result = await askarStoreProvision(
    specUri,
    keyMethod: StoreKeyMethod.argon2IMod,
    passKey: passKey,
    profile: profile,
    recreate: true,
  );

  printAskarResult('StoreProvision', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

Future<AskarResult<StoreHandle>> storeOpenTest({String? passKey, String? profile}) async {
  final String specUri = 'sqlite://storage.db';

  final result = await askarStoreOpen(
    specUri,
    keyMethod: StoreKeyMethod.argon2IMod,
    passKey: passKey,
    profile: profile,
  );

  printAskarResult('StoreOpen', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

Future<AskarResult<ScanHandle>> scanStartTest(
    StoreHandle handle, String category, Map tagFilter) async {
  final String profile = 'rekey';
  final int offset = 0;
  final int limit = 2;

  final result = await askarScanStart(
    handle,
    profile: profile,
    category: category,
    tagFilter: tagFilter,
    offset: offset,
    limit: limit,
  );

  printAskarResult('ScanStart', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

Future<AskarResult<EntryListHandle>> scanNextTest(
  ScanHandle handle,
) async {
  final result = await askarScanNext(handle);

  printAskarResult('ScanNext', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

Future<AskarResult<SessionHandle>> sessionStartTest(StoreHandle handle) async {
  final result = await askarSessionStart(handle, profile: 'rekey', asTransaction: true);

  printAskarResult('SessionStart', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

AskarResult<LocalKeyHandle> keyGenerateTest(KeyAlgorithm algorithm,
    {KeyBackend keyBackend = KeyBackend.software, bool ephemeral = false}) {
  final result = askarKeyGenerate(algorithm, keyBackend, ephemeral);

  printAskarResult('KeyGenerate', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

AskarResult<String> keyGetJwkPublicTest(LocalKeyHandle handle, KeyAlgorithm algorithm) {
  final result = askarKeyGetJwkPublic(handle, algorithm);

  printAskarResult('KeyGetJwkPublic', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.isNotEmpty, equals(true));

  return result;
}

AskarResult<Uint8List> keyGetJwkSecretTest(LocalKeyHandle handle) {
  final result = askarKeyGetJwkSecret(handle);

  printAskarResult('KeyGetJwkSecret', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.isNotEmpty, equals(true));

  return result;
}

AskarResult<LocalKeyHandle> keyFromJwkTest(String jwk) {
  final result = askarKeyFromJwk(jwk);

  printAskarResult('KeyFromJwk', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, isNot(0));

  return result;
}

AskarResult<Uint8List> keyAeadRandomNonceTest(LocalKeyHandle handle) {
  final result = askarKeyAeadRandomNonce(handle);

  printAskarResult('KeyAeadRandomNonce', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.isNotEmpty, equals(true));

  return result;
}

AskarResult<EncryptedBuffer> keyWrapKeyTest(LocalKeyHandle handle, LocalKeyHandle other,
    {Uint8List? nonce}) {
  print('$handle, $other, $nonce');

  final result = askarKeyWrapKey(handle, other, nonce: nonce);

  printAskarResult('KeyWrapKey', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.buffer.isNotEmpty, equals(true));
  expect(result.value.noncePos, greaterThan(0));
  expect(result.value.tagPos, greaterThan(0));

  return result;
}

AskarResult<LocalKeyHandle> keyUnwrapKeyTest(
    LocalKeyHandle handle, KeyAlgorithm algorithm, Uint8List ciphertext,
    {Uint8List? nonce, Uint8List? tag}) {
  print(
      'handle $handle, algorithm $algorithm, ciphertext $ciphertext, nonce $nonce, tag $tag');

  final result = askarKeyUnwrapKey(handle, algorithm, ciphertext, nonce: nonce, tag: tag);

  printAskarResult('KeyUnwrapKey', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

AskarResult<LocalKeyHandle> keyDeriveEcdhEsTest(
    KeyAlgorithm algorithm,
    LocalKeyHandle ephemeralKey,
    LocalKeyHandle recipientKey,
    Uint8List algId,
    Uint8List apu,
    Uint8List apv,
    {required bool receive}) {
  final result = askarKeyDeriveEcdhEs(
      algorithm, ephemeralKey, recipientKey, algId, apu, apv, receive);

  printAskarResult('KeyDeriveEcdhEs', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, greaterThan(0));

  return result;
}

AskarResult<LocalKeyHandle> keyDeriveEcdh1puTest(
    KeyAlgorithm algorithm,
    LocalKeyHandle ephemeralKey,
    LocalKeyHandle senderKey,
    LocalKeyHandle recipientKey,
    Uint8List algId,
    Uint8List apu,
    Uint8List apv,
    Uint8List ccTag,
    {required bool receive}) {
  final result = askarKeyDeriveEcdh1pu(
      algorithm, ephemeralKey, senderKey, recipientKey, algId, apu, apv,
      ccTag: ccTag, receive: receive);

  printAskarResult('KeyDeriveEcdh1pu', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

AskarResult<String> keyGetJwkThumbprintTest(
    LocalKeyHandle handle, KeyAlgorithm algorithm) {
  final result = askarKeyGetJwkThumbprint(handle, algorithm);

  printAskarResult('KeyGetJwkThumbprint', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.isNotEmpty, equals(true));

  return result;
}

AskarResult<String> keyGetAlgorithmTest(LocalKeyHandle handle,
    {required KeyAlgorithm expected}) {
  final result = askarKeyGetAlgorithm(handle);

  printAskarResult('KeyGetAlgorithm', result);
  expect(result.errorCode, ErrorCode.success);
  expect(result.value, expected.value);

  return result;
}

AskarResult<Uint8List> keyGetSecretBytesTest(LocalKeyHandle handle,
    {required Uint8List expected}) {
  final result = askarKeyGetSecretBytes(handle);

  printAskarResult('KeyGetSecretBytes', result);
  expect(result.errorCode, ErrorCode.success);
  expect(result.value, expected);

  return result;
}

AskarResult<Uint8List> keyGetPublicBytesTest(LocalKeyHandle handle) {
  final result = askarKeyGetPublicBytes(handle);

  printAskarResult('KeyGetPublicBytes', result);
  expect(result.errorCode, ErrorCode.success);
  expect(result.value.isNotEmpty, equals(true));

  return result;
}

AskarResult<String> keyEntryListGetNameTest(KeyEntryListHandle handle, int index,
    {required String expectedValue}) {
  final result = askarKeyEntryListGetName(handle, index);

  printAskarResult('KeyEntryListGetName', result);
  expect(result.errorCode, ErrorCode.success);
  expect(result.value, expectedValue);

  return result;
}

AskarResult<Map> keyEntryListGetTagsTest(KeyEntryListHandle handle, int index,
    {required Map<dynamic, dynamic> expectedValue}) {
  final result = askarKeyEntryListGetTags(handle, index);

  final value = jsonDecode(result.value);

  printAskarResult('KeyEntryListGetTags', result);
  expect(result.errorCode, ErrorCode.success);
  expect(value, expectedValue);

  return AskarResult(result.errorCode, value);
}

AskarResult<String> keyEntryListGetAlgorithmTest(KeyEntryListHandle handle, int index,
    {required KeyAlgorithm expected}) {
  final result = askarKeyEntryListGetAlgorithm(handle, index);

  printAskarResult('KeyEntryListGetAlgorithm', result);
  expect(result.errorCode, ErrorCode.success);
  expect(result.value, expected.value);

  return result;
}

AskarResult<int> entryListCountTest(EntryListHandle handle,
    {required int expectedValue}) {
  final result = askarEntryListCount(handle);

  printAskarResult('EntryListCount', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, equals(expectedValue));

  return result;
}

AskarResult<int> keyEntryListCountTest(KeyEntryListHandle handle,
    {required int expectedValue}) {
  final result = askarKeyEntryListCount(handle);

  printAskarResult('KeyEntryListCount', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, equals(expectedValue));

  return result;
}

Future<AskarCallbackResult> sessionInsertKeyTest(
    SessionHandle sessionHandle,
    LocalKeyHandle localKeyHandle,
    String name,
    String metadata,
    Map<String, String> tags) async {
  int expiryMs = 2000;

  final result = await askarSessionInsertKey(
    sessionHandle,
    localKeyHandle,
    name,
    metadata: metadata,
    tags: tags,
    expiryMs: expiryMs,
  );

  printAskarResult('SessionInsertKey', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

Future<AskarCallbackResult> sessionRemoveKeyTest(
    SessionHandle handle, String name) async {
  final result = await askarSessionRemoveKey(handle, name);

  printAskarResult('SessionRemoveKey', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

Future<AskarResult<int>> sessionCountTest(
    SessionHandle handle, String category, Map<String, String> tagFilter) async {
  final result = await askarSessionCount(handle, category, tagFilter: tagFilter);

  printAskarResult('SessionCount', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, greaterThan(0));

  return result;
}

Future<AskarResult<KeyEntryListHandle>> sessionFetchKeyTest(
    SessionHandle handle, String name,
    {bool expectSuccess = true}) async {
  bool forUpdate = false;

  final result = await askarSessionFetchKey(handle, name, forUpdate);

  printAskarResult('SessionFetchKey', result);

  expect(result.errorCode, equals(ErrorCode.success));

  if (expectSuccess) {
    expect(result.value.toInt(), greaterThan(0));
  } else {
    expect(result.value.toInt(), equals(0));
  }

  return result;
}

Future<AskarResult<EntryListHandle>> sessionFetchAllTest(
  SessionHandle handle,
  String category,
  Map tagFilter,
) async {
  int limit = 10;
  bool forUpdate = false;

  final result = await askarSessionFetchAll(
    handle,
    category,
    forUpdate: forUpdate,
    tagFilter: tagFilter,
    limit: limit,
  );

  printAskarResult('SessionFetchAll', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

Future<AskarResult<KeyEntryListHandle>> sessionFetchAllKeysTest(SessionHandle handle,
    KeyAlgorithm algorithm, String thumbprint, Map tagFilter) async {
  int limit = 10;
  bool forUpdate = false;

  final result = await askarSessionFetchAllKeys(
    handle,
    forUpdate: forUpdate,
    algorithm: algorithm,
    thumbprint: thumbprint,
    tagFilter: tagFilter,
    limit: limit,
  );

  printAskarResult('SessionFetchAllKeys', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

AskarResult<String> keyEntryListGetMetadataTest(
    KeyEntryListHandle handle, int index, String expectedMetadata) {
  final result = askarKeyEntryListGetMetadata(handle, index);

  printAskarResult('KeyEntryListGetMetadata', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, equals(expectedMetadata));

  return result;
}

Future<AskarCallbackResult> sessionUpdateTest(
    SessionHandle handle,
    EntryOperation operation,
    String value,
    Map<String, String> tags,
    String name,
    String category) async {
  int expiryMs = 2000;

  final result = await askarSessionUpdate(
    handle,
    operation,
    category,
    name,
    value: value,
    tags: tags,
    expiryMs: expiryMs,
  );

  printAskarResult('SessionUpdate', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

Future<AskarCallbackResult> sessionRemoveAllTest(
    SessionHandle handle, String category, Map<String, String> tags,
    {required int expected}) async {
  final result = await askarSessionRemoveAll(handle, category, tagFilter: tags);

  printAskarResult('SessionRemoveAll', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));
  expect(result.value, equals(expected));

  return result;
}

Future<AskarResult<EntryListHandle>> sessionFetchTest(SessionHandle handle,
    {bool expectSuccess = true}) async {
  String category = 'category-one';
  String name = 'testEntry';
  bool forUpdate = false;

  AskarResult<EntryListHandle> result =
      AskarResult<EntryListHandle>(ErrorCode.custom, EntryListHandle(0));

  if (expectSuccess) {
    result = await askarSessionFetch(handle, category, name, forUpdate);
    expect(result.errorCode, equals(ErrorCode.success));
    expect(result.value.toInt(), isNot(0));
  } else {
    await expectLater(
      () async => {result = await askarSessionFetch(handle, category, name, forUpdate)},
      throwsA(isA<Exception>()),
    );
  }

  printAskarResult('SessionFetch', result);

  return result;
}

AskarResult<Uint8List> entryListGetValueTest(EntryListHandle handle, int index,
    {required Uint8List expectedValue}) {
  final result = askarEntryListGetValue(handle, index);

  printAskarResult('EntryListGetValue', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, equals(expectedValue));

  return result;
}

AskarResult<Map> entryListGetTagsTest(EntryListHandle handle, int index,
    {required Map expectedTags}) {
  final result = askarEntryListGetTags(handle, index);

  final value = jsonDecode(result.value);

  printAskarResult('EntryListGetTags', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(value, equals(expectedTags));

  return AskarResult(result.errorCode, value);
}

AskarResult<String> entryListGetNameTest(EntryListHandle handle, int index,
    {required String expectedName}) {
  final result = askarEntryListGetName(handle, index);

  printAskarResult('EntryListGetName', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, equals(expectedName));

  return result;
}

AskarResult<String> entryListGetCategoryTest(EntryListHandle handle, int index,
    {required String expectedCategory}) {
  final result = askarEntryListGetCategory(handle, index);

  printAskarResult('EntryListGetCategory', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, equals(expectedCategory));

  return result;
}

AskarResult<LocalKeyHandle> keyEntryListLoadLocalTest(
    KeyEntryListHandle handle, int index) {
  final result = askarKeyEntryListLoadLocal(handle, index);

  printAskarResult('KeyEntryListLoadLocal', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

AskarResult<String> askarStoreGenerateRawKeyTest({Uint8List? seed}) {
  final result = askarStoreGenerateRawKey(seed: seed);

  printAskarResult('StoreGenerateRawKey', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.isNotEmpty, true);

  return result;
}

AskarResult<Uint8List> keySignMessageTest(
    LocalKeyHandle handle, Uint8List message, SignatureAlgorithm sigType) {
  final result = askarKeySignMessage(handle, message, sigType);

  printAskarResult('KeySignMessage', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, isNot(message));

  return result;
}

AskarResult<bool> keyVerifySignatureTest(LocalKeyHandle handle, Uint8List message,
    Uint8List signature, SignatureAlgorithm sigType,
    {bool expectSuccess = true}) {
  final result = askarKeyVerifySignature(handle, message, signature, sigType);

  printAskarResult('KeyVerifySignature', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, equals(expectSuccess));

  return result;
}

AskarResult<LocalKeyHandle> keyFromSecretBytesTest(
    KeyAlgorithm algorithm, Uint8List secret) {
  final result = askarKeyFromSecretBytes(algorithm, secret);

  printAskarResult('KeyFromSecretBytes', result);

  expect(result.errorCode, ErrorCode.success);
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

AskarResult<LocalKeyHandle> keyFromPublicBytesTest(
    KeyAlgorithm algorithm, Uint8List secret) {
  final result = askarKeyFromPublicBytes(algorithm, secret);

  printAskarResult('KeyFromPublicBytes', result);

  expect(result.errorCode, ErrorCode.success);
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

AskarResult<LocalKeyHandle> keyFromKeyExchangeTest(
  KeyAlgorithm algorithm,
  LocalKeyHandle secretKeyHandle,
  LocalKeyHandle publicKeyHandle,
) {
  final result = askarKeyFromKeyExchange(algorithm, secretKeyHandle, publicKeyHandle);
  printAskarResult('KeyFromKeyExchange', result);

  expect(result.errorCode, ErrorCode.success);
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

AskarResult<LocalKeyHandle> keyFromSeedTest(KeyAlgorithm algorithm, Uint8List seed,
    [KeyMethod method = KeyMethod.none]) {
  final result = askarKeyFromSeed(algorithm, seed, method);
  printAskarResult('KeyFromSeed', result);

  expect(result.errorCode, ErrorCode.success);
  expect(result.value.toInt(), greaterThan(0));

  return result;
}

Future<AskarCallbackBlankResult> sessionCloseTest(SessionHandle handle) async {
  final result = await askarSessionClose(handle, true);

  printAskarResult('SessionClose', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

Future<AskarCallbackResult> storeRemoveTest() async {

  final String specUri = 'sqlite://storage.db';
  final result = await askarStoreRemove(specUri);

  printAskarResult('StoreRemove', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));
  expect(intToBool(result.value), equals(true));

  return result;
}

Future<AskarCallbackResult> storeRemoveProfileTest(
    StoreHandle handle, String profile) async {
  final result = await askarStoreRemoveProfile(handle, profile);

  printAskarResult('StoreRemoveProfile', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));
  expect(intToBool(result.value), equals(true));

  return result;
}

Future<AskarCallbackResult> storeCloseTest(StoreHandle handle) async {
  final result = await askarStoreClose(handle);

  printAskarResult('StoreClose', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

AskarResult<StringListHandle> getSupportedBackendsTest() {
  final result = askarKeyGetSupportedBackends();

  printAskarResult('GetSupportedBackends', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, greaterThan(0));

  return result;
}

AskarResult<int> stringListCountTest(StringListHandle handle,
    {required int expectGreaterThan}) {
  final result = askarStringListCount(handle);

  printAskarResult('StringListCount', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, greaterThan(expectGreaterThan));

  return result;
}

AskarResult<String> stringListGetItemTest(StringListHandle handle, int index,
    {required String expected}) {
  final result = askarStringListGetItem(handle, index);

  printAskarResult('StringListGetItem', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, equals(expected));

  return result;
}

Future<AskarCallbackResult> storeCreateProfileTest(StoreHandle handle, String profile,
    {required String expectedValue}) async {
  final result = await askarStoreCreateProfile(handle, profile: profile);

  printAskarResult('StoreCreateProfile', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));
  expect(result.value, equals(expectedValue));

  return result;
}

Future<AskarResult<StringListHandle>> askarStoreListProfilesTest(
    StoreHandle handle) async {
  final result = await askarStoreListProfiles(handle);

  printAskarResult('StoreListProfiles', result);

  expect(result.errorCode, equals(ErrorCode.success));

  return result;
}

Future<AskarCallbackResult> storeGetDefaultProfileTest(StoreHandle handle,
    {required String expectedValue}) async {
  final result = await askarStoreGetDefaultProfile(handle);

  printAskarResult('StoreGetDefaultProfile', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));
  expect(result.value, equals(expectedValue));

  return result;
}

Future<AskarCallbackBlankResult> storeSetDefaultProfileTest(
    StoreHandle handle, String profile) async {
  final result = await askarStoreSetDefaultProfile(handle, profile);

  printAskarResult('StoreSetDefaultProfile', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

AskarResult<Uint8List> keyCryptoBoxTest(
  LocalKeyHandle recipKey,
  LocalKeyHandle senderKey,
  Uint8List message,
  Uint8List nonce,
) {
  final result = askarKeyCryptoBox(recipKey, senderKey, message, nonce);

  printAskarResult('KeyCryptoBox', result);
  expect(result.errorCode, ErrorCode.success);
  expect(result.value.isNotEmpty, equals(true));

  return result;
}

AskarResult<Uint8List> keyCryptoBoxOpenTest(LocalKeyHandle recipKey,
    LocalKeyHandle senderKey, Uint8List message, Uint8List nonce) {
  final result = askarKeyCryptoBoxOpen(recipKey, senderKey, message, nonce);

  printAskarResult('KeyCryptoBoxOpen', result);
  expect(result.errorCode, ErrorCode.success);
  expect(result.value.isNotEmpty, equals(true));

  return result;
}

AskarResult<Uint8List> keyCryptoBoxSealTest(LocalKeyHandle handle, Uint8List message) {
  final result = askarKeyCryptoBoxSeal(handle, message);

  printAskarResult('KeyCryptoBoxSeal', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.isNotEmpty, equals(true));

  return result;
}

AskarResult<Uint8List> keyCryptoBoxSealOpenTest(
    LocalKeyHandle handle, Uint8List ciphertext) {
  final result = askarKeyCryptoBoxSealOpen(handle, ciphertext);

  printAskarResult('KeyCryptoBoxSealOpen', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.isNotEmpty, equals(true));

  return result;
}

AskarResult<Uint8List> keyCryptoBoxRandomNonceTest() {
  final result = askarKeyCryptoBoxRandomNonce();

  printAskarResult('KeyCryptoBoxRandomNonce', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.isNotEmpty, equals(true));

  return result;
}

String toBase64Url(Uint8List data) {
  return base64Url.encode(data).replaceAll('=', '');
}

Uint8List fromBase64Url(String base64UrlString) {
  // Add padding if necessary
  String normalized = base64UrlString.replaceAll('-', '+').replaceAll('_', '/');
  switch (normalized.length % 4) {
    case 2:
      normalized += '==';
      break;
    case 3:
      normalized += '=';
      break;
  }
  return base64.decode(normalized);
}

void printAskarResult(String test, dynamic result) {
  print('$test: $result\n');
}
