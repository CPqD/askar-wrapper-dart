import 'dart:typed_data';

abstract class IAskarStore {
  Future<bool> provision();
  Future<bool> open();
  Future<bool> close();
  Future<bool> createProfile();
  Future<bool> copy();
  String generateRawKey({Uint8List? seed});
  Future<String> getDefaultProfile();
  Future<String> getProfileName();
  Future<List<String>> listProfiles();
  Future<bool> rekey(String newPassKey);
  Future<bool> remove();
  Future<bool> removeProfile();
  Future<bool> setDefaultProfile(String profileName);
}
