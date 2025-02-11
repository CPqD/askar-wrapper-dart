import '../../askar/crypto/askar_handles.dart';
import '../../askar/models/askar_key_entry.dart';

import '../askar_wrapper.dart';
import '../enums/askar_error_code.dart';
import '../enums/askar_key_algorithm.dart';
import '../exceptions/exceptions.dart';
import '../interface/askar_key_entry_interface.dart';

class AskarKeyEntryRepository implements IAskarKeyEntry {
  //KeyEntryListHandle é necessário
  //Valor é obtido em AskarSession.fetchKey ou AskarSession.fetchAllKeys
  final KeyEntryListHandle? handle;

  AskarKeyEntryRepository({required this.handle});

  @override
  int count() {
    checkHandle();
    final response = askarKeyEntryListCount(handle!);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarKeyEntryListException(
        "Erro ao contar entradas de chave - Verificar KeyEntryListHandle");
  }

  @override
  void free() {
    checkHandle();
    askarKeyEntryListFree(handle!);
  }

  @override
  KeyAlgorithm getAlgorithm(int index) {
    checkHandle();
    final response = askarKeyEntryListGetAlgorithm(handle!, index);
    if (response.errorCode == ErrorCode.success) {
      KeyAlgorithm alg = KeyAlgorithm.values.firstWhere((e) {
        return e.value == response.value;
      }, orElse: () {
        throw AskarKeyEntryListException("Algoritmo listado no enum KeyAlgorithm");
      });

      return alg;
    }

    throw AskarKeyEntryListException(
        "Erro ao buscar Algoritmo - Verificar KeyEntryListHandle");
  }

  @override
  String getMetadata(int index) {
    checkHandle();
    final response = askarKeyEntryListGetMetadata(handle!, index);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarKeyEntryListException(
        "Erro ao buscar Metadata - Verificar KeyEntryListHandle");
  }

  @override
  String getName(int index) {
    checkHandle();
    final response = askarKeyEntryListGetName(handle!, index);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarKeyEntryListException("Erro buscar Nome - Verificar KeyEntryListHandle");
  }

  @override
  Map getTags(int index) {
    checkHandle();
    final response = askarKeyEntryListGetTags(handle!, index);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarKeyEntryListException("Erro buscar Tags - Verificar KeyEntryListHandle");
  }

  @override
  LocalKeyHandle loadLocal(int index) {
    checkHandle();
    final response = askarKeyEntryListLoadLocal(handle!, index);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarKeyEntryListException(
        "Erro ao carregar  handle Local - Verificar KeyEntryListHandle");
  }

  @override
  AskarKeyEntry getKeyEntry(int index) {
    checkHandle();
    return AskarKeyEntry(
      algorithm: getAlgorithm(index),
      metadata: getMetadata(index),
      name: getName(index),
      tags: getTags(index),
      localHandle: loadLocal(index),
    );
  }

  @override
  List<AskarKeyEntry> getKeyEntries() {
    checkHandle();

    List<AskarKeyEntry> entries = [];
    for (var i = 0; i < count(); i++) {
      entries.add(getKeyEntry(i));
    }
    return entries;
  }

  checkHandle() {
    if (handle == null) {
      throw AskarKeyEntryListException("KeyEntryListHandle não iniciado");
    }
  }
}
