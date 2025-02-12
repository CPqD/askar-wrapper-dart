import 'dart:ffi';
import 'dart:typed_data';

import '../askar_native_functions.dart';
import '../askar_wrapper.dart';
import '../enums/askar_error_code.dart';
import '../exceptions/exceptions.dart';

class StoreHandle extends AskarHandle {
  StoreHandle(super.handle);

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

class ScanHandle extends AskarHandle {
  ScanHandle(super.handle);

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

class SessionHandle extends AskarHandle {
  SessionHandle(super.handle);

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

class EntryListHandle extends AskarHandle {
  EntryListHandle(super.handle);

  String getCategory(int index) {
    try {
      return askarEntryListGetCategory(this, index).getValueOrException();
    } catch (e) {
      throw AskarEntryListException('Failed to get category: $e');
    }
  }

  String getName(int index) {
    try {
      return askarEntryListGetName(this, index).getValueOrException();
    } catch (e) {
      throw AskarEntryListException('Failed to get name: $e');
    }
  }

  Uint8List getValue(int index) {
    try {
      return askarEntryListGetValue(this, index).getValueOrException();
    } catch (e) {
      throw AskarEntryListException('Failed to get value: $e');
    }
  }

  String getTags(int index) {
    try {
      return askarEntryListGetTags(this, index).getValueOrException();
    } catch (e) {
      throw AskarEntryListException('Failed to get tags: $e');
    }
  }

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

class KeyEntryListHandle extends AskarHandle {
  KeyEntryListHandle(super.handle);

  String getAlgorithm(int index) {
    try {
      return askarKeyEntryListGetAlgorithm(this, index).getValueOrException();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to get algorithm: $e');
    }
  }

  String getName(int index) {
    try {
      return askarKeyEntryListGetName(this, index).getValueOrException();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to get name: $e');
    }
  }

  String getTags(int index) {
    try {
      return askarKeyEntryListGetTags(this, index).getValueOrException();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to get tags: $e');
    }
  }

  String getMetadata(int index) {
    try {
      return askarKeyEntryListGetMetadata(this, index).getValueOrException();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to get metadata: $e');
    }
  }

  LocalKeyHandle loadKey(int index) {
    try {
      return askarKeyEntryListLoadLocal(this, index).getValueOrException();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to load key: $e');
    }
  }

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

class LocalKeyHandle extends AskarHandle {
  LocalKeyHandle(super.handle);

  void free() {
    try {
      askarKeyFree(this);
    } catch (e) {
      throw AskarKeyException('Failed to free key: $e');
    }
  }

  static LocalKeyHandle fromPointer(
      ErrorCode errorCode, Pointer<NativeLocalKeyHandle> ptr) {
    return LocalKeyHandle(errorCode == ErrorCode.success ? ptr.value : 0);
  }

  @override
  String toString() {
    return "LocalKeyHandle($handle)";
  }
}

class AskarHandle {
  final int handle;

  AskarHandle(this.handle);

  int toInt() {
    return handle;
  }

  @override
  String toString() {
    return "AskarHandle($handle)";
  }
}
