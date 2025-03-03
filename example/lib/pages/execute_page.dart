import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:askar_wrapper_dart/askar_wrapper_dart.dart';
import 'package:askar_wrapper_dart/askar_wrapper_dart.dart' as key;

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

  Session? session;

  @override
  initState() {
    super.initState();
    _functions = [
      createProfile,
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

  startSession({bool asTransaction = true}) async {
    var openSession = OpenSession(
      store: StoreHandle(store!.handle!.toInt()),
      profile: profile,
      isTransaction: asTransaction,
    );
    session = await openSession.open();

    setState(() {
      result = 'Session Started: ${session!.handle}\n';
    });
  }

  closeSession() async {
    debugPrint('CLOSE SESSION');
    if (session != null) {
      await session!.close();
      result = '$result SessionClose:\n';
      session = null;
      setState(() {});
    }
  }

  createProfile() async {
    try {
      await store!.createProfile();
    } on ProfileDuplicatedException catch (e) {
      result = '$result Error: $e\n';
      setState(() {});
      return;
    }
    result = "Profile Created\n";
    setState(() {});
  }

  fetchCategory() async {
    String category = 'category-one';
    String name = 'testEntry';
    bool forUpdate = false;

    try {
      await startSession();
      final sessionFetchResult = await askarSessionFetch(
        session!.handle!,
        category,
        name,
        forUpdate,
      );

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
      session!.handle!,
      EntryOperation.insert,
      category,
      name,
      value: value,
      tags: tags,
      expiryMs: 2000,
    );

    await show('SessionUpdatet', sessionUpdateResult);

    try {
      final sessionFetchResult = await askarSessionFetch(
        session!.handle!,
        category,
        name,
        forUpdate,
      );
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
      session!.handle!,
      localKeyHandle,
      name,
      metadata: metadata,
      tags: tags,
      expiryMs: 200000,
    );

    await show('SessionInsertKey', sessionInsertKey);

    try {
      final sessionFetchKeyResult = await askarSessionFetchKey(
        session!.handle!,
        name,
        forUpdate,
      );

      await show('SessionFetchKey', sessionFetchKeyResult);

      final askarKeyEntryListGetMetadataResult = askarKeyEntryListGetMetadata(
        sessionFetchKeyResult.value,
        0,
      );

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

    await startSession();

    await getOrGenerateKey();

    result = '$result Thumbprint: $thumbprint // Local Key Handle: $localKeyHandle\n';

    try {
      final fetchAllKeysResult = await askarSessionFetchAllKeys(
        session!.handle!,
        algorithm: algorithm,
        thumbprint: thumbprint,
        tagFilter: tags,
        limit: limit,
        forUpdate: false,
      );

      await show('SessionFetchAllKeys', fetchAllKeysResult);

      final KeyEntryListHandle keyEntryListHandle = fetchAllKeysResult.value;

      final countResult = askarKeyEntryListCount(keyEntryListHandle);
      await show('KeyEntryListCount', countResult);

      for (int i = 0; i < countResult.value; i++) {
        result = '$result Call for index $i:\n';

        final askarKeyEntryListGetMetadataResult = askarKeyEntryListGetMetadata(
          keyEntryListHandle,
          i,
        );

        await show('KeyEntryListGetMetadata', askarKeyEntryListGetMetadataResult);
      }
    } catch (e) {
      result = '$result SessionFetchKey: $e\n';

      await delay();
    }

    final sessionCloseResult = await askarSessionClose(session!.handle!, true);

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

    final keyVeryfyResult = askarKeyVerifySignature(
      localKeyHandle,
      message,
      signResult.value,
      signAlgorithm,
    );

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
      session!.handle!,
      localKeyHandle,
      name,
      metadata: metadata,
      tags: tags,
      expiryMs: 2000,
    );

    await show('sessionInsertKey', sessionInsertKey);

    try {
      final sessionFetchKeyResult = await askarSessionFetchKey(
        session!.handle!,
        name,
        forUpdate,
      );

      await show('SessionFetchKey', sessionFetchKeyResult);

      final sessionRemoveKey = await askarSessionRemoveKey(session!.handle!, name);

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
      final sessionFetchKeyResult = await askarSessionFetchKey(
        session!.handle!,
        name,
        forUpdate,
      );

      await show('SessionFetchKey', sessionFetchKeyResult);

      final askarKeyEntryListResult = askarKeyEntryListGetMetadata(
        sessionFetchKeyResult.value,
        0,
      );
      result =
          '$result KeyEntryListGetMetadata: ${askarKeyEntryListResult.errorCode} Valor: ${askarKeyEntryListResult.value}\n';

      setState(() {});
    } catch (e) {
      result = '$result SessionFetchKeyError: $e\n';

      setState(() {});
    }

    await closeSession();
  }

  AskarResult<LocalKeyHandle> keyGenerate(KeyAlgorithm algorithm, KeyBackend keyBackend) {
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
    if (localKeyHandle.toInt() == 0) {
      localKeyHandle =
          key.Key.generate(
            KeyAlgorithm.ed25519,
            KeyBackend.software,
            ephemeral: false,
          ).handle;

      await show('KeyGenerate', localKeyHandle);

      final thumbprintResult = askarKeyGetJwkThumbprint(
        localKeyHandle,
        KeyAlgorithm.ed25519,
      );
      await show('KeyGetJwkThumbprint', thumbprintResult);

      thumbprint = thumbprintResult.value;
    }
  }
}
