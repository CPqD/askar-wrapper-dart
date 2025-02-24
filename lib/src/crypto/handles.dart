import 'dart:ffi';
import 'dart:typed_data';

import '../askar_native_functions.dart';
import '../askar_wrapper.dart';
import '../enums/askar_error_code.dart';
import '../exceptions/exceptions.dart';

/// A base class for Askar handles.
class AskarHandle {
  final int handle;

  /// Constructs an instance of [AskarHandle].
  AskarHandle(this.handle);

  /// Returns the handle as an integer.
  int toInt() {
    return handle;
  }

  @override
  String toString() {
    return "AskarHandle($handle)";
  }
}

/// Handle for an active Store instance.
class StoreHandle extends AskarHandle {
  StoreHandle(super.handle);

  /// Closes the store.
  ///
  /// Manually close the store, waiting for any active connections.
  ///
  /// Throws an [AskarStoreException] if the store fails to close.
  Future<void> close() async {
    try {
      (await askarStoreClose(this)).throwOnError();
    } catch (e) {
      throw AskarStoreException('Failed to close store: $e');
    }
  }

  @override
  String toString() {
    return "StoreHandle($handle)";
  }
}

/// Handle for an active Store scan instance.
class ScanHandle extends AskarHandle {
  ScanHandle(super.handle);

  /// Frees the scan.
  ///
  /// Throws an [AskarScanException] if the scan fails to free.
  void free() {
    try {
      askarScanFree(this).throwOnError();
    } catch (e) {
      throw AskarScanException('Failed to free scan: $e');
    }
  }

  @override
  String toString() {
    return "ScanHandle($handle)";
  }
}

// Handle for an active Session/Transaction instance.
class SessionHandle extends AskarHandle {
  SessionHandle(super.handle);

  /// Closes the session.
  ///
  /// The [commit] parameter indicates whether to commit the session.
  ///
  /// Throws an [AskarSessionException] if the session fails to close.
  Future<void> close(bool commit) async {
    try {
      (await askarSessionClose(this, commit)).throwOnError();
    } catch (e) {
      throw AskarSessionException('Failed to close session: $e');
    }
  }

  @override
  String toString() {
    return "SessionHandle($handle)";
  }
}

/// Handle for an active EntryList instance.
class EntryListHandle extends AskarHandle {
  EntryListHandle(super.handle);

  /// Gets the category of the entry at the specified [index].
  ///
  /// Throws an [AskarEntryListException] if the category retrieval fails.
  String getCategory(int index) {
    try {
      return askarEntryListGetCategory(this, index).getValueOrException();
    } catch (e) {
      throw AskarEntryListException('Failed to get category: $e');
    }
  }

  /// Gets the name of the entry at the specified [index].
  ///
  /// Throws an [AskarEntryListException] if the name retrieval fails.
  String getName(int index) {
    try {
      return askarEntryListGetName(this, index).getValueOrException();
    } catch (e) {
      throw AskarEntryListException('Failed to get name: $e');
    }
  }

  /// Gets the value of the entry at the specified [index].
  ///
  /// Throws an [AskarEntryListException] if the value retrieval fails.
  Uint8List getValue(int index) {
    try {
      return askarEntryListGetValue(this, index).getValueOrException();
    } catch (e) {
      throw AskarEntryListException('Failed to get value: $e');
    }
  }

  /// Gets the tags of the entry at the specified [index].
  ///
  /// Throws an [AskarEntryListException] if the tags retrieval fails.
  String getTags(int index) {
    try {
      return askarEntryListGetTags(this, index).getValueOrException();
    } catch (e) {
      throw AskarEntryListException('Failed to get tags: $e');
    }
  }

  /// Frees the entry list.
  ///
  /// Throws an [AskarEntryListException] if the entry list fails to free.
  void free() {
    try {
      askarEntryListFree(this);
    } catch (e) {
      throw AskarEntryListException('Failed to free entry list: $e');
    }
  }

  @override
  String toString() {
    return "EntryListHandle($handle)";
  }
}

/// Handle for an active KeyEntryList instance.
class KeyEntryListHandle extends AskarHandle {
  KeyEntryListHandle(super.handle);

  /// Gets the algorithm of the key entry at the specified [index].
  ///
  /// Throws an [AskarKeyEntryListException] if the algorithm retrieval fails.
  String getAlgorithm(int index) {
    try {
      return askarKeyEntryListGetAlgorithm(this, index).getValueOrException();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to get algorithm: $e');
    }
  }

  /// Gets the name of the key entry at the specified [index].
  ///
  /// Throws an [AskarKeyEntryListException] if the name retrieval fails.
  String getName(int index) {
    try {
      return askarKeyEntryListGetName(this, index).getValueOrException();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to get name: $e');
    }
  }

  /// Gets the tags of the key entry at the specified [index].
  ///
  /// Throws an [AskarKeyEntryListException] if the tags retrieval fails.
  String getTags(int index) {
    try {
      return askarKeyEntryListGetTags(this, index).getValueOrException();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to get tags: $e');
    }
  }

  /// Gets the metadata of the key entry at the specified [index].
  ///
  /// Throws an [AskarKeyEntryListException] if the metadata retrieval fails.
  String getMetadata(int index) {
    try {
      return askarKeyEntryListGetMetadata(this, index).getValueOrException();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to get metadata: $e');
    }
  }

  /// Loads the key at the specified [index].
  ///
  /// Throws an [AskarKeyEntryListException] if the key loading fails.
  LocalKeyHandle loadKey(int index) {
    try {
      return askarKeyEntryListLoadLocal(this, index).getValueOrException();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to load key: $e');
    }
  }

  /// Frees the key entry list.
  ///
  /// Throws an [AskarKeyEntryListException] if the key entry list fails to free.
  void free() {
    try {
      askarKeyEntryListFree(this);
    } catch (e) {
      throw AskarKeyEntryListException('Failed to free key entry list: $e');
    }
  }

  @override
  String toString() {
    return "KeyEntryListHandle($handle)";
  }
}

/// Handle for an active LocalKey instance.
class LocalKeyHandle extends AskarHandle {
  LocalKeyHandle(super.handle);

  /// Frees the key.
  ///
  /// Throws an [AskarKeyException] if the key fails to free.
  void free() {
    try {
      askarKeyFree(this);
    } catch (e) {
      throw AskarKeyException('Failed to free key: $e');
    }
  }

  /// Creates a [LocalKeyHandle] from a pointer.
  ///
  /// The [errorCode] indicates the success or failure of the operation.
  /// The [ptr] is a pointer to the native local key handle.
  static LocalKeyHandle fromPointer(
    ErrorCode errorCode,
    Pointer<NativeLocalKeyHandle> ptr,
  ) {
    return LocalKeyHandle(errorCode == ErrorCode.success ? ptr.value : 0);
  }

  @override
  String toString() {
    return "LocalKeyHandle($handle)";
  }
}
