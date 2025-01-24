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

        final sessionUpdateResult =
            await sessionUpdateTest(sessionStartResult.handle, value);
        expect(sessionUpdateResult.errorCode, equals(ErrorCode.Success));
        expect(sessionUpdateResult.finished, equals(true));

        final sessionFetchResult = await sessionFetchTest(sessionStartResult.handle);
        expect(sessionFetchResult.errorCode, equals(ErrorCode.Success));
        expect(sessionFetchResult.finished, equals(true));
        expect(sessionFetchResult.handle, isNot(equals(0)));

        final entryListGetValueResult =
            entryListGetValueTest(sessionFetchResult.handle, 0);
        expect(entryListGetValueResult.errorCode, equals(ErrorCode.Success));
        expect(entryListGetValueResult.value, equals(value));

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

Future<CallbackResult> sessionInsertKeyTest(int handle) async {
  Pointer<ArcHandleLocalKey> keyHandlePointer = calloc<ArcHandleLocalKey>();
  String name = 'testkey"';
  String metadata = 'meta';
  Map<String, String> tags = {'a': 'b'};
  int expiryMs = 2000;

  final result = await askarSessionInsertKey(
      handle, keyHandlePointer, name, metadata, tags, expiryMs);

  printResult('SessionInsertKey', result);

  calloc.free(keyHandlePointer);

  return result;
}

Future<CallbackResult> sessionUpdateTest(int handle, String value) async {
  int operation = 0;
  String category = 'category-one';
  String name = 'testEntry';
  Map<String, String> tags = {'~plaintag': 'a', 'enctag': 'b'};
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
