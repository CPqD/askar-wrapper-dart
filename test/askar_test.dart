import 'dart:ffi';

import 'package:ffi/ffi.dart';
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
      expect(storeProvisionTest(), equals(ErrorCode.Success));

      // Abre a carteira
      expect(storeOpenTest(), equals(ErrorCode.Success));

      // Inicia uma sessão
      // expect(sessionStartTest(), equals(ErrorCode.Success));

      // Insere key
      // expect(sessionInsertKeyTest(), equals(ErrorCode.Input));

      // Atualiza sessao
      // expect(sessionUpdateTest(), equals(ErrorCode.Success));

      // Fecha a carteira
      expect(storeCloseTest(), equals(ErrorCode.Success));
    });
  });
}

ErrorCode storeProvisionTest() {
  final String specUri = 'sqlite://storage.db';
  final String keyMethod = 'raw';
  final String passKey = 'mySecretKey';
  final String profile = 'rekey';
  final int recreate = 1; // 1 para recriar, 0 para manter

  final result = askarStoreProvision(specUri, keyMethod, passKey, profile, recreate);

  print('Store Provision Result: ${result}');

  return result;
}

ErrorCode storeOpenTest() {
  final String specUri = 'sqlite://storage.db';
  final String keyMethod = 'raw';
  final String passKey = 'mySecretKey';
  final String profile = 'rekey';

  final result = askarStoreOpen(specUri, keyMethod, passKey, profile);

  print('Store Open Result: ${result}');

  return result;
}

ErrorCode sessionStartTest() {
  int handle = 1;
  String profile = 'rekey';
  int asTransaction = 1;

  final result = askarSessionStart(handle, profile, asTransaction);

  print('Session Start Result: ${result}');

  return result;
}

ErrorCode sessionInsertKeyTest() {
  int handle = 1;
  Pointer<ArcHandleLocalKey> keyHandlePointer = calloc<ArcHandleLocalKey>();
  String name = '';
  String metadata = '';
  String tags = '';
  int expiryMs = 2000;

  final result =
      askarSessionInsertKey(handle, keyHandlePointer, name, metadata, tags, expiryMs);

  print('Session Insert Key Result: ${result}');

  calloc.free(keyHandlePointer);

  return result;
}

ErrorCode sessionUpdateTest() {
  int handle = 1;
  int operation = 0;
  String category = 'category-one';
  String name = 'testEntry';
  String value = 'foobar';
  String tags = '';
  int expiryMs = 2000;

  final result =
      askarSessionUpdate(handle, operation, category, name, value, tags, expiryMs);

  print('Session Update Result: ${result}');

  return result;
}

ErrorCode storeCloseTest() {
  final int handle = 1; // 0 = não remove os dados do store

  final result = askarStoreClose(handle);

  print('Store Close Result: ${result}');

  return result;
}
