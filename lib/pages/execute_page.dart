import 'dart:convert';

import 'package:flutter/material.dart';

import '../askar/askar_callbacks.dart';
import '../askar/askar_wrapper.dart';
import '../askar/enums/askar_entry_operation.dart';
import '../askar/enums/askar_key_algorithm.dart';
import '../askar/enums/askar_key_backend.dart';
import '../askar/enums/askar_signature_algorithm.dart';
import '../global.dart';

class ExecutePage extends StatefulWidget {
  final String title;
  final int index;

  const ExecutePage({super.key, required this.title, required this.index});

  @override
  State<ExecutePage> createState() => _ExecutePageState();
}

class _ExecutePageState extends State<ExecutePage> {
  List<Function> _functions = [];

  String result = '';

  @override
  initState() {
    super.initState();
    _functions = [
      storeProvision,
      startSession,
      closeSession,
      fetchCategory,
      writeAndRead,
      insertAndReadKey,
      readAllKeys,
      signMessageAndVerify,
      insertAndRemoveKey,
      readKey,
    ];
    _functions[widget.index]();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                result,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  storeProvision() async {
    final res = await askarStoreProvision(specUri!, method, passKey, profile, recreate);
    await show('storeProvision', res);
  }

  startSession({bool asTransaction = true}) async {
    storeHandle = await askarStoreOpen(specUri!, method, passKey, profile);
    await show('StoreOpen', storeHandle!);

    sessionHandle = await askarSessionStart(storeHandle!.value, profile, asTransaction);

    await show('SessionStart', sessionHandle!);
  }

  closeSession() async {
    print('CLOSE SESSION $sessionHandle');
    if (sessionHandle != null) {
      final sessinCloseResult = await askarSessionClose(sessionHandle!.value, true);
      result = '$result SessionClose: ${sessinCloseResult.errorCode}\n';
      sessionHandle = null;
      setState(() {});
    }
    if (storeHandle != null) {
      await askarStoreClose(storeHandle!.value);
      result = '$result CloseStore';
      storeHandle = null;
      setState(() {});
    }
  }

  fetchCategory() async {
    String category = 'category-one';
    String name = 'testEntry';
    bool forUpdate = false;

    try {
      await startSession();
      final sessionFetchResult =
          await askarSessionFetch(sessionHandle!.value, category, name, forUpdate);

      await show('SessionFetch', sessionFetchResult);
    } catch (e) {
      result = '$result SessionFetch: $e\n';
      setState(() {});
    }
    await closeSession();
  }

  writeAndRead() async {
    bool asTransaction = true;
    String category = 'category-one';
    String name = 'testEntry';
    bool forUpdate = false;
    String value = 'foobar';
    Map<String, String> tags = {'tag_1': 'b'};

    await startSession(asTransaction: asTransaction);

    final sessionUpdateResult = await askarSessionUpdate(
        sessionHandle!.value, EntryOperation.insert, category, name, value, tags, 2000);

    await show('SessionUpdatet', sessionUpdateResult);

    try {
      final sessionFetchResult =
          await askarSessionFetch(sessionHandle!.value, category, name, forUpdate);
      await show('SessionFetch', sessionFetchResult);

      final entryListHandle = sessionFetchResult.value;

      final valueResult = askarEntryListGetValue(entryListHandle, 0);
      final tagsResult = askarEntryListGetTags(entryListHandle, 0);
      final nameResult = askarEntryListGetName(entryListHandle, 0);
      final categoryResult = askarEntryListGetCategory(entryListHandle, 0);

      result =
          '$result SessionFetch: Value ${valueResult.value}, Tags ${tagsResult.value}, Name ${nameResult.value}, Category ${categoryResult.value}\n';

      setState(() {});
    } catch (e) {
      result = '$result SessionFetchError: $e\n';

      setState(() {});
    }

    await closeSession();
  }

  insertAndReadKey() async {
    bool asTransaction = true;
    String name = 'testEntry5';
    bool forUpdate = true;
    Map<String, String> tags = {'tag_1': 'b'};
    String metadata = 'meta';

    await startSession(asTransaction: asTransaction);

    await getOrGenerateKey();

    final sessionInsertKey = await askarSessionInsertKey(
        sessionHandle!.value, localKeyHandle, name, metadata, tags, 200000);

    await show('SessionInsertKey', sessionInsertKey);

    try {
      final sessionFetchKeyResult =
          await askarSessionFetchKey(sessionHandle!.value, name, forUpdate);

      await show('SessionFetchKey', sessionFetchKeyResult);

      final askarKeyEntryListGetMetadataResult =
          askarKeyEntryListGetMetadata(sessionFetchKeyResult.value, 0);

      await show('KeyEntryListGetMetadata', askarKeyEntryListGetMetadataResult);
    } catch (e) {
      result = '$result SessionFetchKeyError: $e\n';

      setState(() {});
    }

    await closeSession();
  }

  readAllKeys() async {
    Map<String, String> tags = {'tag_1': 'b'};
    final algorithm = KeyAlgorithm.ed25519;
    final limit = 20;

    startSession();

    await getOrGenerateKey();

    result = '$result Thumbprint: $thumbprint // Local Key Handle: $localKeyHandle\n';

    try {
      final fetchAllKeysResult = await askarSessionFetchAllKeys(
          sessionHandle!.value, algorithm, thumbprint, tags, limit, false);

      await show('SessionFetchAllKeys', fetchAllKeysResult);

      final KeyEntryListHandle keyEntryListHandle = fetchAllKeysResult.value;

      final countResult = askarKeyEntryListCount(keyEntryListHandle);
      await show('KeyEntryListCount', countResult);

      for (int i = 0; i < countResult.value; i++) {
        result = '$result Call for index $i:\n';

        final askarKeyEntryListGetMetadataResult =
            askarKeyEntryListGetMetadata(keyEntryListHandle, i);

        await show('KeyEntryListGetMetadata', askarKeyEntryListGetMetadataResult);
      }
    } catch (e) {
      result = '$result SessionFetchKey: $e\n';

      await delay();
    }

    final sessionCloseResult = await askarSessionClose(sessionHandle!.value, true);

    await show('SessionClose', sessionCloseResult);

    setState(() {});
  }

  signMessageAndVerify() async {
    final message = utf8.encode("This is a message!");
    final signAlgorithm = SignatureAlgorithm.edDSA;

    await getOrGenerateKey();
    final signResult = askarKeySignMessage(localKeyHandle, message, signAlgorithm);

    result = '$result KeySignMessage: ${signResult.errorCode} ${signResult.value}\n';

    setState(() {});

    final keyVeryfyResult =
        askarKeyVerifySignature(localKeyHandle, message, signResult.value, signAlgorithm);

    result =
        '$result KeyVerifySignature: ${keyVeryfyResult.errorCode} ${keyVeryfyResult.value}\n';

    setState(() {});
  }

  insertAndRemoveKey() async {
    bool asTransaction = true;
    String name = 'testEntry3';
    bool forUpdate = true;
    Map<String, String> tags = {'tag_1': 'b'};
    String metadata = 'meta';
    await startSession(asTransaction: asTransaction);

    final keyGenerateResult = keyGenerate(KeyAlgorithm.ed25519, KeyBackend.software);

    final localKeyHandle = keyGenerateResult.value;

    final sessionInsertKey = await askarSessionInsertKey(
        sessionHandle!.value, localKeyHandle, name, metadata, tags, 2000);

    await show('sessionInsertKey', sessionInsertKey);

    try {
      final sessionFetchKeyResult =
          await askarSessionFetchKey(sessionHandle!.value, name, forUpdate);

      await show('SessionFetchKey', sessionFetchKeyResult);

      final sessionRemoveKey = await askarSessionRemoveKey(sessionHandle!.value, name);

      await show('SessionRemoveKey', sessionRemoveKey);
    } catch (e) {
      result = '$result Error: $e\n';

      setState(() {});
    }

    await closeSession();
  }

  readKey() async {
    String name = 'testEntry10';
    bool forUpdate = false;

    await startSession();

    try {
      final sessionFetchKeyResult =
          await askarSessionFetchKey(sessionHandle!.value, name, forUpdate);

      await show('SessionFetchKey', sessionFetchKeyResult);

      final askarKeyEntryListResult =
          askarKeyEntryListGetMetadata(sessionFetchKeyResult.value, 0);
      result =
          '$result KeyEntryListGetMetadata: ${askarKeyEntryListResult.errorCode} Valor: ${askarKeyEntryListResult.value}\n';

      setState(() {});
    } catch (e) {
      result = '$result SessionFetchKeyError: $e\n';

      setState(() {});
    }

    await closeSession();
  }

  AskarResult<int> keyGenerate(KeyAlgorithm algorithm, KeyBackend keyBackend) {
    bool ephemeral = false;

    final result = askarKeyGenerate(algorithm, keyBackend, ephemeral);

    return result;
  }

  Future<void> show(String funcName, dynamic funcResult) async {
    result = '$result $funcName: $funcResult\n';
    await delay();
  }

  Future<void> delay() async {
    setState(() {});
    await Future.delayed(Duration(milliseconds: 500));
  }

  Future<void> getOrGenerateKey() async {
    if (localKeyHandle == 0) {
      final keyGenerateResult =
          await keyGenerate(KeyAlgorithm.ed25519, KeyBackend.software);

      await show('KeyGenerate', keyGenerateResult);

      localKeyHandle = keyGenerateResult.value;

      final thumbprintResult =
          askarKeyGetJwkThumbprint(localKeyHandle, KeyAlgorithm.ed25519);
      await show('KeyGetJwkThumbprint', thumbprintResult);

      thumbprint = thumbprintResult.value;
    }
  }
}
