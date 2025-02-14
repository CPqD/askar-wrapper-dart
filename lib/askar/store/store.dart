import 'dart:typed_data';

import 'package:askar_flutter_sdk/askar/askar_wrapper.dart';
import 'package:askar_flutter_sdk/askar/crypto/handles.dart';
import 'package:askar_flutter_sdk/askar/enums/askar_store_key_method.dart';
import 'package:askar_flutter_sdk/askar/exceptions/exceptions.dart';
import 'package:askar_flutter_sdk/askar/store/scan.dart';
import 'package:askar_flutter_sdk/askar/store/session.dart';
import 'open_session.dart';

class Store {
  final StoreHandle handle;
  final String uri;
  OpenSession? _opener;

  Store(this.handle, this.uri);

  static String generateRawKey({Uint8List? seed}) {
    try {
      return askarStoreGenerateRawKey(seed: seed).getValueOrException();
    } catch (e) {
      throw AskarStoreException('Failed to generate new raw key for store: $e');
    }
  }

  Future<void> createProfile({String? name}) async {
    try {
      (await askarStoreCreateProfile(handle, profile: name)).throwOnError();
    } catch (e) {
      throw AskarStoreException('Failed to create profile: $e');
    }
  }

  Future<String> getDefaultProfile() async {
    try {
      final result = await askarStoreGetDefaultProfile(handle);

      result.throwOnError();

      return result.value;
    } catch (e) {
      throw AskarStoreException('Failed to get default profile: $e');
    }
  }

  Future<void> setDefaultProfile(String name) async {
    try {
      (await askarStoreSetDefaultProfile(handle, name)).throwOnError();
    } catch (e) {
      throw AskarStoreException('Failed to set default profile: $e');
    }
  }

  Future<List<String>> listProfiles() async {
    StringListHandle? stringListHandle;

    try {
      stringListHandle = (await askarStoreListProfiles(handle)).getValueOrException();

      final count = askarStringListCount(stringListHandle).getValueOrException();

      List<String> profiles = [];

      for (int i = 0; i < count; i++) {
        final profile = askarStringListGetItem(stringListHandle, i).getValueOrException();
        profiles.add(profile);
      }

      return profiles;
    } catch (e) {
      throw AskarStoreException('Failed to list profiles: $e');
    } finally {
      if (stringListHandle != null) {
        askarStringListFree(stringListHandle);
      }
    }
  }

  Future<bool> removeProfile(String name) async {
    try {
      final result = await askarStoreRemoveProfile(handle, name);
      result.throwOnError();
      return result.value;
    } catch (e) {
      throw AskarStoreException('Failed to remove profile: $e');
    }
  }

  Future<void> rekey({StoreKeyMethod? keyMethod, required String passKey}) async {
    try {
      (await askarStoreRekey(handle, passKey, keyMethod: keyMethod)).throwOnError();
    } catch (e) {
      throw AskarStoreException('Failed to rekey: $e');
    }
  }

  static Future<Store> provision({
    required String uri,
    StoreKeyMethod? keyMethod,
    String? passKey,
    String? profile,
    required bool recreate,
  }) async {
    try {
      final storeHandle = (await askarStoreProvision(uri,
              recreate: recreate,
              keyMethod: keyMethod,
              passKey: passKey,
              profile: profile))
          .getValueOrException();

      return Store(storeHandle, uri);
    } catch (e) {
      throw AskarStoreException('Error on store provision: $e');
    }
  }

  static Future<Store> open({
    required String uri,
    StoreKeyMethod? keyMethod,
    String? passKey,
    String? profile,
  }) async {
    try {
      final storeHandle = (await askarStoreOpen(uri,
              keyMethod: keyMethod, passKey: passKey, profile: profile))
          .getValueOrException();

      return Store(storeHandle, uri);
    } catch (e) {
      throw AskarStoreException('Failed to open store: $e');
    }
  }

  Future<bool> close({bool remove = false}) async {
    _opener = null;

    await handle.close();

    return remove ? await Store.remove(uri) : false;
  }

  static Future<bool> remove(String uri) async {
    try {
      final result = await askarStoreRemove(uri);
      result.throwOnError();
      return result.value;
    } catch (e) {
      throw AskarStoreException('Failed to remove store: $e');
    }
  }



  OpenSession session({String? profile}) {
    return OpenSession(store: handle, profile: profile, isTransaction: false);
  }

  OpenSession transaction({String? profile}) {
    return OpenSession(store: handle, profile: profile, isTransaction: true);
  }

  Future<Session> openSession({bool isTransaction = false}) async {
    _opener ??= OpenSession(store: handle, isTransaction: isTransaction);
    return await _opener!.open();
  }

  Scan scan({
    required String category,
    Map<String, dynamic>? tagFilter,
    int? offset,
    int? limit,
    String? profile,
    String? orderBy,
    bool? descending,
  }) {
    return Scan(
      store: this,
      category: category,
      tagFilter: tagFilter,
      offset: offset,
      limit: limit,
      profile: profile,
      orderBy: orderBy,
      descending: descending,
    );
  }

/*
  // TODO
  Future<void> copyTo({
    required String uri,
    StoreKeyMethod? keyMethod,
    String? passKey,
    required bool recreate,
  }) async {
    try {
      await askarStoreCopyTo(
      storeHandle: handle,
      targetUri: uri,
      keyMethod: keyMethod?.toUri(),
      passKey: passKey,
      recreate: recreate,
    );
    } catch (e) {
      throw AskarStoreException('Failed to copy: $e');
    }
  }
  */
}
