import 'package:askar_flutter_sdk/askar/askar_wrapper.dart';
import 'package:askar_flutter_sdk/askar/crypto/handles.dart';
import 'package:askar_flutter_sdk/askar/exceptions/exceptions.dart';

import 'entry.dart';
import 'entry_list.dart';
import 'store.dart';

class Scan {
  ScanHandle? handle;
  final Store store;
  final String? profile;
  final String category;
  final Map<String, dynamic>? tagFilter;
  final int? offset;
  final int? limit;
  final String? orderBy;
  final bool? descending;

  Scan({
    required this.store,
    required this.category,
    this.profile,
    this.tagFilter,
    this.offset,
    this.limit,
    this.orderBy,
    this.descending,
  });

  Future<List<EntryObject>> fetchAll() async {
    final rows = <EntryObject>[];
    await _forEachRow((row, _) => rows.add(row.toJson()));
    return rows;
  }

  Future<void> _forEachRow(void Function(Entry row, int? index) cb) async {
    _initHandle();

    try {
      int recordCount = 0;

      while (limit == null || recordCount < limit!) {
        final scanResult = await askarScanNext(handle!);

        if (!scanResult.errorCode.isSuccess()) {
          break;
        }

        final list = EntryList(handle: scanResult.value);

        recordCount += list.length;
        for (int i = 0; i < list.length; i++) {
          final entry = list.getEntryByIndex(i);
          cb(entry, i);
        }

        askarEntryListFree(list.handle);
      }
    } catch (e) {
      AskarScanException('Failed to scan: $e');
    } finally {
      if (handle != null) {
        askarScanFree(handle!);
      }
    }
  }

  Future<void> _initHandle() async {
    try {
      handle ??= (await askarScanStart(store.handle,
              profile: profile,
              category: category,
              limit: limit,
              offset: offset,
              tagFilter: tagFilter))
          .getValueOrException();
    } catch (e) {
      AskarScanException('Failed to start scan: $e');
    }
  }
}
