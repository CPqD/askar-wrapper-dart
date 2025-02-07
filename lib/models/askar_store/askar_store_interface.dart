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
  Future<bool> listProfiles();
  Future<bool> rekey();
  Future<bool> remove();
  Future<bool> removeProfile();
  Future<bool> setDefaultProfile();
}
