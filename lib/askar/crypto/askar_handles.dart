import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:import_so_libaskar/askar/askar_native_functions.dart';
import 'package:import_so_libaskar/askar/askar_wrapper.dart';
import 'package:import_so_libaskar/askar/enums/askar_error_code.dart';
import 'package:import_so_libaskar/askar/exceptions/exceptions.dart';

class StoreHandle extends AskarHandle {
  StoreHandle(super.handle);

  Future<void> close() async {
    await askarStoreClose(this);
  }
}

class ScanHandle extends AskarHandle {
  ScanHandle(super.handle);

  void free() {
    askarScanFree(this);
  }
}

class SessionHandle extends AskarHandle {
  SessionHandle(super.handle);

  Future<void> close(bool commit) async {
    await askarSessionClose(this, commit);
  }
}

class EntryListHandle extends AskarHandle {
  EntryListHandle(super.handle);

  String getCategory(int index) {
    try {
      return askarEntryListGetCategory(this, index).getValueOrException();
    } catch (e) {
      throw AskarException('Failed to get category: $e');
    }
  }

  String getName(int index) {
    try {
      return askarEntryListGetName(this, index).getValueOrException();
    } catch (e) {
      throw AskarException('Failed to get name: $e');
    }
  }

  Uint8List getValue(int index) {
    try {
      return askarEntryListGetValue(this, index).getValueOrException();
    } catch (e) {
      throw AskarException('Failed to get value: $e');
    }
  }

  List<String> getTags(int index) {
    try {
      return askarEntryListGetTags(this, index).getValueOrException().keys.toList();
    } catch (e) {
      throw AskarException('Failed to get tags: $e');
    }
  }

  void free() {
    askarEntryListFree(this);
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

  List<String> getTags(int index) {
    try {
      return askarKeyEntryListGetTags(this, index).getValueOrException().keys.toList();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to get tags: $e');
    }
  }

  Map<String, dynamic> getMetadata(int index) {
    try {
      return jsonDecode(askarKeyEntryListGetMetadata(this, index).getValueOrException());
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
    askarKeyEntryListFree(this);
  }
}

class LocalKeyHandle extends AskarHandle {
  LocalKeyHandle(super.handle);

  void free() {
    askarKeyFree(this);
  }

  static LocalKeyHandle fromPointer(
      ErrorCode errorCode, Pointer<NativeLocalKeyHandle> ptr) {
    return LocalKeyHandle(errorCode == ErrorCode.success ? ptr.value : 0);
  }
}

class AskarHandle {
  final int handle;

  AskarHandle(this.handle);

  int toInt() {
    return handle;
  }
}
