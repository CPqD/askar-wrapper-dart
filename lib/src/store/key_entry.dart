import 'dart:convert';

import '../crypto/handles.dart';
import '../crypto/key.dart';

/// Represents a key entry object.
///
/// This class contains information about a specific key entry, including its [algorithm], [name], [metadata], [tags], and [key].
class KeyEntryObject {
  /// The algorithm used for the key.
  final String algorithm;

  /// The name of the key entry.
  final String name;

  /// Optional metadata associated with the key entry.
  final String? metadata;

  /// The tags associated with the key entry.
  final Map<String, dynamic> tags;

  /// The key instance.
  final Key key;

  /// Constructs an instance of [KeyEntryObject].
  KeyEntryObject({
    required this.algorithm,
    required this.name,
    this.metadata,
    required this.tags,
    required this.key,
  });
}

/// Pointer to one result of a KeyEntryList instance.
///
/// This class provides methods to access the details of a specific key entry retrieved from the key entry list.
class KeyEntry {
  /// The handle for the key entry list.
  final KeyEntryListHandle _list;

  /// The position of the key entry in the list.
  final int _pos;

  /// Constructs an instance of [KeyEntry].
  KeyEntry({required KeyEntryListHandle list, required int pos})
    : _list = list,
      _pos = pos;

  /// Gets the algorithm of the key entry.
  String get algorithm => _list.getAlgorithm(_pos);

  /// Gets the name of the key entry.
  String get name => _list.getName(_pos);

  /// Gets the metadata of the key entry.
  String get metadata => _list.getMetadata(_pos);

  /// Gets the tags associated with the key entry.
  ///
  /// Returns a map of tags. If no tags are present, returns an empty map.
  Map<String, dynamic> get tags {
    final tags = _list.getTags(_pos);
    return (tags.isEmpty) ? {} : jsonDecode(tags);
  }

  /// Gets the key instance.
  Key get key => Key(_list.loadKey(_pos));

  /// Converts the key entry to a [KeyEntryObject].
  ///
  /// Returns a [KeyEntryObject] containing the key entry details.
  KeyEntryObject toJson() {
    return KeyEntryObject(
      algorithm: algorithm,
      name: name,
      metadata: metadata,
      tags: tags,
      key: key,
    );
  }
}
