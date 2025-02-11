import 'dart:math';
import 'dart:typed_data';

import '../../askar/crypto/askar_handles.dart';
import '../../askar/enums/askar_error_code.dart';
import '../../askar/exceptions/exceptions.dart';
import '../../askar/repository/askar_string_repository.dart';

import '../askar_wrapper.dart';
import '../enums/askar_store_key_method.dart';
import '../interface/askar_store_interface.dart';

class AskarStoreRepository implements IAskarStore {
  final String specUri;
  final StoreKeyMethod method;
  final String passKey;
  final String profile;
  final bool recreate;

  AskarHandle? handle;

  AskarStoreRepository(
      {required this.specUri,
      required this.method,
      required this.passKey,
      required this.profile,
      this.recreate = false}) {
    open().then((resp) async {
      if (recreate) {
        print('Store Provision');
        await provision();
        return;
      }
      if (resp) {
        print('Store Opened');
      } else {
        print('Store not Opened - Provisioning');
        await provision();
      }
    });
  }
  @override
  Future<bool> provision() async {
    final result = await askarStoreProvision(specUri, method, passKey, profile, recreate);
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

  @override
  Future<bool> open() async {
    final result = await askarStoreOpen(specUri, method, passKey, profile);
    if (result.errorCode == ErrorCode.success) {
      handle = result.value;
      return true;
    }
    return false;
  }

  @override
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

  @override
  Future<bool> createProfile() async {
    checkStore();
    final result =
        await askarStoreCreateProfile(StoreHandle(handle!.toInt()), "${profile}2");
    if (result.errorCode == ErrorCode.duplicate) {
      throw ProfileDuplicatedException("Este Profile já existe");
    }
    if (result.errorCode == ErrorCode.success) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> copy() {
    checkStore();
    throw UnimplementedError();
  }

  @override
  String generateRawKey({Uint8List? seed}) {
    checkStore();
    final result = askarStoreGenerateRawKey(seed: seed ?? _generateRandomSeed());
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return '';
  }

  @override
  Future<String> getDefaultProfile() async {
    checkStore();
    final result = await askarStoreGetDefaultProfile(StoreHandle(handle!.toInt()));
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return '';
  }

  @override
  Future<String> getProfileName() async {
    checkStore();
    final result = await askarStoreGetProfileName(StoreHandle(handle!.toInt()));
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return '';
  }

  @override
  Future<List<String>> listProfiles() async {
    checkStore();
    final result = await askarStoreListProfiles(StoreHandle(handle!.toInt()));
    if (result.errorCode == ErrorCode.success) {
      final stringList = AskarStringRepository(handle: handle!.toInt());
      return stringList.getAllItems();
    }
    return [];
  }

  @override
  Future<bool> rekey(String newPassKey) async {
    checkStore();
    final result =
        await askarStoreRekey(StoreHandle(handle!.toInt()), method, newPassKey);
    if (result.errorCode == ErrorCode.success) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> remove() {
    checkStore();
    throw UnimplementedError();
  }

  @override
  Future<bool> removeProfile() {
    checkStore();
    throw UnimplementedError();
  }

  @override
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
