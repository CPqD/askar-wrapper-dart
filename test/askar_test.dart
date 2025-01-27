// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:import_so_libaskar/askar/askar_callbacks.dart';
import 'package:import_so_libaskar/askar/askar_error_code.dart';
import 'package:import_so_libaskar/askar/askar_wrapper.dart';
import 'package:import_so_libaskar/main.dart';

void main() {
  group('Askar Tests', () {
    test('Askar Version', () {
      final result = askarVersion();
      expect(result, equals('0.3.2'));
    });

    testWidgets('Store Provision', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.runAsync(() async {
        final storeProvisionResult = await storeProvisionTest();
        expect(storeProvisionResult.errorCode, equals(ErrorCode.success));
        expect(storeProvisionResult.finished, equals(true));

        final storeOpenResult = await storeOpenTest();
        expect(storeOpenResult.errorCode, equals(ErrorCode.success));
        expect(storeOpenResult.finished, equals(true));

        final storeCloseResult = await storeCloseTest(storeOpenResult.handle);
        expect(storeCloseResult.errorCode, equals(ErrorCode.success));
        expect(storeCloseResult.finished, equals(true));
      });
    });

    testWidgets('Attempt to read from an unexisting category',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.runAsync(() async {
        final storeOpenResult = await storeOpenTest();
        expect(storeOpenResult.errorCode, equals(ErrorCode.success));
        expect(storeOpenResult.finished, equals(true));

        final sessionStartResult = await sessionStartTest(storeOpenResult.handle);
        expect(sessionStartResult.errorCode, equals(ErrorCode.success));
        expect(sessionStartResult.finished, equals(true));

        final sessionFetchResult = await sessionFetchTest(sessionStartResult.handle);
        expect(sessionFetchResult.errorCode, equals(ErrorCode.success));
        expect(sessionFetchResult.finished, equals(true));
        expect(sessionFetchResult.handle, equals(0));

        final sessionCloseResult = await sessionCloseTest(sessionStartResult.handle);
        expect(sessionCloseResult.errorCode, equals(ErrorCode.success));
        expect(sessionCloseResult.finished, equals(true));
      });
    });

    testWidgets('Writing and reading from session', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.runAsync(() async {
        final storeOpenResult = await storeOpenTest();
        expect(storeOpenResult.errorCode, equals(ErrorCode.success));
        expect(storeOpenResult.finished, equals(true));

        final sessionStartResult = await sessionStartTest(storeOpenResult.handle);
        expect(sessionStartResult.errorCode, equals(ErrorCode.success));
        expect(sessionStartResult.finished, equals(true));

        String value = 'foobar';
        String name = 'testEntry';
        String category = 'category-one';
        Map<String, String> tags = {'~plaintag': 'a', 'enctag': 'b'};

        final sessionUpdateResult = await sessionUpdateTest(
            sessionStartResult.handle, value, tags, name, category);
        expect(sessionUpdateResult.errorCode, equals(ErrorCode.success));
        expect(sessionUpdateResult.finished, equals(true));

        final sessionFetchResult = await sessionFetchTest(sessionStartResult.handle);
        expect(sessionFetchResult.errorCode, equals(ErrorCode.success));
        expect(sessionFetchResult.finished, equals(true));
        expect(sessionFetchResult.handle, isNot(equals(0)));

        final entryListHandle = sessionFetchResult.handle;

        final entryListGetValueRes = entryListGetValueTest(entryListHandle, 0);
        expect(entryListGetValueRes.errorCode, equals(ErrorCode.success));
        expect(entryListGetValueRes.value, equals(value));

        final entryListGetTagsRes = entryListGetTagsTest(entryListHandle, 0);
        expect(entryListGetTagsRes.errorCode, equals(ErrorCode.success));
        expect(entryListGetTagsRes.value, equals(tags));

        final entryListGetNameRes = entryListGetNameTest(entryListHandle, 0);
        expect(entryListGetNameRes.errorCode, equals(ErrorCode.success));
        expect(entryListGetNameRes.value, equals(name));

        final entryListGetCategoryRes = entryListGetCategoryTest(entryListHandle, 0);
        expect(entryListGetCategoryRes.errorCode, equals(ErrorCode.success));
        expect(entryListGetCategoryRes.value, equals(category));

        askarEntryListFree(entryListHandle);

        final sessionCloseResult = await sessionCloseTest(sessionStartResult.handle);
        expect(sessionCloseResult.errorCode, equals(ErrorCode.success));
        expect(sessionCloseResult.finished, equals(true));
      });
    });
    testWidgets('Inserting and reading Key', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.runAsync(() async {
        final storeOpenResult = await storeOpenTest();
        expect(storeOpenResult.errorCode, equals(ErrorCode.success));
        expect(storeOpenResult.finished, equals(true));

        final sessionStartResult = await sessionStartTest(storeOpenResult.handle);
        expect(sessionStartResult.errorCode, equals(ErrorCode.success));
        expect(sessionStartResult.finished, equals(true));

        final sessionHandle = sessionStartResult.handle;

        String name = 'testEntry2';
        String metadata = 'meta';
        Map<String, String> tags = {'~plaintag': 'a', 'enctag': 'b'};

        final keyGenerateResult = keyGenerateTest();
        expect(keyGenerateResult.errorCode, equals(ErrorCode.success));
        expect(keyGenerateResult.value, greaterThan(0));

        final localKeyHandle = keyGenerateResult.value;

        final sessionInsertResult = await sessionInsertKeyTest(
            sessionHandle, localKeyHandle, name, metadata, tags);
        expect(sessionInsertResult.errorCode, equals(ErrorCode.success));
        expect(sessionInsertResult.finished, equals(true));

        final sessionFetchKeyResult = await sessionFetchKeyTest(sessionHandle, name, 0);
        expect(sessionFetchKeyResult.errorCode, equals(ErrorCode.success));
        expect(sessionFetchKeyResult.finished, equals(true));
        expect(sessionFetchKeyResult.handle, greaterThan(0));

        final keyEntryListMetadataRes =
            keyEntryListGetMetadataTest(sessionFetchKeyResult.handle, 0);
        expect(keyEntryListMetadataRes.errorCode, equals(ErrorCode.success));
        expect(keyEntryListMetadataRes.value, equals(metadata));

        final sessionCloseResult = await sessionCloseTest(sessionHandle);
        expect(sessionCloseResult.errorCode, equals(ErrorCode.success));
        expect(sessionCloseResult.finished, equals(true));
      });
    });
  });
}

Future<CallbackResult> storeProvisionTest() async {
  final String specUri = 'sqlite://storage.db';
  final String keyMethod = 'kdf:argon2i:mod';
  final String passKey = 'mySecretKey';
  final String profile = 'rekey';
  final int recreate = 1; // 1 para recriar, 0 para manter

  final result =
      await askarStoreProvision(specUri, keyMethod, passKey, profile, recreate);

  printResult('StoreProvision', result);

  return result;
}

Future<CallbackResult> storeOpenTest() async {
  final String specUri = 'sqlite://storage.db';
  final String keyMethod = 'kdf:argon2i:mod';
  final String passKey = 'mySecretKey';
  final String profile = 'rekey';

  final result = await askarStoreOpen(specUri, keyMethod, passKey, profile);

  printResult('StoreOpen', result);

  return result;
}

Future<CallbackResult> sessionStartTest(int handle) async {
  String profile = 'rekey';
  int asTransaction = 1;

  final result = await askarSessionStart(handle, profile, asTransaction);

  printResult('SessionStart', result);

  return result;
}

AskarIntResult keyGenerateTest() {
  String alg = "ed25519";
  String keyBackend = "0";
  int ephemeral = 0;

  final result = askarKeyGenerate(alg, keyBackend, ephemeral);

  printAskarIntResult('KeyGenerate', result);

  return result;
}

Future<CallbackResult> sessionInsertKeyTest(int sessionHandle, int localKeyHandle,
    String name, String metadata, Map<String, String> tags) async {
  int expiryMs = 2000;

  final result = await askarSessionInsertKey(
      sessionHandle, localKeyHandle, name, metadata, tags, expiryMs);

  printResult('SessionInsertKey', result);

  return result;
}

Future<CallbackResult> sessionFetchKeyTest(
    int sessionHandle, String name, int forUpdate) async {
  final result = await askarSessionFetchKey(sessionHandle, name, forUpdate);

  printResult('SessionFetchKey', result);

  return result;
}

AskarStringResult keyEntryListGetMetadataTest(int keyEntryListHandle, int index) {
  final result = askarKeyEntryListGetMetadata(keyEntryListHandle, index);

  printAskarStringResult('KeyEntryListGetMetadata', result);

  return result;
}

Future<CallbackResult> sessionUpdateTest(int handle, String value,
    Map<String, String> tags, String name, String category) async {
  int operation = 0;

  int expiryMs = 2000;

  final result =
      await askarSessionUpdate(handle, operation, category, name, value, tags, expiryMs);

  printResult('SessionUpdate', result);

  return result;
}

Future<CallbackResult> sessionFetchTest(int handle) async {
  String category = 'category-one';
  String name = 'testEntry';
  int forUpdate = 0;

  final result = await askarSessionFetch(handle, category, name, forUpdate);

  printResult('SessionFetch', result);

  return result;
}

AskarStringResult entryListGetValueTest(int entryListHandle, int index) {
  final result = askarEntryListGetValue(entryListHandle, index);

  printAskarStringResult('EntryListGetValue', result);

  return result;
}

AskarMapResult entryListGetTagsTest(int entryListHandle, int index) {
  final result = askarEntryListGetTags(entryListHandle, index);

  printAskarMapResult('EntryListGetTags', result);

  return result;
}

AskarStringResult entryListGetNameTest(int entryListHandle, int index) {
  final result = askarEntryListGetName(entryListHandle, index);

  printAskarStringResult('askarEntryListGetName', result);

  return result;
}

AskarStringResult entryListGetCategoryTest(int entryListHandle, int index) {
  final result = askarEntryListGetCategory(entryListHandle, index);

  printAskarStringResult('askarEntryListGetCategory', result);

  return result;
}

Future<CallbackResult> sessionCloseTest(int handle) async {
  final result = await askarSessionClose(handle, true);

  printResult('StoreClose', result);

  return result;
}

Future<CallbackResult> storeCloseTest(int handle) async {
  final result = await askarStoreClose(handle);

  printResult('StoreClose', result);

  return result;
}

void printResult(String test, CallbackResult result) {
  if (result.handle == -1) {
    print('$test Result: (${result.errorCode}, Finished: ${result.finished})\n');
  } else {
    print(
        '$test Result: (${result.errorCode}, Handle: ${result.handle}, Finished: ${result.finished})\n');
  }
}

void printAskarStringResult(String test, AskarStringResult result) {
  print('$test Result: (${result.errorCode}, Value: "${result.value}")\n');
}

void printAskarMapResult(String test, AskarMapResult result) {
  print('$test Result: (${result.errorCode}, Value: "${result.value}")\n');
}

void printAskarIntResult(String test, AskarIntResult result) {
  print('$test Result: (${result.errorCode}, Value: ${result.value})\n');
}
