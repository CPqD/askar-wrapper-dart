import '../../askar/crypto/handles.dart';
import '../enums/askar_key_algorithm.dart';
import '../models/askar_key_entry.dart';

abstract class IAskarKeyEntry {
  int count();
  void free();
  KeyAlgorithm getAlgorithm(int index);
  String getMetadata(int index);
  String getName(int index);
  Map getTags(int index);
  LocalKeyHandle loadLocal(int index);
  AskarKeyEntry getKeyEntry(int index);
  List<AskarKeyEntry> getKeyEntries();
}
