import '../../askar/crypto/handles.dart';
import '../enums/askar_key_algorithm.dart';
import '../models/askar_key_entry.dart';

/// Interface for managing Askar key entries.
///
/// The [IAskarKeyEntry] interface defines methods for counting, freeing, and retrieving information about Askar key entries.
abstract class IAskarKeyEntry {
  /// Returns the number of key entries.
  int count();

  /// Frees the resources associated with the key entries.
  void free();

  /// Gets the algorithm of the key entry at the specified [index].
  ///
  /// The [index] parameter specifies the position of the key entry.
  KeyAlgorithm getAlgorithm(int index);

  /// Gets the metadata of the key entry at the specified [index].
  ///
  /// The [index] parameter specifies the position of the key entry.
  String getMetadata(int index);

  /// Gets the name of the key entry at the specified [index].
  ///
  /// The [index] parameter specifies the position of the key entry.
  String getName(int index);

  /// Gets the tags of the key entry at the specified [index].
  ///
  /// The [index] parameter specifies the position of the key entry.
  Map getTags(int index);

  /// Loads the local key handle of the key entry at the specified [index].
  ///
  /// The [index] parameter specifies the position of the key entry.
  LocalKeyHandle loadLocal(int index);

  /// Gets the key entry at the specified [index].
  ///
  /// The [index] parameter specifies the position of the key entry.
  AskarKeyEntry getKeyEntry(int index);

  /// Gets all key entries.
  ///
  /// Returns a list of [AskarKeyEntry] objects.
  List<AskarKeyEntry> getKeyEntries();
}
