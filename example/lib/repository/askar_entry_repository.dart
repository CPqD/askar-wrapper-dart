// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:askar_wrapper_dart/askar_wrapper_dart.dart';

import '../interface/askar_entry_interface.dart';
import '../models/askar_entry.dart';

class AskarEntryRepository implements IAskarEntry {
  //EntryListHandle é Necessário
  // Valor é obtido em AskarSession.fetch ou AskarSession.fetchAll

  EntryListHandle? handle;

  AskarEntryRepository({required this.handle});

  @override
  int count() {
    checkHandle();
    final response = askarEntryListCount(handle!);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarEntryException("Erro ao contar entradas - Verificar EntryListHandle");
  }

  @override
  void free() {
    checkHandle();
    askarEntryListFree(handle!);
  }

  @override
  String getCategory(int index) {
    checkHandle();
    final response = askarEntryListGetCategory(handle!, 0);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarEntryException("Erro ao buscar Categoria - Verificar EntryListHandle");
  }

  @override
  String getName(int index) {
    final response = askarEntryListGetName(handle!, 0);
    if (response.errorCode == ErrorCode.success) {
      return response.value;
    }
    throw AskarEntryException("Erro ao buscar Nome - Verificar EntryListHandle");
  }

  @override
  Map getTags(int index) {
    final response = askarEntryListGetTags(handle!, 0);
    if (response.errorCode == ErrorCode.success) {
      return jsonDecode(response.value);
    }
    throw AskarEntryException("Erro ao buscar Tags - Verificar EntryListHandle");
  }

  @override
  String getValue(int index) {
    final response = askarEntryListGetValue(handle!, 0);
    if (response.errorCode == ErrorCode.success) {
      return utf8.decode(response.value);
    }
    throw AskarEntryException("Erro ao buscar Valor - Verificar EntryListHandle");
  }

  @override
  AskarEntry getEntry(int index) {
    return AskarEntry(
      category: getCategory(index),
      name: getName(index),
      tags: getTags(index),
      value: getValue(index),
    );
  }

  @override
  List<AskarEntry> getEntries() {
    List<AskarEntry> entries = [];
    for (var i = 0; i < count(); i++) {
      entries.add(getEntry(i));
    }
    return entries;
  }

  checkHandle() {
    if (handle == null) {
      throw AskarEntryException("Handle não pode ser nulo");
    }
  }
}
