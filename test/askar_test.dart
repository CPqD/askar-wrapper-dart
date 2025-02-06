// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:import_so_libaskar/askar/askar_callbacks.dart';
import 'package:import_so_libaskar/askar/askar_wrapper.dart';
import 'package:import_so_libaskar/askar/enums/askar_entry_operation.dart';
import 'package:import_so_libaskar/askar/enums/askar_error_code.dart';
import 'package:import_so_libaskar/askar/enums/askar_key_algorithm.dart';
import 'package:import_so_libaskar/askar/enums/askar_key_backend.dart';
import 'package:import_so_libaskar/askar/enums/askar_signature_algorithm.dart';
import 'package:import_so_libaskar/askar/enums/askar_store_key_method.dart';

void main() {
  group('Askar Tests', () {
    late String storeKey;
    StoreHandle storeHandle = 0;
    SessionHandle sessionHandle = 0;

    bool isStoreOpen() => storeHandle != 0;
    bool isSessionOpen() => sessionHandle != 0;

    Future<void> closeStoreIfOpen() async {
      if (isStoreOpen()) {
        await storeCloseTest(storeHandle);
        storeHandle = 0;
      }
    }

    Future<void> closeSessionIfOpen() async {
      if (isSessionOpen()) {
        await sessionCloseTest(sessionHandle);
        sessionHandle = 0;
      }
    }

    setUpAll(() async {
      final result = askarVersion();
      print(result);
      expect(result, equals('0.3.2'));

      final generateKeyResult = askarStoreGenerateRawKeyTest();
      storeKey = generateKeyResult.value;

      await storeProvisionTest(storeKey);

      final storeOpenResult = await storeOpenTest(storeKey);
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

      entryListGetValueTest(entryListHandle, 0, expectedValue: value);
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

      final keyGenerateResult =
          keyGenerateTest(KeyAlgorithm.ed25519, KeyBackend.software);

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

      final keyGenerateResult = keyGenerateTest(algorithm, KeyBackend.software);
      final localKeyHandle = keyGenerateResult.value;

      final thumbprintResult = keyGetJwkThumbprintTest(localKeyHandle, algorithm);

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
    });

    test('Sign Message and Verify Signature', () async {
      final keyGenerateResult =
          keyGenerateTest(KeyAlgorithm.ed25519, KeyBackend.software);

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
    });

    test('Generate nonce', () async {
      final keyGenerateResult =
          keyGenerateTest(KeyAlgorithm.aesA128CbcHs256, KeyBackend.software);

      final localKeyHandle = keyGenerateResult.value;

      keyAeadRandomNonceTest(localKeyHandle);
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
      final keyGenerateResult =
          keyGenerateTest(KeyAlgorithm.ed25519, KeyBackend.software);
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
  });

  group('Store Profile Tests:', () {
    late StoreHandle storeHandle;
    late String storeKey;
    test('Store Create Profile', () async {
      final generateKeyResult = askarStoreGenerateRawKeyTest();
      storeKey = generateKeyResult.value;

      await storeProvisionTest(storeKey);

      final storeOpenResult = await storeOpenTest(storeKey);
      storeHandle = storeOpenResult.value;

      String profile = 'tenant-b2f768c6-d53b-40ab-8e74-8e4ea50a3d3e';

      await storeCreateProfileTest(storeHandle, profile, expectedValue: profile);

      await storeCloseTest(storeHandle);
    });

    test('Store Set Default Profile', () async {
      final generateKeyResult = askarStoreGenerateRawKeyTest();
      storeKey = generateKeyResult.value;

      await storeProvisionTest(storeKey);

      final storeOpenResult = await storeOpenTest(storeKey);
      storeHandle = storeOpenResult.value;

      String newDefaultProfile = 'rekey2';

      await storeSetDefaultProfileTest(storeHandle, newDefaultProfile);
      await storeGetDefaultProfileTest(storeHandle, expectedValue: newDefaultProfile);

      await storeCloseTest(storeHandle);
    });
  });
}

Future<AskarCallbackResult> storeProvisionTest(String passKey) async {
  final String specUri = 'sqlite://storage.db';
  final String profile = 'rekey';
  final bool recreate = true;

  final result = await askarStoreProvision(
      specUri, StoreKeyMethod.argon2IMod, passKey, profile, recreate);

  printAskarCallbackResult('StoreProvision', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

Future<AskarCallbackResult> storeOpenTest(String passKey) async {
  final String specUri = 'sqlite://storage.db';
  final String profile = 'rekey';

  final result =
      await askarStoreOpen(specUri, StoreKeyMethod.argon2IMod, passKey, profile);

  printAskarCallbackResult('StoreOpen', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

Future<AskarCallbackResult> scanStartTest(
    StoreHandle handle, String category, Map tagFilter) async {
  final String profile = 'rekey';
  final int offset = 0;
  final int limit = 2;

  final result =
      await askarScanStart(handle, profile, category, tagFilter, offset, limit);

  printAskarCallbackResult('ScanStart', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));
  expect(result.value, greaterThan(0));

  return result;
}

Future<AskarCallbackResult> scanNextTest(
  ScanHandle handle,
) async {
  final result = await askarScanNext(handle);

  printAskarCallbackResult('ScanNext', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));
  expect(result.value, greaterThan(0));

  return result;
}

Future<AskarCallbackResult> sessionStartTest(StoreHandle handle) async {
  String profile = 'rekey';
  bool asTransaction = true;

  final result = await askarSessionStart(handle, profile, asTransaction);

  printAskarCallbackResult('SessionStart', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

AskarResult<LocalKeyHandle> keyGenerateTest(
    KeyAlgorithm algorithm, KeyBackend keyBackend) {
  bool ephemeral = false;

  final result = askarKeyGenerate(algorithm, keyBackend, ephemeral);

  printAskarResult('KeyGenerate', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, greaterThan(0));

  return result;
}

AskarResult<Uint8List> keyAeadRandomNonceTest(LocalKeyHandle handle) {
  final result = askarKeyAeadRandomNonce(handle);

  printAskarResult('KeyAeadRandomNonce', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value.isNotEmpty, equals(true));

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

  printAskarResult('KeyEntryListGetTags', result);
  expect(result.errorCode, ErrorCode.success);
  expect(result.value, expectedValue);

  return result;
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
      sessionHandle, localKeyHandle, name, metadata, tags, expiryMs);

  printAskarCallbackResult('SessionInsertKey', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

Future<AskarCallbackResult> sessionRemoveKeyTest(
    SessionHandle handle, String name) async {
  final result = await askarSessionRemoveKey(handle, name);

  printAskarCallbackResult('SessionRemoveKey', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

Future<AskarCallbackResult> sessionCountTest(
    SessionHandle handle, String category, Map<String, String> tagFilter) async {
  final result = await askarSessionCount(handle, category, tagFilter);

  printAskarCallbackResult('SessionCount', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));
  expect(result.value, greaterThan(0));

  return result;
}

Future<AskarCallbackResult> sessionFetchKeyTest(SessionHandle handle, String name,
    {bool expectSuccess = true}) async {
  bool forUpdate = false;

  final result = await askarSessionFetchKey(handle, name, forUpdate);

  printAskarCallbackResult('SessionFetchKey', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  if (expectSuccess) {
    expect(result.value, greaterThan(0));
  } else {
    expect(result.value, equals(0));
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

  final result =
      await askarSessionFetchAll(handle, category, tagFilter, limit, forUpdate);

  printAskarResult('SessionFetchAll', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, greaterThan(0));

  return result;
}

Future<AskarCallbackResult> sessionFetchAllKeysTest(SessionHandle handle,
    KeyAlgorithm algorithm, String thumbprint, Map tagFilter) async {
  int limit = 10;
  bool forUpdate = false;

  final result = await askarSessionFetchAllKeys(
      handle, algorithm, thumbprint, tagFilter, limit, forUpdate);

  printAskarCallbackResult('SessionFetchAllKeys', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));
  expect(result.value, greaterThan(0));

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

  final result =
      await askarSessionUpdate(handle, operation, category, name, value, tags, expiryMs);

  printAskarCallbackResult('SessionUpdate', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

Future<AskarCallbackResult> sessionRemoveAllTest(
    SessionHandle handle, String category, Map<String, String> tags,
    {required int expected}) async {
  final result = await askarSessionRemoveAll(handle, category, tags);

  printAskarCallbackResult('SessionRemoveAll', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));
  expect(result.value, equals(expected));

  return result;
}

Future<AskarCallbackResult> sessionFetchTest(SessionHandle handle,
    {bool expectSuccess = true}) async {
  String category = 'category-one';
  String name = 'testEntry';
  bool forUpdate = false;

  AskarCallbackResult result = AskarCallbackResult(ErrorCode.custom, false, null);

  if (expectSuccess) {
    result = await askarSessionFetch(handle, category, name, forUpdate);
    expect(result.errorCode, equals(ErrorCode.success));
    expect(result.finished, equals(true));
    expect(result.value, isNot(0));
  } else {
    await expectLater(
      () async => {result = await askarSessionFetch(handle, category, name, forUpdate)},
      throwsA(isA<Exception>()),
    );
  }

  printAskarCallbackResult('SessionFetch', result);

  return result;
}

AskarResult<String> entryListGetValueTest(EntryListHandle handle, int index,
    {required String expectedValue}) {
  final result = askarEntryListGetValue(handle, index);

  printAskarResult('EntryListGetValue', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, equals(expectedValue));

  return result;
}

AskarResult<Map> entryListGetTagsTest(EntryListHandle handle, int index,
    {required Map expectedTags}) {
  final result = askarEntryListGetTags(handle, index);

  printAskarResult('EntryListGetTags', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, equals(expectedTags));

  return result;
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

AskarResult<int> keyEntryListLoadLocalTest(KeyEntryListHandle handle, int index) {
  final result = askarKeyEntryListLoadLocal(handle, index);

  printAskarResult('KeyEntryListLoadLocalTest', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, greaterThan(0));

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
  expect(result.value, greaterThan(9));

  return result;
}

Future<AskarCallbackBlankResult> sessionCloseTest(SessionHandle handle) async {
  final result = await askarSessionClose(handle, true);

  printAskarBlankResult('SessionClose', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

Future<AskarCallbackResult> storeCloseTest(StoreHandle handle) async {
  final result = await askarStoreClose(handle);

  printAskarCallbackResult('StoreClose', result);

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

  printAskarResult('StringListGetItemTest', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.value, equals(expected));

  return result;
}

Future<AskarCallbackResult> storeCreateProfileTest(StoreHandle handle, String profile,
    {required String expectedValue}) async {
  final result = await askarStoreCreateProfile(handle, profile);

  printAskarCallbackResult('StoreCreateProfile', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));
  expect(result.value, equals(expectedValue));

  return result;
}

Future<AskarCallbackResult> storeGetDefaultProfileTest(StoreHandle handle,
    {required String expectedValue}) async {
  final result = await askarStoreGetDefaultProfile(handle);

  printAskarCallbackResult('StoreGetDefaultProfile', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));
  expect(result.value, equals(expectedValue));

  return result;
}

Future<AskarCallbackBlankResult> storeSetDefaultProfileTest(
    StoreHandle handle, String profile) async {
  final result = await askarStoreSetDefaultProfile(handle, profile);

  printAskarBlankResult('StoreSetDefaultProfile', result);

  expect(result.errorCode, equals(ErrorCode.success));
  expect(result.finished, equals(true));

  return result;
}

void printAskarCallbackResult(String test, AskarCallbackResult result) {
  print(
      '$test Result: (${result.errorCode}, Value: ${result.value}, Finished: ${result.finished})\n');
}

void printAskarBlankResult(String test, AskarCallbackBlankResult result) {
  print('$test Result: (${result.errorCode}, Finished: ${result.finished})\n');
}

void printAskarResult(String test, AskarResult result) {
  print('$test Result: (${result.errorCode}, Value: ${result.value})\n');
}
