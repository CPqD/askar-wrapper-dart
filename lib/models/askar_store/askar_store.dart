import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:import_so_libaskar/askar/enums/askar_error_code.dart';
import 'package:import_so_libaskar/models/askar_exceptions/exceptions.dart';

import '../../askar/askar_wrapper.dart';
import '../../askar/enums/askar_store_key_method.dart';
import 'askar_store_interface.dart';

class AskarStore implements IAskarStore {
  final String specUri;
  final StoreKeyMethod method;
  final String passKey;
  final String profile;
  final bool recreate;

  StoreHandle? handle;

  AskarStore(
      {required this.specUri,
      required this.method,
      required this.passKey,
      required this.profile,
      this.recreate = false}) {
    open().then((resp) async {
      if (recreate) {
        debugPrint('Store Provision');
        await provision();
        return;
      }
      if (resp) {
        debugPrint('Store Opened');
      } else {
        debugPrint('Store not Opened - Provisioning');
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
      final result = await askarStoreClose(handle!);
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
    final result = await askarStoreCreateProfile(handle!, "${profile}2");
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
    final result = await askarStoreGetDefaultProfile(handle!);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return '';
  }

  @override
  Future<String> getProfileName() async {
    checkStore();
    final result = await askarStoreGetProfileName(handle!);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return '';
  }

  @override
  Future<bool> listProfiles() {
    checkStore();
    throw UnimplementedError();
  }

  @override
  Future<bool> rekey() {
    checkStore();
    throw UnimplementedError();
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
  Future<bool> setDefaultProfile() {
    checkStore();
    throw UnimplementedError();
  }

  Uint8List _generateRandomSeed() {
    final random = Random.secure();
    final seed = List<int>.generate(32, (_) => random.nextInt(256));
    return Uint8List.fromList(seed);
  }
}
