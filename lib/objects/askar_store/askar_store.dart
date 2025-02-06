import 'package:import_so_libaskar/askar/enums/askar_error_code.dart';
import 'package:import_so_libaskar/objects/askar_exceptions/exceptions.dart';

import '../../askar/askar_wrapper.dart';
import '../../askar/enums/askar_store_key_method.dart';
import 'askar_store_interface.dart';

class AskarStore implements IAskarStore {
  final String specUri;
  final StoreKeyMethod method;
  final String passKey;
  final String profile;
  final bool recreate;

  StoreHandle? storeHandle;

  AskarStore(
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
      storeHandle = result.value;
      return true;
    }
    return false;
  }

  @override
  Future<bool> open() async {
    final result = await askarStoreOpen(specUri, method, passKey, profile);
    if (result.errorCode == ErrorCode.success) {
      storeHandle = result.value;
      return true;
    }
    return false;
  }

  @override
  Future<bool> close() async {
    if (storeHandle != null) {
      final result = await askarStoreClose(storeHandle!);
      if (result.errorCode == ErrorCode.success) {
        storeHandle = null;
        return true;
      }
    }
    return true;
  }

  @override
  Future<bool> createProfile() async {
    final result = await askarStoreCreateProfile(storeHandle!, "${profile}2");
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
    throw UnimplementedError();
  }

  @override
  Future<bool> generateRawKey() {
    throw UnimplementedError();
  }

  @override
  Future<bool> getDefaultProfile() {
    throw UnimplementedError();
  }

  @override
  Future<bool> getProfileName() {
    throw UnimplementedError();
  }

  @override
  Future<bool> listProfiles() {
    throw UnimplementedError();
  }

  @override
  Future<bool> rekey() {
    throw UnimplementedError();
  }

  @override
  Future<bool> remove() {
    throw UnimplementedError();
  }

  @override
  Future<bool> removeProfile() {
    throw UnimplementedError();
  }

  @override
  Future<bool> setDefaultProfile() {
    throw UnimplementedError();
  }
}
