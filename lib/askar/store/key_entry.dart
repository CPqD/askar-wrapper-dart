import 'dart:convert';

import 'package:askar_flutter_sdk/askar/crypto/handles.dart';
import 'package:askar_flutter_sdk/askar/crypto/key.dart';

class KeyEntryObject {
  final String algorithm;
  final String name;
  final String? metadata;
  final Map<String, dynamic> tags;
  final Key key;

  KeyEntryObject({
    required this.algorithm,
    required this.name,
    this.metadata,
    required this.tags,
    required this.key,
  });
}

class KeyEntry {
  final KeyEntryListHandle _list;
  final int _pos;

  KeyEntry({required KeyEntryListHandle list, required int pos})
      : _list = list,
        _pos = pos;

  String get algorithm => _list.getAlgorithm(_pos);

  String get name => _list.getName(_pos);

  String get metadata => _list.getMetadata(_pos);

  Map<String, dynamic> get tags {
    final tags = _list.getTags(_pos);
    return (tags.isEmpty) ? {} : jsonDecode(tags);
  }

  Key get key => Key(_list.loadKey(_pos));

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
