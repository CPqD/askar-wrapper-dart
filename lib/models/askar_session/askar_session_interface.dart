import '../../askar/askar_wrapper.dart';
import '../../askar/enums/askar_entry_operation.dart';
import '../../askar/enums/askar_key_algorithm.dart';

abstract class IAskarSession {
  Future<bool> start();

  Future<bool> close({required bool commit});

  Future<int> sessionCount(String category, Map<String, String> tagFilter);

  Future<EntryListHandle?> fetch(String category, String name, bool forUpdate);

  Future<EntryListHandle?> fetchAll(
      String category, Map tagFilter, int limit, bool forUpdate);

  Future<KeyEntryListHandle?> fetchAllKeys(KeyAlgorithm algorithm, String thumbprint,
      Map tagFilter, int limit, bool forUpdate);

  Future<KeyEntryListHandle?> fetchKeys(String name, bool forUpdate);

  Future<bool> insertKeys(LocalKeyHandle localKeyHandle, String name, String metadata,
      Map tags, int expiryMs);

  Future<bool> removeAll(String category, Map tagFilter);

  Future<bool> removeKey(String name);

  Future<bool> update(EntryOperation operation, String category, String name,
      String value, Map<String, String> tags, int expiryMs);

  Future<bool> updateKey(String name, String metadata, String tags, int expiryMs);
}
