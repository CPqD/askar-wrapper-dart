import '../../askar/askar_wrapper.dart';
import '../../askar/enums/askar_error_code.dart';
import '../../exceptions/askar_exceptions/exceptions.dart';
import 'askar_key_entry_list_interface.dart';

class AskarKeyEntryList implements IAskarKeyEntryList {
  //KeyEntryListHandle é necessário
  //Valor é obtido em AskarSession.fetchKeys ou AskarSession.fetchAllKeys
  final KeyEntryListHandle? handle;

  AskarKeyEntryList({required this.handle});

  @override
  int count() {
    checkHandle();
    final response = askarKeyEntryListCount(handle!);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarKeyEntryListException(
        "Erro ao contar entradas de chave - Verificar HANDLE");
  }

  @override
  void free() {
    checkHandle();
    askarKeyEntryListFree(handle!);
  }

  @override
  String getAlgorithm(int index) {
    checkHandle();
    final response = askarKeyEntryListGetAlgorithm(handle!, index);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarKeyEntryListException(
        "Erro ao contar entradas de chave - Verificar HANDLE");
  }

  @override
  String getMetadata(int index) {
    checkHandle();
    final response = askarKeyEntryListGetMetadata(handle!, index);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarKeyEntryListException(
        "Erro ao contar entradas de chave - Verificar HANDLE");
  }

  @override
  String getName(int index) {
    checkHandle();
    final response = askarKeyEntryListGetName(handle!, index);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarKeyEntryListException(
        "Erro ao contar entradas de chave - Verificar HANDLE");
  }

  @override
  Map getTags(int index) {
    checkHandle();
    final response = askarKeyEntryListGetTags(handle!, index);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarKeyEntryListException(
        "Erro ao contar entradas de chave - Verificar HANDLE");
  }

  @override
  LocalKeyHandle loadLocal(int index) {
    checkHandle();
    final response = askarKeyEntryListLoadLocal(handle!, index);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarKeyEntryListException(
        "Erro ao contar entradas de chave - Verificar HANDLE");
  }

  checkHandle() {
    if (handle == null) {
      throw AskarKeyEntryListException("KeyEntryListHandle não iniciado");
    }
  }
}
