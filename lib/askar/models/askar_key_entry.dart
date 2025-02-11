import '../../askar/crypto/askar_handles.dart';

import '../enums/askar_key_algorithm.dart';

class AskarKeyEntry {
  KeyAlgorithm algorithm;
  String metadata;
  String name;
  Map tags;
  LocalKeyHandle localHandle;

  AskarKeyEntry({
    required this.algorithm,
    required this.metadata,
    required this.name,
    required this.tags,
    required this.localHandle,
  });
}
