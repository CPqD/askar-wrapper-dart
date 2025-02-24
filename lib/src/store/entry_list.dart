import '../askar_wrapper.dart';
import '../crypto/handles.dart';
import '../exceptions/exceptions.dart';
import 'entry.dart';

/// A list of query results.
///
/// This class provides methods to access and manipulate a list of entries retrieved from the Askar store.
class EntryList {
  /// The handle for the entry list.
  final EntryListHandle handle;

  /// Constructs an instance of [EntryList].
  EntryList({required this.handle});

  /// Gets the length of the entry list.
  ///
  /// Returns the number of entries in the list.
  /// Throws an [AskarEntryListException] if counting the entries fails.
  int get length {
    try {
      return askarEntryListCount(handle).getValueOrException();
    } catch (e) {
      throw AskarEntryListException('Failed to count entry list: $e');
    }
  }

  /// Fetches an entry by its index.
  ///
  /// The [index] parameter specifies the position of the entry in the list.
  /// Returns the [Entry] at the specified index.
  Entry getEntryByIndex(int index) {
    return Entry(list: handle, position: index);
  }

  /// Iterates over the entry list.
  ///
  /// The [fn] parameter is a function that is called for each entry in the list.
  void forEachEntry(void Function(Entry entry, int index) fn) {
    for (int i = 0; i < length; i++) {
      fn(getEntryByIndex(i), i);
    }
  }

  /// Finds an entry in the list that matches the given condition.
  ///
  /// The [cb] parameter is a callback function that returns `true` for the matching entry.
  /// Returns the [Entry] that matches the condition, or `null` if no match is found.
  Entry? find(bool Function(Entry entry, int index) cb) {
    for (int i = 0; i < length; i++) {
      final item = getEntryByIndex(i);
      if (cb(item, i)) return item;
    }
    return null;
  }

  /// Converts the entry list to an array of [EntryObject].
  ///
  /// The [valuesAreJson] parameter indicates whether the values should be parsed as JSON.
  /// Returns a list of [EntryObject] instances.
  List<EntryObject> toArray({bool valuesAreJson = false}) {
    final list = <EntryObject>[];
    forEachEntry(
      (entry, _) => list.add(entry.toJson(shouldParseValueToJson: valuesAreJson)),
    );
    return list;
  }
}
