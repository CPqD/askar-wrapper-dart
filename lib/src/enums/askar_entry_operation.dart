/// Supported operations for entries in the store.
enum EntryOperation {
  /// Insert a new entry.
  insert(0),

  /// Replace an existing entry.
  replace(1),

  /// Remove an existing entry.
  remove(2);

  /// The integer value associated with the operation.
  final int value;

  /// Constructs an instance of [EntryOperation] with the given integer [value].
  const EntryOperation(this.value);
}
