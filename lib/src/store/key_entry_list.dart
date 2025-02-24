import '../askar_wrapper.dart';
import '../exceptions/exceptions.dart';

import 'key_entry.dart';
import '../crypto/handles.dart';

/// A list of key query results.
///
/// This class represents a list of key entries retrieved from a query, including methods to access and manipulate the entries.
class KeyEntryList {
  /// The handle for the key entry list.
  final KeyEntryListHandle handle;

  /// Constructs an instance of [KeyEntryList].
  KeyEntryList({required this.handle});

  /// Gets the number of key entries in the list.
  ///
  /// Throws an [AskarKeyEntryListException] if counting the key entries fails.
  int get length {
    try {
      return askarKeyEntryListCount(handle).getValueOrException();
    } catch (e) {
      throw AskarKeyEntryListException('Failed to count key entry list: $e');
    }
  }

  /// Gets a key entry by its index.
  ///
  /// Returns a [KeyEntry] at the specified [index].
  KeyEntry getEntryByIndex(int index) {
    return KeyEntry(list: handle, pos: index);
  }

  /// Iterates over each key entry in the list.
  ///
  /// The [cb] callback function is called for each key entry with the [KeyEntry] and its index.
  void forEachKeyEntry(void Function(KeyEntry entry, int index) cb) {
    for (int i = 0; i < length; i++) {
      cb(getEntryByIndex(i), i);
    }
  }

  /// Converts the key entry list to an array of [KeyEntryObject].
  ///
  /// Returns a list of [KeyEntryObject] containing the key entries.
  List<KeyEntryObject> toArray() {
    final list = <KeyEntryObject>[];
    forEachKeyEntry((key, _) => list.add(key.toJson()));
    return list;
  }
}
