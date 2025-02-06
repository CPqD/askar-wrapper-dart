import 'package:import_so_libaskar/askar/askar_wrapper.dart';
import 'package:import_so_libaskar/objects/askar_store/askar_store.dart';

import '../../askar/enums/askar_error_code.dart';
import '../../askar/enums/askar_key_algorithm.dart';
import 'askar_session_interface.dart';

class AskarSession implements IAskarSession {
  final AskarStore store;
  final bool asTransaction;

  SessionHandle? handle;

  AskarSession({required this.store, this.asTransaction = false});

  @override
  Future<bool> start() async {
    if (store.storeHandle == null) {
      return false;
    }
    final result =
        await askarSessionStart(store.storeHandle!, store.profile, asTransaction);
    if (result.errorCode == ErrorCode.success) {
      handle = result.value;
      return true;
    }
    return false;
  }

  @override
  Future<bool> close({required bool commit}) async {
    final result = await askarSessionClose(handle!, commit);
    if (result.errorCode == ErrorCode.success) {
      handle = null;
      return true;
    }
    return false;
  }

  @override
  Future<EntryListHandle?> fetch(String category, String name, bool forUpdate) async {
    final result = await askarSessionFetch(handle!, category, name, forUpdate);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return null;
  }

  @override
  Future<EntryListHandle?> fetchAll(
      String category, Map tagFilter, int limit, bool forUpdate) async {
    final result =
        await askarSessionFetchAll(handle!, category, tagFilter, limit, forUpdate);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return null;
  }

  @override
  Future<KeyEntryListHandle?> fetchAllKeys(KeyAlgorithm algorithm, String thumbprint,
      Map tagFilter, int limit, bool forUpdate) async {
    final result = await askarSessionFetchAllKeys(
        handle!, algorithm, thumbprint, tagFilter, limit, forUpdate);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return null;
  }

  @override
  Future<KeyEntryListHandle?> fetchKeys(String name, bool forUpdate) async {
    final result = await askarSessionFetchKey(handle!, name, forUpdate);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return null;
  }

  @override
  Future<bool> insertKeys(LocalKeyHandle localKeyHandle, String name, String metadata,
      Map tags, int expiryMs) async {
    final result = await askarSessionInsertKey(
        handle!, localKeyHandle, name, metadata, tags, expiryMs);
    if (result.errorCode == ErrorCode.success) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> removeAll(String category, Map tagFilter) async {
    final result = await askarSessionRemoveAll(handle!, category, tagFilter);
    if (result.errorCode == ErrorCode.success) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> removeKey() {
    // TODO: implement removeKey
    throw UnimplementedError();
  }

  @override
  Future<int> sessionCount() {
    // TODO: implement sessionCount
    throw UnimplementedError();
  }

  @override
  Future<bool> update() {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<bool> updateKey() {
    // TODO: implement updateKey
    throw UnimplementedError();
  }
}
