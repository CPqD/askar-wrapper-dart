import 'dart:convert';
import 'dart:typed_data';

import 'package:askar_flutter_sdk/askar/crypto/handles.dart';

/// Represents an entry object in the Askar store.
///
/// This class contains information about a specific entry, including its [name], [value], [tags], and [category].
class EntryObject {
  /// The name of the entry.
  final String name;

  /// The value of the entry.
  final dynamic value;

  /// The tags associated with the entry.
  final Map<String, dynamic> tags;

  /// The category of the entry.
  final String category;

  /// Constructs an instance of [EntryObject].
  EntryObject({
    required this.name,
    required this.value,
    required this.tags,
    required this.category,
  });
}

/// A single result from a store query.
///
/// This class provides methods to access the details of a specific entry retrieved from the Askar store.
class Entry {
  /// The handle for the entry list.
  final EntryListHandle _list;

  /// The position of the entry in the list.
  final int _pos;

  /// Constructs an instance of [Entry].
  Entry({required EntryListHandle list, required int position})
      : _list = list,
        _pos = position;

  /// Gets the category of the entry.
  String get category => _list.getCategory(_pos);

  /// Gets the name of the entry.
  String get name => _list.getName(_pos);

  /// Gets the value of the entry as a string.
  String get value => utf8.decode(rawValue);

  /// Gets the raw value of the entry as a [Uint8List].
  Uint8List get rawValue => _list.getValue(_pos);

  /// Gets the tags associated with the entry.
  ///
  /// Returns a map of tags. If no tags are present, returns an empty map.
  Map<String, dynamic> get tags {
    final tags = _list.getTags(_pos);
    return (tags.isEmpty) ? {} : jsonDecode(tags);
  }

  /// Converts the entry to an [EntryObject].
  ///
  /// The [shouldParseValueToJson] parameter indicates whether the value should be parsed as JSON.
  /// Returns an [EntryObject] containing the entry details.
  EntryObject toJson({bool shouldParseValueToJson = false}) {
    return EntryObject(
      name: name,
      value: shouldParseValueToJson ? jsonDecode(value) : value,
      tags: tags,
      category: category,
    );
  }
}
