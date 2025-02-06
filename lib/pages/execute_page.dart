// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

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
      fetchCategory,
      writeAndRead,
      insertAndReadKey,
      readAllKeys,
      signMessageAndVerify,
      insertAndRemoveKey,
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
    await show('Provision', res);

    final storeOpenResult = await askarStoreOpen(specUri!, method, passKey, profile);
    await show('StoreOpen', res);

    askarStoreClose(storeOpenResult.value);

    await show('StoreClose', res);

    setState(() {});
  }

  fetchCategory() async {
    bool asTransaction = true;
    String category = 'category-one';
    String name = 'testEntry';
    bool forUpdate = false;

    final storeOpenResult = await askarStoreOpen(specUri!, method, passKey, profile);
    await show('StoreOpen', storeOpenResult);

    final sessionStartResult =
        await askarSessionStart(storeOpenResult.value, profile, asTransaction);

    await show('SessionStart', sessionStartResult);

    try {
      final sessionFetchResult =
          await askarSessionFetch(sessionStartResult.value, category, name, forUpdate);

      await show('SessionFetch', sessionFetchResult);
    } catch (e) {
      result = '$result SessionFetch Error: $e\n';
      await delay();
    }

    await Future.delayed(Duration(milliseconds: 500));
    final sessionCloseResult = await askarSessionClose(sessionStartResult.value, true);
    await show('SessionClose', sessionCloseResult);

    setState(() {});
  }

  writeAndRead() async {
    bool asTransaction = true;
    String category = 'category-one';
    String name = 'testEntry';
    bool forUpdate = false;
    String value = 'foobar';
    Map<String, String> tags = {'tag_1': 'b'};

    final storeOpenResult = await askarStoreOpen(specUri!, method, passKey, profile);

    await show('StoreOpen', storeOpenResult);

    final sessionStartResult =
        await askarSessionStart(storeOpenResult.value, profile, asTransaction);

    await show('SessionStart', sessionStartResult);

    final sessionUpdateResult = await askarSessionUpdate(sessionStartResult.value,
        EntryOperation.insert, category, name, value, tags, 2000);

    await show('sessionUpdate', sessionUpdateResult);

    try {
      final sessionFetchResult =
          await askarSessionFetch(sessionStartResult.value, category, name, forUpdate);

      await show('SessionFetch', sessionFetchResult);

      final entryListHandle = sessionFetchResult.value;

      final valueResult = askarEntryListGetValue(entryListHandle, 0);
      final tagsResult = askarEntryListGetValue(entryListHandle, 0);
      final nameResult = askarEntryListGetValue(entryListHandle, 0);
      final categoryResult = askarEntryListGetValue(entryListHandle, 0);

      result =
          '$result SessionFetch: Value $valueResult, Tags $tagsResult, Name $nameResult, Category $categoryResult\n';

      await delay();
    } catch (e) {
      result = '$result SessionFetch: $e\n';

      await delay();
    }

    final sessinCloseResult = await askarSessionClose(sessionStartResult.value, true);

    await show('SessionClose', sessinCloseResult);

    setState(() {});
  }

  insertAndReadKey() async {
    bool asTransaction = true;
    String name = 'testEntry2';
    bool forUpdate = true;
    Map<String, String> tags = {'tag_1': 'b'};
    String metadata = 'meta';

    final storeOpenResult = await askarStoreOpen(specUri!, method, passKey, profile);

    await show('StoreOpen', storeOpenResult);

    final sessionStartResult =
        await askarSessionStart(storeOpenResult.value, profile, asTransaction);

    await show('SessionStart', sessionStartResult);

    await getOrGenerateKey();

    final sessionInsertKey = await askarSessionInsertKey(
        sessionStartResult.value, localKeyHandle, name, metadata, tags, 200000);

    await show('sessionInsertKey', sessionInsertKey);

    try {
      final sessionFetchKeyResult =
          await askarSessionFetchKey(sessionStartResult.value, name, forUpdate);

      await show('SessionFetchKey', sessionFetchKeyResult);

      final askarKeyEntryListGetMetadataResult =
          askarKeyEntryListGetMetadata(sessionFetchKeyResult.value, 0);

      await show('KeyEntryListGetMetadata', askarKeyEntryListGetMetadataResult);
    } catch (e) {
      result = '$result SessionFetchKey: $e\n';

      await delay();
    }

    final sessionCloseResult = await askarSessionClose(sessionStartResult.value, true);

    await show('SessionClose', sessionCloseResult);

    setState(() {});
  }

  readAllKeys() async {
    bool asTransaction = true;
    Map<String, String> tags = {'tag_1': 'b'};
    final algorithm = KeyAlgorithm.ed25519;
    final limit = 20;

    final storeOpenResult = await askarStoreOpen(specUri!, method, passKey, profile);

    await show('StoreOpen', storeOpenResult);

    final sessionStartResult =
        await askarSessionStart(storeOpenResult.value, profile, asTransaction);

    await show('SessionStart', sessionStartResult);

    await getOrGenerateKey();

    result = '$result Thumbprint: $thumbprint // Local Key Handle: $localKeyHandle\n';

    try {
      final fetchAllKeysResult = await askarSessionFetchAllKeys(
          sessionStartResult.value, algorithm, thumbprint, tags, limit, false);

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

    final sessionCloseResult = await askarSessionClose(sessionStartResult.value, true);

    await show('SessionClose', sessionCloseResult);

    setState(() {});
  }

  signMessageAndVerify() async {
    final message = utf8.encode("This is a message!");
    final signAlgorithm = SignatureAlgorithm.edDSA;

    bool asTransaction = true;
    final storeOpenResult = await askarStoreOpen(specUri!, method, passKey, profile);

    await show('StoreOpen', storeOpenResult);

    final sessionStartResult =
        await askarSessionStart(storeOpenResult.value, profile, asTransaction);

    await show('SessionStart', storeOpenResult);

    await getOrGenerateKey();

    final signResult = askarKeySignMessage(localKeyHandle, message, signAlgorithm);

    await show('KeySignMessage', storeOpenResult);

    final keyVeryfyResult =
        askarKeyVerifySignature(localKeyHandle, message, signResult.value, signAlgorithm);

    await show('KeyVerifySignature', keyVeryfyResult);

    final sessinCloseResult = await askarSessionClose(sessionStartResult.value, true);
    result = '$result SessionClose: ${sessinCloseResult.errorCode}\n';
    setState(() {});
  }

  insertAndRemoveKey() async {
    bool asTransaction = true;
    String name = 'testEntry3';
    bool forUpdate = true;
    Map<String, String> tags = {'tag_1': 'b'};
    String metadata = 'meta';
    final storeOpenResult = await askarStoreOpen(specUri!, method, passKey, profile);

    await show('StoreOpen', storeOpenResult);

    final sessionStartResult =
        await askarSessionStart(storeOpenResult.value, profile, asTransaction);

    await show('SessionStart', storeOpenResult);

    await getOrGenerateKey();

    final sessionInsertKey = await askarSessionInsertKey(
        sessionStartResult.value, localKeyHandle, name, metadata, tags, 2000);

    await show('sessionInsertKey', sessionInsertKey);

    try {
      final sessionFetchKeyResult =
          await askarSessionFetchKey(sessionStartResult.value, name, forUpdate);

      await show('SessionFetchKey', sessionFetchKeyResult);

      final sessionRemoveKey =
          await askarSessionRemoveKey(sessionStartResult.value, name);

      await show('SessionRemoveKey', sessionRemoveKey);
    } catch (e) {
      result = '$result Error: $e\n';

      await delay();
    }

    final sessinCloseResult = await askarSessionClose(sessionStartResult.value, true);

    await show('SessionClose', sessinCloseResult);

    setState(() {});
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
