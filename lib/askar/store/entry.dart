import 'dart:convert';
import 'dart:typed_data';

import 'package:askar_flutter_sdk/askar/crypto/handles.dart';

class EntryObject {
  final String name;
  final dynamic value;
  final Map<String, dynamic> tags;
  final String category;

  EntryObject({
    required this.name,
    required this.value,
    required this.tags,
    required this.category,
  });
}

class Entry {
  final EntryListHandle _list;
  final int _pos;

  Entry({required EntryListHandle list, required int position})
      : _list = list,
        _pos = position;

  String get category => _list.getCategory(_pos);

  String get name => _list.getName(_pos);

  String get value => utf8.decode(rawValue);

  Uint8List get rawValue => _list.getValue(_pos);

  Map<String, dynamic> get tags {
    final tags = _list.getTags(_pos);
    return (tags.isEmpty) ? {} : jsonDecode(tags);
  }

  EntryObject toJson({bool shouldParseValueToJson = false}) {
    return EntryObject(
      name: name,
      value: shouldParseValueToJson ? jsonDecode(value) : value,
      tags: tags,
      category: category,
    );
  }
}
