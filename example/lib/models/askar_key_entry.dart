import 'package:askar_wrapper_dart/askar_wrapper_dart.dart';

/// Represents a key entry in the Askar store.
///
/// This class contains information about a specific key entry, including its [algorithm], [metadata], [name], [tags], and [localHandle].
class AskarKeyEntry {
  /// The algorithm used by the key.
  final KeyAlgorithm algorithm;

  /// The metadata associated with the key.
  final String metadata;

  /// The name of the key.
  final String name;

  /// The tags associated with the key.
  final Map tags;

  /// The local handle for the key.
  final LocalKeyHandle localHandle;

  /// Constructs an instance of [AskarKeyEntry].
  AskarKeyEntry({
    required this.algorithm,
    required this.metadata,
    required this.name,
    required this.tags,
    required this.localHandle,
  });
}
