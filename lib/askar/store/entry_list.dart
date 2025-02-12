import 'package:askar_flutter_sdk/askar/askar_wrapper.dart';
import 'package:askar_flutter_sdk/askar/crypto/handles.dart';
import 'package:askar_flutter_sdk/askar/exceptions/exceptions.dart';
import 'package:askar_flutter_sdk/askar/store/entry.dart';

class EntryList {
  final EntryListHandle handle;

  EntryList({required this.handle});

  int get length {
    try {
      return askarEntryListCount(handle).getValueOrException();
    } catch (e) {
      throw AskarEntryListException('Failed to count entry list: $e');
    }
  }

  Entry getEntryByIndex(int index) {
    return Entry(list: handle, position: index);
  }

  void forEachEntry(void Function(Entry entry, int index) fn) {
    for (int i = 0; i < length; i++) {
      fn(getEntryByIndex(i), i);
    }
  }

  Entry? find(bool Function(Entry entry, int index) cb) {
    for (int i = 0; i < length; i++) {
      final item = getEntryByIndex(i);
      if (cb(item, i)) return item;
    }
    return null;
  }

  List<EntryObject> toArray({bool valuesAreJson = false}) {
    final list = <EntryObject>[];
    forEachEntry(
        (entry, _) => list.add(entry.toJson(shouldParseValueToJson: valuesAreJson)));
    return list;
  }
}
