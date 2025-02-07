import '../../askar/askar_wrapper.dart';
import '../../askar/enums/askar_error_code.dart';
import 'askar_string_list_interface.dart';

class AskarStringList implements IAskarStringList {
  //StringListHandle é necessário
  //Valor é obtido em AskarSession.fetch ou AskarSession.fetchAll

  final StringListHandle? handle;

  AskarStringList({required this.handle});

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
