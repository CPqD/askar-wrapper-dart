import 'dart:convert';

import '../../askar/askar_wrapper.dart';
import '../../askar/crypto/handles.dart';
import '../../askar/repository/askar_store_repository.dart';
import '../enums/askar_entry_operation.dart';
import '../enums/askar_error_code.dart';
import '../enums/askar_key_algorithm.dart';
import '../exceptions/exceptions.dart';
import '../interface/askar_session_interface.dart';

class AskarSessionRepository implements IAskarSession {
  final AskarStoreRepository store;
  final bool asTransaction;

  SessionHandle? handle;

  AskarSessionRepository({required this.store, this.asTransaction = false});

  @override
  Future<bool> start() async {
    if (store.handle == null) {
      return false;
    }
    final result = await askarSessionStart(
        StoreHandle(store.handle!.toInt()), store.profile, asTransaction);
    if (result.errorCode == ErrorCode.success) {
      handle = result.value;
      return true;
    }
    return false;
  }

  @override
  Future<bool> close({required bool commit}) async {
    checkSession();
    final result = await askarSessionClose(handle!, commit);
    if (result.errorCode == ErrorCode.success) {
      handle = null;
      return true;
    }
    return false;
  }

  @override
  Future<EntryListHandle?> fetch(String category, String name, bool forUpdate) async {
    checkSession();
    final result = await askarSessionFetch(handle!, category, name, forUpdate);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return null;
  }

  @override
  Future<EntryListHandle?> fetchAll(
      String category, Map tagFilter, int limit, bool forUpdate) async {
    checkSession();
    final result = await askarSessionFetchAll(handle!, category,
        tagFilter: tagFilter, limit: limit, forUpdate: forUpdate);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return null;
  }

  @override
  Future<KeyEntryListHandle?> fetchAllKeys(KeyAlgorithm algorithm, String thumbprint,
      Map tagFilter, int limit, bool forUpdate) async {
    checkSession();
    final result = await askarSessionFetchAllKeys(handle!,
        algorithm: algorithm,
        thumbprint: thumbprint,
        tagFilter: tagFilter,
        limit: limit,
        forUpdate: forUpdate);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return null;
  }

  @override
  Future<KeyEntryListHandle?> fetchKey(String name, bool forUpdate) async {
    checkSession();
    final result = await askarSessionFetchKey(handle!, name, forUpdate);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return null;
  }

  @override
  Future<bool> insertKeys(LocalKeyHandle localKeyHandle, String name, String metadata,
      Map<String, dynamic> tags, int expiryMs) async {
    checkSession();
    final result = await askarSessionInsertKey(handle!, localKeyHandle, name,
        metadata: metadata, tags: tags, expiryMs: expiryMs);
    if (result.errorCode == ErrorCode.success) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> removeAll(String category, Map<String, dynamic> tagFilter) async {
    checkSession();
    final result = await askarSessionRemoveAll(handle!, category, tagFilter: tagFilter);
    if (result.errorCode == ErrorCode.success) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> removeKey(String name) async {
    checkSession();
    final result = await askarSessionRemoveKey(handle!, name);
    if (result.errorCode == ErrorCode.success) {
      return true;
    }
    return false;
  }

  @override
  Future<int> sessionCount(String category, Map<String, dynamic> tagFilter) async {
    checkSession();
    final result = await askarSessionCount(handle!, category, tagFilter: tagFilter);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return 0;
  }

  @override
  Future<bool> update(EntryOperation operation, String category, String name,
      String value, Map<String, String> tags, int expiryMs) async {
    checkSession();
    final result = await askarSessionUpdate(handle!, operation, category, name,
        value: value, tags: tags, expiryMs: expiryMs);
    if (result.errorCode == ErrorCode.success) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> updateKey(String name, String metadata, String tags, int expiryMs) async {
    checkSession();
    final result = await askarSessionUpdateKey(handle!, name,
        metadata: metadata, tags: jsonDecode(tags), expiryMs: expiryMs);
    if (result.errorCode == ErrorCode.success) {
      return true;
    }
    return false;
  }

  checkSession() {
    if (handle == null) {
      throw AskarSessionException("Sessão não iniciada");
    }
  }
}
