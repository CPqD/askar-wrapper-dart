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
    test('Askar Version - Retorna versão do Askar', () {
      final result = askarVersion();
      expect(result, equals('0.3.2'));
    });

    testWidgets('Askar Store', (WidgetTester tester) async {
      // Faz build do app.
      await tester.pumpWidget(const MyApp());

      // Cria uma carteira
      await tester.runAsync(() async {
        final storeProvisionResult = await storeProvisionTest();
        expect(storeProvisionResult.errorCode, equals(ErrorCode.Success));
        expect(storeProvisionResult.finished, equals(true));

        // Abre a carteira
        // final storeOpenResult = await storeOpenTest();
        // expect(storeOpenResult.errorCode, equals(ErrorCode.Success));
        // expect(storeOpenResult.finished, equals(true));

        // Inicia uma sessão
        final sessionStartResult = await sessionStartTest(storeProvisionResult.handle);
        expect(sessionStartResult.errorCode, equals(ErrorCode.Success));
        expect(sessionStartResult.finished, equals(true));

        // Insere key
        // final sessionInsertKeyResult = await sessionInsertKeyTest(sessionStartResult.handle);
        // expect(sessionInsertKeyResult.errorCode, equals(ErrorCode.Input));
        // expect(sessionInsertKeyResult.finished, equals(true));

        // Atualiza sessao
        final sessionUpdateResult = await sessionUpdateTest(sessionStartResult.handle);
        expect(sessionUpdateResult.errorCode, equals(ErrorCode.Success));
        expect(sessionUpdateResult.finished, equals(true));

        // Fecha a carteira
        final storeCloseResult = await storeCloseTest(storeProvisionResult.handle);
        expect(storeCloseResult.errorCode, equals(ErrorCode.Success));
        expect(storeCloseResult.finished, equals(true));
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

Future<CallbackResult> sessionUpdateTest(int handle) async {
  int operation = 0;
  String category = 'category-one';
  String name = 'testEntry';
  String value = 'foobar';
  Map<String, String> tags = {'~plaintag': 'a', 'enctag': 'b'};
  int expiryMs = 2000;

  final result =
      await askarSessionUpdate(handle, operation, category, name, value, tags, expiryMs);

  printResult('SessionUpdate', result);

  return result;
}

Future<CallbackResult> storeCloseTest(int handle) async {
  final result = await askarStoreClose(handle);

  printResult('StoreClose', result);

  return result;
}

void printResult(String test, CallbackResult result) {
  print(
      '$test Result: (${result.errorCode}, Handle: ${result.handle}, Finished: ${result.finished})\n');
}
