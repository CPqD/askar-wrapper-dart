import 'package:askar_flutter_sdk/askar/askar_wrapper.dart';
import 'package:askar_flutter_sdk/askar/exceptions/exceptions.dart';

import 'key_entry.dart';
import 'package:askar_flutter_sdk/askar/crypto/handles.dart';

class KeyEntryList {
  final KeyEntryListHandle handle;

  KeyEntryList({required this.handle});

  int get length {
    try {
      return askarKeyEntryListCount(handle).getValueOrException();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to count key entry list: $e');
    }
  }

  KeyEntry getEntryByIndex(int index) {
    return KeyEntry(list: handle, pos: index);
  }

  void forEachKeyEntry(void Function(KeyEntry entry, int index) cb) {
    for (int i = 0; i < length; i++) {
      cb(getEntryByIndex(i), i);
    }
  }

  List<KeyEntryObject> toArray() {
    final list = <KeyEntryObject>[];
    forEachKeyEntry((key, _) => list.add(key.toJson()));
    return list;
  }
}
