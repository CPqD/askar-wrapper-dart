abstract class IAskarStore {
  Future<bool> provision();
  Future<bool> open();
  Future<bool> close();
  Future<bool> createProfile();
  Future<bool> copy();
  Future<bool> generateRawKey();
  Future<bool> getDefaultProfile();
  Future<bool> getProfileName();
  Future<bool> listProfiles();
  Future<bool> rekey();
  Future<bool> remove();
  Future<bool> removeProfile();
  Future<bool> setDefaultProfile();
}
