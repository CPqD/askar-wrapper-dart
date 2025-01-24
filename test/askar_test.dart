import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:import_so_libaskar/askar/askar_callbacks.dart';
import 'package:import_so_libaskar/askar/askar_error_code.dart';
import 'package:import_so_libaskar/askar/askar_native_functions.dart';
import 'package:import_so_libaskar/askar/askar_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';
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
        expect(storeProvisionResult.errorCode, equals(ErrorCode.Success));
        expect(storeProvisionResult.finished, equals(true));

        final storeOpenResult = await storeOpenTest();
        expect(storeOpenResult.errorCode, equals(ErrorCode.Success));
        expect(storeOpenResult.finished, equals(true));

        final storeCloseResult = await storeCloseTest(storeOpenResult.handle);
        expect(storeCloseResult.errorCode, equals(ErrorCode.Success));
        expect(storeCloseResult.finished, equals(true));
      });
    });

    testWidgets('Attempt to read from an unexisting category',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.runAsync(() async {
        final storeOpenResult = await storeOpenTest();
        expect(storeOpenResult.errorCode, equals(ErrorCode.Success));
        expect(storeOpenResult.finished, equals(true));

        final sessionStartResult = await sessionStartTest(storeOpenResult.handle);
        expect(sessionStartResult.errorCode, equals(ErrorCode.Success));
        expect(sessionStartResult.finished, equals(true));

        final sessionFetchResult = await sessionFetchTest(sessionStartResult.handle);
        expect(sessionFetchResult.errorCode, equals(ErrorCode.Success));
        expect(sessionFetchResult.finished, equals(true));
        expect(sessionFetchResult.handle, equals(0));

        final sessionCloseResult = await sessionCloseTest(sessionStartResult.handle);
        expect(sessionCloseResult.errorCode, equals(ErrorCode.Success));
        expect(sessionCloseResult.finished, equals(true));
      });
    });

    testWidgets('Writing and reading', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.runAsync(() async {
        final storeOpenResult = await storeOpenTest();
        expect(storeOpenResult.errorCode, equals(ErrorCode.Success));
        expect(storeOpenResult.finished, equals(true));

        final sessionStartResult = await sessionStartTest(storeOpenResult.handle);
        expect(sessionStartResult.errorCode, equals(ErrorCode.Success));
        expect(sessionStartResult.finished, equals(true));

        String value = 'foobar';
        String name = 'testEntry';
        String category = 'category-one';
        Map<String, String> tags = {'~plaintag': 'a', 'enctag': 'b'};

        final sessionUpdateResult = await sessionUpdateTest(
            sessionStartResult.handle, value, tags, name, category);
        expect(sessionUpdateResult.errorCode, equals(ErrorCode.Success));
        expect(sessionUpdateResult.finished, equals(true));

        final sessionFetchResult = await sessionFetchTest(sessionStartResult.handle);
        expect(sessionFetchResult.errorCode, equals(ErrorCode.Success));
        expect(sessionFetchResult.finished, equals(true));
        expect(sessionFetchResult.handle, isNot(equals(0)));

        final entryListHandle = sessionFetchResult.handle;

        final entryListGetValueRes = entryListGetValueTest(entryListHandle, 0);
        expect(entryListGetValueRes.errorCode, equals(ErrorCode.Success));
        expect(entryListGetValueRes.value, equals(value));

        final entryListGetTagsRes = entryListGetTagsTest(entryListHandle, 0);
        expect(entryListGetTagsRes.errorCode, equals(ErrorCode.Success));
        expect(entryListGetTagsRes.value, equals(tags));

        final entryListGetNameRes = entryListGetNameTest(entryListHandle, 0);
        expect(entryListGetNameRes.errorCode, equals(ErrorCode.Success));
        expect(entryListGetNameRes.value, equals(name));

        final entryListGetCategoryRes = entryListGetCategoryTest(entryListHandle, 0);
        expect(entryListGetCategoryRes.errorCode, equals(ErrorCode.Success));
        expect(entryListGetCategoryRes.value, equals(category));

        askarEntryListFree(entryListHandle);

        final sessionCloseResult = await sessionCloseTest(sessionStartResult.handle);
        expect(sessionCloseResult.errorCode, equals(ErrorCode.Success));
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

Future<CallbackResult> sessionInsertKeyTest(int handle, Map<String, String> tags) async {
  Pointer<ArcHandleLocalKey> keyHandlePointer = calloc<ArcHandleLocalKey>();
  String name = 'testkey"';
  String metadata = 'meta';
  int expiryMs = 2000;

  final result = await askarSessionInsertKey(
      handle, keyHandlePointer, name, metadata, tags, expiryMs);

  printResult('SessionInsertKey', result);

  calloc.free(keyHandlePointer);

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
  print('$test Result: (${result.errorCode}, Value: \"${result.value}\")\n');
}

void printAskarMapResult(String test, AskarMapResult result) {
  print('$test Result: (${result.errorCode}, Value: \"${result.value}\")\n');
}
