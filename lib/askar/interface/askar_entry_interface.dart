import '../models/askar_entry.dart';

abstract class IAskarEntry {
  int count();
  void free();
  String getCategory(int index);
  String getName(int index);
  Map getTags(int index);
  String getValue(int index);

  AskarEntry getEntry(int index);
  List<AskarEntry> getEntries();
}
