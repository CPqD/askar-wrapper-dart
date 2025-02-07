abstract class IAskarKeyEntryList {
  Future<bool> count();
  Future<bool> free();
  Future<bool> getAlgorithm();
  Future<bool> getMetadata();
  Future<bool> getName();
  Future<bool> getTags();
  Future<bool> loadLocal();
}
