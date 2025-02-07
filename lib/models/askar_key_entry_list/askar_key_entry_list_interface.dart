import '../../askar/askar_wrapper.dart';

abstract class IAskarKeyEntryList {
  int count();
  void free();
  String getAlgorithm(int index);
  String getMetadata(int index);
  String getName(int index);
  Map getTags(int index);
  LocalKeyHandle loadLocal(int index);
}
