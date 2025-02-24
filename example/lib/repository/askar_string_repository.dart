import 'package:askar_wrapper_dart/askar_wrapper_dart.dart';

import '../interface/askar_string_list_interface.dart';

class AskarStringRepository implements IAskarString {
  //StringListHandle é necessário
  //Valor é obtido em AskarSession.fetch ou AskarSession.fetchAll

  final StringListHandle? handle;

  AskarStringRepository({required this.handle});

  @override
  int count() {
    final result = askarStringListCount(handle!);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return 0;
  }

  @override
  void free() {
    askarStringListFree(handle!);
  }

  @override
  String getItem(int index) {
    final result = askarStringListGetItem(handle!, index);
    if (result.errorCode == ErrorCode.success) {
      return result.value;
    }
    return '';
  }

  @override
  List<String> getAllItems() {
    List<String> items = [];
    for (int i = 0; i < count(); i++) {
      items.add(getItem(i));
    }
    return items;
  }
}
