import '../../askar/askar_wrapper.dart';
import '../../askar/enums/askar_key_algorithm.dart';

abstract class IAskarSession {
  Future<bool> start();

  Future<bool> close({required bool commit});

  Future<int> sessionCount();

  Future<EntryListHandle?> fetch(String category, String name, bool forUpdate);

  Future<EntryListHandle?> fetchAll(
      String category, Map tagFilter, int limit, bool forUpdate);

  Future<KeyEntryListHandle?> fetchAllKeys(KeyAlgorithm algorithm, String thumbprint,
      Map tagFilter, int limit, bool forUpdate);

  Future<KeyEntryListHandle?> fetchKeys(String name, bool forUpdate);

  Future<bool> insertKeys(LocalKeyHandle localKeyHandle, String name, String metadata,
      Map tags, int expiryMs);

  Future<bool> removeAll(String category, String tagFilter);

  Future<bool> removeKey();

  Future<bool> update();

  Future<bool> updateKey();
}
