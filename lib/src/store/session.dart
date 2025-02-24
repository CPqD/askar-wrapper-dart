import '../askar_wrapper.dart';
import '../crypto/handles.dart';
import '../crypto/key.dart';
import '../enums/askar_entry_operation.dart';
import '../enums/askar_key_algorithm.dart';
import '../exceptions/exceptions.dart';
import 'key_entry.dart';

import 'entry.dart';
import 'entry_list.dart';
import 'key_entry_list.dart';

/// An opened Session instance.
///
/// This class represents an active session, including its [handle] and [isTransaction] status.
class Session {
  /// The handle for the session.
  SessionHandle? handle;

  /// Determines if the session is a transaction.
  bool isTransaction;

  /// Constructs an instance of [Session].
  Session({this.handle, required this.isTransaction});

  /// Counts the records matching a category and tag filter.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  /// Returns the count of matching records.
  Future<int> count({required String category, Map<String, dynamic>? tagFilter}) async {
    _throwOnNullHandle("Cannot count from closed session");

    try {
      final result = await askarSessionCount(handle!, category, tagFilter: tagFilter);
      return result.getValueOrException();
    } catch (e) {
      throw AskarSessionException('Error on session count: $e');
    }
  }

  /// Fetches a record from the store by category and name.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  /// Returns an [EntryObject] if the record is found, otherwise returns null.
  Future<EntryObject?> fetch({
    required String category,
    required String name,
    bool forUpdate = false,
    bool isJson = false,
  }) async {
    _throwOnNullHandle("Cannot fetch from a closed session");

    EntryListHandle? entryListHandle;

    try {
      final fetchResult = await askarSessionFetch(handle!, category, name, forUpdate);

      if (!fetchResult.errorCode.isSuccess()) {
        return null;
      }

      entryListHandle = fetchResult.value;

      final entry = Entry(list: entryListHandle, position: 0);

      return entry.toJson(shouldParseValueToJson: isJson);
    } catch (e) {
      throw AskarSessionException('Failed to fetch entry: $e');
    } finally {
      if (entryListHandle != null) {
        entryListHandle.free();
      }
    }
  }

  /// Fetches all records matching a category and tag filter.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  /// Returns a list of [EntryObject] containing the fetched records.
  Future<List<EntryObject>> fetchAll({
    required String category,
    bool forUpdate = false,
    int? limit,
    Map<String, dynamic>? tagFilter,
    bool isJson = false,
    String? orderBy,
    bool? descending,
  }) async {
    _throwOnNullHandle('Cannot fetch all from a closed session');

    EntryListHandle? entryListHandle;

    try {
      final fetchAllResult = await askarSessionFetchAll(
        handle!,
        category,
        forUpdate: forUpdate,
        tagFilter: tagFilter,
        limit: limit,
      );

      if (!fetchAllResult.errorCode.isSuccess()) {
        return [];
      }

      entryListHandle = fetchAllResult.value;

      return EntryList(handle: entryListHandle).toArray(valuesAreJson: isJson);
    } catch (e) {
      throw AskarSessionException('Failed to fetch entries: $e');
    } finally {
      if (entryListHandle != null) {
        entryListHandle.free();
      }
    }
  }

  /// Inserts a new record into the store.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  Future<void> insert({
    required String category,
    required String name,
    required String value,
    Map<String, dynamic>? tags,
    int? expiryMs,
  }) async {
    _throwOnNullHandle('Cannot insert with a closed session');

    try {
      final updateResult = await askarSessionUpdate(
        handle!,
        EntryOperation.insert,
        category,
        name,
        value: value,
        tags: tags,
        expiryMs: expiryMs,
      );

      updateResult.errorCode.throwOnError();
    } catch (e) {
      throw AskarSessionException('Failed to insert on session: $e');
    }
  }

  /// Replaces a record in the store matching a category and name.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  Future<void> replace({
    required String category,
    required String name,
    required String value,
    Map<String, dynamic>? tags,
    int? expiryMs,
  }) async {
    _throwOnNullHandle('Cannot replace with a closed session');

    try {
      final updateResult = await askarSessionUpdate(
        handle!,
        EntryOperation.replace,
        category,
        name,
        value: value,
        tags: tags,
        expiryMs: expiryMs,
      );

      updateResult.errorCode.throwOnError();
    } catch (e) {
      throw AskarSessionException('Failed to replace on session: $e');
    }
  }

  /// Removes a record by category and name.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  Future<void> remove({required String category, required String name}) async {
    _throwOnNullHandle('Cannot remove with a closed session');

    try {
      final updateResult = await askarSessionUpdate(
        handle!,
        EntryOperation.remove,
        category,
        name,
      );

      updateResult.errorCode.throwOnError();
    } catch (e) {
      throw AskarSessionException('Failed to remove on session: $e');
    }
  }

  /// Removes all records matching a category and tag filter.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  Future<void> removeAll({
    required String category,
    Map<String, dynamic>? tagFilter,
  }) async {
    _throwOnNullHandle('Cannot remove all with a closed session');

    try {
      final removeAllResult = await askarSessionRemoveAll(
        handle!,
        category,
        tagFilter: tagFilter,
      );

      removeAllResult.errorCode.throwOnError();
    } catch (e) {
      throw AskarSessionException('Failed to remove all on session: $e');
    }
  }

  /// Inserts a new key into the store.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  Future<void> insertKey({
    required String name,
    required Key key,
    String? metadata,
    Map<String, dynamic>? tags,
    int? expiryMs,
  }) async {
    _throwOnNullHandle('Cannot insert a key with a closed session');

    try {
      final insertKeyResult = await askarSessionInsertKey(
        handle!,
        key.handle,
        name,
        metadata: metadata,
        tags: tags,
        expiryMs: expiryMs,
      );

      insertKeyResult.errorCode.throwOnError();
    } catch (e) {
      throw AskarSessionException('Failed to insert key on session: $e');
    }
  }

  /// Fetches a key in the store by name.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  /// Returns a [KeyEntryObject] if the key is found, otherwise returns null.
  Future<KeyEntryObject?> fetchKey({required String name, bool forUpdate = false}) async {
    _throwOnNullHandle('Cannot fetch a key with a closed session');

    KeyEntryListHandle? keyEntryListHandle;

    try {
      final fetchKeyResult = await askarSessionFetchKey(handle!, name, forUpdate);

      if (!fetchKeyResult.errorCode.isSuccess()) return null;

      keyEntryListHandle = fetchKeyResult.value;

      final keyEntryObject =
          KeyEntryList(handle: keyEntryListHandle).getEntryByIndex(0).toJson();

      return keyEntryObject;
    } catch (e) {
      throw AskarSessionException('Failed to fetch key on session: $e');
    } finally {
      if (keyEntryListHandle != null) keyEntryListHandle.free();
    }
  }

  /// Fetches a set of keys in the store.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  /// Returns a list of [KeyEntryObject] containing the fetched keys.
  Future<List<KeyEntryObject>> fetchAllKeys({
    bool forUpdate = false,
    KeyAlgorithm? algorithm,
    int? limit,
    Map<String, dynamic>? tagFilter,
    String? thumbprint,
  }) async {
    _throwOnNullHandle('Cannot fetch all keys with a closed session');

    KeyEntryListHandle? keyEntryListHandle;

    try {
      final fetchKeyResult = await askarSessionFetchAllKeys(
        handle!,
        forUpdate: forUpdate,
        algorithm: algorithm,
        limit: limit,
        tagFilter: tagFilter,
        thumbprint: thumbprint,
      );

      if (!fetchKeyResult.errorCode.isSuccess()) return [];

      keyEntryListHandle = fetchKeyResult.value;

      return KeyEntryList(handle: keyEntryListHandle).toArray();
    } catch (e) {
      throw AskarSessionException('Failed to fetch keys on session: $e');
    } finally {
      if (keyEntryListHandle != null) keyEntryListHandle.free();
    }
  }

  /// Updates details of a key in the store.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  Future<void> updateKey({
    required String name,
    String? metadata,
    Map<String, dynamic>? tags,
    int? expiryMs,
  }) async {
    _throwOnNullHandle('Cannot update a key with a closed session');

    try {
      final callbackResult = await askarSessionUpdateKey(
        handle!,
        name,
        metadata: metadata,
        tags: tags,
        expiryMs: expiryMs,
      );

      callbackResult.throwOnError();
    } catch (e) {
      throw AskarSessionException('Failed to update key on session: $e');
    }
  }

  /// Removes a key from the store.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  Future<void> removeKey({required String name}) async {
    _throwOnNullHandle('Cannot remove a key with a closed session');

    try {
      final callbackResult = await askarSessionRemoveKey(handle!, name);

      callbackResult.throwOnError();
    } catch (e) {
      throw AskarSessionException('Failed to remove key on session: $e');
    }
  }

  /// Commits the current transaction and closes the session.
  ///
  /// Throws an [AskarSessionException] if the session is not a transaction or if it is closed.
  Future<void> commit() async {
    _throwWhenNotTransaction('Session is not a transaction');
    _throwOnNullHandle('Cannot commit a closed session');

    await handle!.close(true);
    handle = null;
  }

  /// Rolls back the current transaction and closes the session.
  ///
  /// Throws an [AskarSessionException] if the session is not a transaction or if it is closed.
  Future<void> rollback() async {
    _throwWhenNotTransaction('Session is not a transaction');
    _throwOnNullHandle('Cannot rollback a closed session');

    await handle!.close(false);
    handle = null;
  }

  /// Closes the session without specifying the commit behaviour.
  ///
  /// Throws an [AskarSessionException] if the session is closed.
  Future<void> close() async {
    _throwOnNullHandle('Cannot close a closed session');

    await handle!.close(false);
    handle = null;
  }

  /// Throws an exception if the session is not a transaction.
  void _throwWhenNotTransaction(String errorMsg) {
    if (!isTransaction) throw AskarSessionException(errorMsg);
  }

  /// Throws an exception if the session handle is null.
  void _throwOnNullHandle(String errorMsg) {
    if (handle == null) throw AskarSessionException(errorMsg);
  }
}
