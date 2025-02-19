/// Represents an entry in the Askar store.
///
/// The [AskarEntry] class contains information about a specific entry, including its category, name, tags, and value.
class AskarEntry {
  /// The category of the entry.
  final String category;

  /// The name of the entry.
  final String name;

  /// The tags associated with the entry.
  final Map tags;

  /// The value of the entry.
  final String value;

  /// Constructs an instance of [AskarEntry].
  AskarEntry({
    required this.category,
    required this.name,
    required this.tags,
    required this.value,
  });
}
