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
    final res =
        await askarStoreProvision(specUri!, method, passKey, profile, recreate);
    result = '$result Provision: ${res.errorCode}\n';
    await delay();

    final storeOpenResult =
        await askarStoreOpen(specUri!, method, passKey, profile);
    result = '$result StoreOpen: ${storeOpenResult.errorCode}\n';

    await delay();

    askarStoreClose(storeOpenResult.handle);
    result = '$result CloseStore';
    setState(() {});
  }

  fetchCategory() async {
    bool asTransaction = true;
    String category = 'category-one';
    String name = 'testEntry';
    bool forUpdate = false;

    final storeOpenResult =
        await askarStoreOpen(specUri!, method, passKey, profile);
    result = '$result StoreOpen: ${storeOpenResult.errorCode}\n';

    await delay();

    final sessionStartResult =
        await askarSessionStart(storeOpenResult.handle, profile, asTransaction);
    result = '$result SessionStart: ${sessionStartResult.errorCode}\n';

    await delay();

    try {
      final sessionFetchResult = await askarSessionFetch(
          sessionStartResult.handle, category, name, forUpdate);
      result = '$result SessionFetch: ${sessionFetchResult.errorCode}\n';

      await delay();
    } catch (e) {
      result = '$result SessionFetch: $e\n';

      await delay();
    }

    await Future.delayed(Duration(milliseconds: 500));
    final sessinCloseResult =
        await askarSessionClose(sessionStartResult.handle, true);
    result = '$result SessionClose: ${sessinCloseResult.errorCode}\n';
    setState(() {});
  }

  writeAndRead() async {
    bool asTransaction = true;
    String category = 'category-one';
    String name = 'testEntry';
    bool forUpdate = false;
    String value = 'foobar';
    Map<String, String> tags = {'~plaintag': 'a', 'enctag': 'b'};

    final storeOpenResult =
        await askarStoreOpen(specUri!, method, passKey, profile);
    result = '$result StoreOpen: ${storeOpenResult.errorCode}\n';

    await delay();

    final sessionStartResult =
        await askarSessionStart(storeOpenResult.handle, profile, asTransaction);
    result = '$result SessionStart: ${sessionStartResult.errorCode}\n';

    await delay();

    final sessionUpdateResult = await askarSessionUpdate(
        sessionStartResult.handle,
        EntryOperation.insert,
        category,
        name,
        value,
        tags,
        2000);

    result = '$result SessionUpdatet: ${sessionUpdateResult.errorCode}\n';

    await delay();

    try {
      final sessionFetchResult = await askarSessionFetch(
          sessionStartResult.handle, category, name, forUpdate);
      result = '$result SessionFetch: ${sessionFetchResult.errorCode}\n';

      await delay();

      final entryListHandle = sessionFetchResult.handle;

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

    final sessinCloseResult =
        await askarSessionClose(sessionStartResult.handle, true);
    result = '$result SessionClose: ${sessinCloseResult.errorCode}\n';
    setState(() {});
  }

  insertAndReadKey() async {
    bool asTransaction = true;
    String name = 'testEntry2';
    bool forUpdate = true;
    Map<String, String> tags = {'~plaintag': 'a', 'enctag': 'b'};
    String metadata = 'meta';

    final storeOpenResult =
        await askarStoreOpen(specUri!, method, passKey, profile);
    result = '$result StoreOpen: ${storeOpenResult.errorCode}\n';

    await delay();

    final sessionStartResult =
        await askarSessionStart(storeOpenResult.handle, profile, asTransaction);
    result = '$result SessionStart: ${sessionStartResult.errorCode}\n';

    await delay();

    final keyGenerateResult =
        keyGenerate(KeyAlgorithm.ed25519, KeyBackend.software);

    final localKeyHandle = keyGenerateResult.value;

    final sessionInsertKey = await askarSessionInsertKey(
        sessionStartResult.handle, localKeyHandle, name, metadata, tags, 2000);

    result = '$result sessionInsertKey: ${sessionInsertKey.errorCode}\n';

    await delay();

    try {
      final sessionFetchKeyResult = await askarSessionFetchKey(
          sessionStartResult.handle, name, forUpdate);
      result = '$result SessionFetchKey: ${sessionFetchKeyResult.errorCode}\n';

      await delay();

      final askarKeyEntryListResult =
          askarKeyEntryListGetMetadata(sessionFetchKeyResult.handle, 0);
      result =
          '$result KeyEntryListGetMetadata: ${askarKeyEntryListResult.errorCode} Valor: ${askarKeyEntryListResult.value}\n';

      await delay();
    } catch (e) {
      result = '$result SessionFetchKey: $e\n';

      await delay();
    }

    final sessinCloseResult =
        await askarSessionClose(sessionStartResult.handle, true);
    result = '$result SessionClose: ${sessinCloseResult.errorCode}\n';
    setState(() {});
  }

  signMessageAndVerify() async {
    final message = utf8.encode("This is a message!");
    final signAlgorithm = SignatureAlgorithm.edDSA;

    bool asTransaction = true;
    final storeOpenResult =
        await askarStoreOpen(specUri!, method, passKey, profile);
    result = '$result StoreOpen: ${storeOpenResult.errorCode}\n';

    await delay();

    final sessionStartResult =
        await askarSessionStart(storeOpenResult.handle, profile, asTransaction);
    result = '$result SessionStart: ${sessionStartResult.errorCode}\n';

    await delay();

    final keyGenerateResult =
        keyGenerate(KeyAlgorithm.ed25519, KeyBackend.software);

    final localKeyHandle = keyGenerateResult.value;

    final signResult =
        askarKeySignMessage(localKeyHandle, message, signAlgorithm);
    result =
        '$result KeySignMessage: ${signResult.errorCode} ${signResult.value}\n';

    await delay();

    final keyVeryfyResult = askarKeyVerifySignature(
        localKeyHandle, message, signResult.value, signAlgorithm);

    result =
        '$result KeyVerifySignature: ${keyVeryfyResult.errorCode} ${keyVeryfyResult.value}\n';

    await delay();

    final sessinCloseResult =
        await askarSessionClose(sessionStartResult.handle, true);
    result = '$result SessionClose: ${sessinCloseResult.errorCode}\n';
    setState(() {});
  }

  insertAndRemoveKey() async {
    bool asTransaction = true;
    String name = 'testEntry3';
    bool forUpdate = true;
    Map<String, String> tags = {'~plaintag': 'a', 'enctag': 'b'};
    String metadata = 'meta';
    final storeOpenResult =
        await askarStoreOpen(specUri!, method, passKey, profile);
    result = '$result StoreOpen: ${storeOpenResult.errorCode}\n';

    await delay();

    final sessionStartResult =
        await askarSessionStart(storeOpenResult.handle, profile, asTransaction);
    result = '$result SessionStart: ${sessionStartResult.errorCode}\n';

    await delay();

    final keyGenerateResult =
        keyGenerate(KeyAlgorithm.ed25519, KeyBackend.software);

    final localKeyHandle = keyGenerateResult.value;

    final sessionInsertKey = await askarSessionInsertKey(
        sessionStartResult.handle, localKeyHandle, name, metadata, tags, 2000);

    result = '$result sessionInsertKey: ${sessionInsertKey.errorCode}\n';

    await delay();

    try {
      final sessionFetchKeyResult = await askarSessionFetchKey(
          sessionStartResult.handle, name, forUpdate);
      result = '$result SessionFetchKey: ${sessionFetchKeyResult.errorCode}\n';

      await delay();

      final sessionRemoveKey =
          await askarSessionRemoveKey(sessionStartResult.handle, name);
      result = '$result SessionRemoveKey: ${sessionRemoveKey.errorCode}\n';

      await delay();
    } catch (e) {
      result = '$result SessionFetchKey: $e\n';

      await delay();
    }

    final sessinCloseResult =
        await askarSessionClose(sessionStartResult.handle, true);
    result = '$result SessionClose: ${sessinCloseResult.errorCode}\n';
    setState(() {});
  }

  AskarResult<int> keyGenerate(KeyAlgorithm algorithm, KeyBackend keyBackend) {
    bool ephemeral = false;

    final result = askarKeyGenerate(algorithm, keyBackend, ephemeral);

    return result;
  }

  Future<void> delay() async {
    setState(() {});
    await Future.delayed(Duration(milliseconds: 500));
  }
}
