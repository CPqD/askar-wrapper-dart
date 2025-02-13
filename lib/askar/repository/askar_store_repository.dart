import 'dart:math';
import 'dart:typed_data';

import '../askar_wrapper.dart';
import '../crypto/handles.dart';
import '../enums/askar_error_code.dart';
import '../enums/askar_store_key_method.dart';
import '../exceptions/exceptions.dart';
import '../repository/askar_string_repository.dart';

class StoreRepository {
  final String specUri;
  final StoreKeyMethod method;
  final String passKey;
  final String profile;
  final bool recreate;

  AskarHandle? handle;

  StoreRepository(
      {required this.specUri,
      required this.method,
      required this.passKey,
      required this.profile,
      this.recreate = false}) {
    if (recreate) {
      provision();
    } else {
      open().then((resp) async {
        if (resp) {
          print('Store Opened');
        } else {
          print('Store not Opened - Provisioning');
          await provision();
        }
      });
    }
  }

  Future<bool> provision() async {
    final result = await askarStoreProvision(specUri,
        keyMethod: method, passKey: passKey, profile: profile, recreate: recreate);
    if (result.errorCode == ErrorCode.success) {
      handle = result.value;
      return true;
    }
    return false;
  }

  checkStore() {
    if (handle == null) {
      throw AskarStoreException("Store não iniciado");
    }
  }

  Future<bool> open() async {
    final result = await askarStoreOpen(specUri,
        keyMethod: method, passKey: passKey, profile: profile);
    if (result.errorCode == ErrorCode.success) {
      handle = result.value;
      return true;
    }
    return false;
  }

  Future<bool> close() async {
    if (handle != null) {
      final result = await askarStoreClose(StoreHandle(handle!.toInt()));
      if (result.errorCode == ErrorCode.success) {
        handle = null;
        return true;
      }
    }
    return true;
  }

  Future<bool> createProfile() async {
    checkStore();
    final result = await askarStoreCreateProfile(StoreHandle(handle!.toInt()),
        profile: "${profile}2");
    if (result.errorCode == ErrorCode.duplicate) {
      throw ProfileDuplicatedException("Este Profile já existe");
    }
    if (result.errorCode == ErrorCode.success) {
      return true;
    }
    return false;
  }

  Future<bool> copy() {
    checkStore();
    throw UnimplementedError();
  }

  String generateRawKey({Uint8List? seed}) {
    checkStore();
    final result = askarStoreGenerateRawKey(seed: seed ?? _generateRandomSeed());
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return '';
  }

  Future<String> getDefaultProfile() async {
    checkStore();
    final result = await askarStoreGetDefaultProfile(StoreHandle(handle!.toInt()));
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return '';
  }

  Future<String> getProfileName() async {
    checkStore();
    final result = await askarStoreGetProfileName(StoreHandle(handle!.toInt()));
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return '';
  }

  Future<List<String>> listProfiles() async {
    checkStore();
    final result = await askarStoreListProfiles(StoreHandle(handle!.toInt()));
    if (result.errorCode == ErrorCode.success) {
      final stringList = AskarStringRepository(handle: handle!.toInt());
      return stringList.getAllItems();
    }
    return [];
  }

  Future<bool> rekey(String newPassKey) async {
    checkStore();
    final result =
        await askarStoreRekey(StoreHandle(handle!.toInt()), keyMethod: method, passKey);
    if (result.errorCode == ErrorCode.success) {
      return true;
    }
    return false;
  }

  Future<bool> remove() {
    checkStore();
    throw UnimplementedError();
  }

  Future<bool> removeProfile() {
    checkStore();
    throw UnimplementedError();
  }

  Future<bool> setDefaultProfile(String profileName) async {
    checkStore();
    final result =
        await askarStoreSetDefaultProfile(StoreHandle(handle!.toInt()), profileName);
    if (result.errorCode == ErrorCode.success) {
      return true;
    }
    return false;
  }

  Uint8List _generateRandomSeed() {
    final random = Random.secure();
    final seed = List<int>.generate(32, (_) => random.nextInt(256));
    return Uint8List.fromList(seed);
  }
}
