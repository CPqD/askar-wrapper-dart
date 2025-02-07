import 'askar_entry_list_interface.dart';

class AskarEntryList implements IAskarEntryList {
  //EntryListHandle é Necessário
  // Valor é obtido em AskarSession.fetch ou AskarSession.fetchAll

  @override
  Future<bool> count() {
    // TODO: implement count
    throw UnimplementedError();
  }

  @override
  Future<bool> free() {
    // TODO: implement free
    throw UnimplementedError();
  }

  @override
  Future<bool> getCategory() {
    // TODO: implement getCategory
    throw UnimplementedError();
  }

  @override
  Future<bool> getName() {
    // TODO: implement getName
    throw UnimplementedError();
  }

  @override
  Future<bool> getTags() {
    // TODO: implement getTags
    throw UnimplementedError();
  }

  @override
  Future<bool> getValue() {
    // TODO: implement getValue
    throw UnimplementedError();
  }
}
