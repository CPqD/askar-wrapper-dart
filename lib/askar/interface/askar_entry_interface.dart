import '../models/askar_entry.dart';

/// Interface for managing Askar entries.
///
/// The [IAskarEntry] interface defines methods for counting, freeing, and retrieving information about Askar entries.
abstract class IAskarEntry {
  /// Returns the number of entries.
  int count();

  /// Frees the resources associated with the entries.
  void free();

  /// Gets the category of the entry at the specified [index].
  ///
  /// The [index] parameter specifies the position of the entry.
  String getCategory(int index);

  /// Gets the name of the entry at the specified [index].
  ///
  /// The [index] parameter specifies the position of the entry.
  String getName(int index);

  /// Gets the tags of the entry at the specified [index].
  ///
  /// The [index] parameter specifies the position of the entry.
  Map getTags(int index);

  /// Gets the value of the entry at the specified [index].
  ///
  /// The [index] parameter specifies the position of the entry.
  String getValue(int index);

  /// Gets the entry at the specified [index].
  ///
  /// The [index] parameter specifies the position of the entry.
  AskarEntry getEntry(int index);

  /// Gets all entries.
  ///
  /// Returns a list of [AskarEntry] objects.
  List<AskarEntry> getEntries();
}
