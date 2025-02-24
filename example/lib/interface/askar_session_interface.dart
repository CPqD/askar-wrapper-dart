import 'package:askar_wrapper_dart/askar_wrapper_dart.dart';

/// Interface for managing Askar sessions.
///
/// The [IAskarSession] interface defines methods for starting, closing, and performing various operations within an Askar session.
abstract class IAskarSession {
  /// Starts the session.
  ///
  /// Returns a [Future] that completes with `true` if the session starts successfully, otherwise `false`.
  Future<bool> start();

  /// Closes the session.
  ///
  /// The [commit] parameter indicates whether to commit the session.
  /// Returns a [Future] that completes with `true` if the session closes successfully, otherwise `false`.
  Future<bool> close({required bool commit});

  /// Returns the count of entries in the specified [category] that match the [tagFilter].
  ///
  /// The [category] parameter specifies the category of entries.
  /// The [tagFilter] parameter specifies the tags to filter the entries.
  /// Returns a [Future] that completes with the count of matching entries.
  Future<int> sessionCount(String category, Map<String, String> tagFilter);

  /// Fetches an entry from the specified [category] with the given [name].
  ///
  /// The [forUpdate] parameter indicates whether the entry is fetched for update.
  /// Returns a [Future] that completes with an [EntryListHandle] if the entry is found, otherwise `null`.
  Future<EntryListHandle?> fetch(String category, String name, bool forUpdate);

  /// Fetches all entries from the specified [category] that match the [tagFilter].
  ///
  /// The [limit] parameter specifies the maximum number of entries to fetch.
  /// The [forUpdate] parameter indicates whether the entries are fetched for update.
  /// Returns a [Future] that completes with an [EntryListHandle] if entries are found, otherwise `null`.
  Future<EntryListHandle?> fetchAll(
    String category,
    Map tagFilter,
    int limit,
    bool forUpdate,
  );

  /// Fetches all keys that match the specified [algorithm], [thumbprint], and [tagFilter].
  ///
  /// The [limit] parameter specifies the maximum number of keys to fetch.
  /// The [forUpdate] parameter indicates whether the keys are fetched for update.
  /// Returns a [Future] that completes with a [KeyEntryListHandle] if keys are found, otherwise `null`.
  Future<KeyEntryListHandle?> fetchAllKeys(
    KeyAlgorithm algorithm,
    String thumbprint,
    Map tagFilter,
    int limit,
    bool forUpdate,
  );

  /// Fetches a key with the given [name].
  ///
  /// The [forUpdate] parameter indicates whether the key is fetched for update.
  /// Returns a [Future] that completes with a [KeyEntryListHandle] if the key is found, otherwise `null`.
  Future<KeyEntryListHandle?> fetchKey(String name, bool forUpdate);

  /// Inserts keys into the store.
  ///
  /// The [localKeyHandle], [name], [metadata], [tags], and [expiryMs] parameters specify the key details.
  /// Returns a [Future] that completes with `true` if the keys are inserted successfully, otherwise `false`.
  Future<bool> insertKeys(
    LocalKeyHandle localKeyHandle,
    String name,
    String metadata,
    Map<String, dynamic> tags,
    int expiryMs,
  );

  /// Removes all entries from the specified [category] that match the [tagFilter].
  ///
  /// Returns a [Future] that completes with `true` if the entries are removed successfully, otherwise `false`.
  Future<bool> removeAll(String category, Map<String, dynamic> tagFilter);

  /// Removes a key with the given [name].
  ///
  /// Returns a [Future] that completes with `true` if the key is removed successfully, otherwise `false`.
  Future<bool> removeKey(String name);

  /// Updates an entry in the store.
  ///
  /// The [operation], [category], [name], [value], [tags], and [expiryMs] parameters specify the entry details.
  /// Returns a [Future] that completes with `true` if the entry is updated successfully, otherwise `false`.
  Future<bool> update(
    EntryOperation operation,
    String category,
    String name,
    String value,
    Map<String, String> tags,
    int expiryMs,
  );

  /// Updates a key in the store.
  ///
  /// The [name], [metadata], [tags], and [expiryMs] parameters specify the key details.
  /// Returns a [Future] that completes with `true` if the key is updated successfully, otherwise `false`.
  Future<bool> updateKey(String name, String metadata, String tags, int expiryMs);
}
