abstract class IAskarEntryList {
  Future<bool> count();
  Future<bool> free();
  Future<bool> getCategory();
  Future<bool> getName();
  Future<bool> getTags();
  Future<bool> getValue();
}
