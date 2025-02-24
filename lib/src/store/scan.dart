import '../askar_wrapper.dart';
import '../crypto/handles.dart';
import '../exceptions/exceptions.dart';

import 'entry.dart';
import 'entry_list.dart';
import 'store.dart';

/// A scan of the Store.
///
/// This class represents a scan operation on the store, including its [store], [profile], [category], [tagFilter], [offset], [limit], [orderBy], and [descending].
class Scan {
  /// The handle for the scan.
  ScanHandle? handle;

  /// The store instance.
  final Store store;

  /// Optional profile associated with the scan.
  final String? profile;

  /// The category of the entries to scan.
  final String category;

  /// Optional tag filter for the scan.
  final Map<String, dynamic>? tagFilter;

  /// Optional offset for the scan.
  final int? offset;

  /// Optional limit for the scan.
  final int? limit;

  /// Optional order by field for the scan.
  final String? orderBy;

  /// Optional flag to indicate descending order.
  final bool? descending;

  /// Constructs an instance of [Scan].
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

  /// Fetches all remaining rows.
  ///
  /// Returns a list of [EntryObject] containing the scanned entries.
  Future<List<EntryObject>> fetchAll() async {
    final rows = <EntryObject>[];
    await _forEachRow((row, _) => rows.add(row.toJson()));
    return rows;
  }

  /// Iterates over each row in the scan.
  ///
  /// The [cb] callback function is called for each row with the [Entry] and its index.
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

  /// Initializes the scan handle.
  Future<void> _initHandle() async {
    try {
      handle ??=
          (await askarScanStart(
            store.handle,
            profile: profile,
            category: category,
            limit: limit,
            offset: offset,
            tagFilter: tagFilter,
          )).getValueOrException();
    } catch (e) {
      AskarScanException('Failed to start scan: $e');
    }
  }
}
