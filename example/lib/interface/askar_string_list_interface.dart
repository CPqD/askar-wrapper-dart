/// Interface for managing a collection of strings in Askar.
///
/// The [IAskarString] interface defines methods for counting, freeing, and retrieving strings from a collection.
abstract class IAskarString {
  /// Returns the number of strings in the collection.
  int count();

  /// Frees the resources associated with the collection of strings.
  void free();

  /// Gets the string at the specified [index].
  ///
  /// The [index] parameter specifies the position of the string in the collection.
  String getItem(int index);

  /// Gets all strings in the collection.
  ///
  /// Returns a list of strings.
  List<String> getAllItems();
}
