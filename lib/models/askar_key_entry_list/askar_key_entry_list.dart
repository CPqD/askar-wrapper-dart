import 'askar_key_entry_list_interface.dart';

class AskarKeyEntryList implements IAskarKeyEntryList {
  //KeyEntryListHandle é necessário
  //Valor é obtido em AskarSession.fetchKeys ou AskarSession.fetchAllKeys

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
  Future<bool> getAlgorithm() {
    // TODO: implement getAlgorithm
    throw UnimplementedError();
  }

  @override
  Future<bool> getMetadata() {
    // TODO: implement getMetadata
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
  Future<bool> loadLocal() {
    // TODO: implement loadLocal
    throw UnimplementedError();
  }
}
