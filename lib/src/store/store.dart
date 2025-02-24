import 'dart:typed_data';

import '../askar_wrapper.dart';
import '../crypto/handles.dart';
import '../enums/askar_store_key_method.dart';
import '../exceptions/exceptions.dart';
import 'scan.dart';
import 'session.dart';
import 'open_session.dart';

/// An opened Store instance.
///
/// This class represents an active store, including its [handle] and [uri].
class Store {
  /// The handle for the store.
  final StoreHandle handle;

  /// The URI of the store.
  final String uri;

  OpenSession? _opener;

  /// Constructs an instance of [Store].
  Store(this.handle, this.uri);

  /// Generates a new raw key for a Store.
  ///
  /// Throws an [AskarStoreException] if the key generation fails.
  static String generateRawKey({Uint8List? seed}) {
    try {
      return askarStoreGenerateRawKey(seed: seed).getValueOrException();
    } catch (e) {
      throw AskarStoreException('Failed to generate new raw key for store: $e');
    }
  }

  /// Creates a new profile in the store.
  ///
  /// Throws an [AskarStoreException] if the profile creation fails.
  /// Returns the name of the profile, which is automatically generated if not provided.
  Future<void> createProfile({String? name}) async {
    try {
      (await askarStoreCreateProfile(handle, profile: name)).throwOnError();
    } catch (e) {
      throw AskarStoreException('Failed to create profile: $e');
    }
  }

  /// Gets the currently selected profile name.
  ///
  /// Throws an [AskarStoreException] if the profile name retrieval fails.
  Future<String> getProfileName() async {
    try {
      final result = await askarStoreGetProfileName(handle);
      return result.getValueOrException();
    } catch (e) {
      throw AskarStoreException('Failed to get profile name: $e');
    }
  }

  /// Gets the default profile name when the store is opened.
  ///
  /// Throws an [AskarStoreException] if the default profile name retrieval fails.
  Future<String> getDefaultProfile() async {
    try {
      final result = await askarStoreGetDefaultProfile(handle);

      result.throwOnError();

      return result.value;
    } catch (e) {
      throw AskarStoreException('Failed to get default profile: $e');
    }
  }

  /// Sets the default profile name when the store is opened.
  ///
  /// Throws an [AskarStoreException] if setting the default profile fails.
  Future<void> setDefaultProfile(String name) async {
    try {
      (await askarStoreSetDefaultProfile(handle, name)).throwOnError();
    } catch (e) {
      throw AskarStoreException('Failed to set default profile: $e');
    }
  }

  /// Lists the profile identifiers present in the store.
  ///
  /// Throws an [AskarStoreException] if listing profiles fails.
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

  /// Removes a profile from the store.
  ///
  /// Throws an [AskarStoreException] if removing the profile fails.
  Future<bool> removeProfile(String name) async {
    try {
      final result = await askarStoreRemoveProfile(handle, name);
      result.throwOnError();
      return result.value;
    } catch (e) {
      throw AskarStoreException('Failed to remove profile: $e');
    }
  }

  /// Updates the master encryption key of the store.
  ///
  /// Throws an [AskarStoreException] if rekeying fails.
  Future<void> rekey({StoreKeyMethod? keyMethod, required String passKey}) async {
    try {
      (await askarStoreRekey(handle, passKey, keyMethod: keyMethod)).throwOnError();
    } catch (e) {
      throw AskarStoreException('Failed to rekey: $e');
    }
  }

  /// Provisions a new store.
  ///
  /// Throws an [AskarStoreException] if provisioning fails.
  static Future<Store> provision({
    required String uri,
    StoreKeyMethod? keyMethod,
    String? passKey,
    String? profile,
    required bool recreate,
  }) async {
    try {
      final storeHandle =
          (await askarStoreProvision(
            uri,
            recreate: recreate,
            keyMethod: keyMethod,
            passKey: passKey,
            profile: profile,
          )).getValueOrException();

      return Store(storeHandle, uri);
    } catch (e) {
      throw AskarStoreException('Error on store provision: $e');
    }
  }

  /// Opens an existing store.
  ///
  /// Throws an [AskarStoreException] if opening the store fails.
  static Future<Store> open({
    required String uri,
    StoreKeyMethod? keyMethod,
    String? passKey,
    String? profile,
  }) async {
    try {
      final storeHandle =
          (await askarStoreOpen(
            uri,
            keyMethod: keyMethod,
            passKey: passKey,
            profile: profile,
          )).getValueOrException();

      return Store(storeHandle, uri);
    } catch (e) {
      throw AskarStoreException('Failed to open store: $e');
    }
  }

  /// Closes and frees the store instance.
  ///
  /// Throws an [AskarStoreException] if closing the store fails.
  Future<bool> close({bool remove = false}) async {
    _opener = null;

    await handle.close();

    return remove ? await Store.remove(uri) : false;
  }

  /// Removes an existing store.
  ///
  /// Throws an [AskarStoreException] if removing the store fails.
  static Future<bool> remove(String uri) async {
    try {
      final result = await askarStoreRemove(uri);
      result.throwOnError();
      return result.value;
    } catch (e) {
      throw AskarStoreException('Failed to remove store: $e');
    }
  }

  /// Opens a new session on the store without starting a transaction.
  OpenSession session({String? profile}) {
    return OpenSession(store: handle, profile: profile, isTransaction: false);
  }

  /// Opens a new transactional session on the store.
  OpenSession transaction({String? profile}) {
    return OpenSession(store: handle, profile: profile, isTransaction: true);
  }

  /// Opens a session on the store.
  ///
  /// Throws an [AskarStoreException] if opening the session fails.
  Future<Session> openSession({bool isTransaction = false}) async {
    _opener ??= OpenSession(store: handle, isTransaction: isTransaction);
    return await _opener!.open();
  }

  /// Starts a new record scan.
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

  /// Copies the store contents to a new location.
  ///
  /// Throws an [AskarStoreException] if copying the store fails.
  Future<StoreHandle> copyTo({
    required String uri,
    StoreKeyMethod? keyMethod,
    String? passKey,
    required bool recreate,
  }) async {
    try {
      final result = await askarStoreCopy(handle, uri, keyMethod, passKey, recreate);
      return result.value;
    } catch (e) {
      throw AskarStoreException('Failed to copy: $e');
    }
  }
}
