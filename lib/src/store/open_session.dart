import '../askar_wrapper.dart';
import '../crypto/handles.dart';
import '../exceptions/exceptions.dart';
import 'session.dart';

/// A pending session instance.
///
/// This class represents a session that is pending to be opened, including its [store], [isTransaction], [profile], and [session].
class OpenSession {
  /// The handle for the store.
  final StoreHandle store;

  /// Determines if this instance would begin a transaction.
  final bool isTransaction;

  /// Optional profile associated with the session.
  String? profile;

  /// The session instance.
  Session? session;

  /// Constructs an instance of [OpenSession].
  OpenSession({required this.store, required this.isTransaction, this.profile});

  /// Opens this pending session.
  ///
  /// Throws an [AskarSessionException] if the store is closed or if the session is already opened.
  /// Returns a [Session] instance if the session is successfully started.
  Future<Session> open() async {
    if (store.handle == 0) {
      throw AskarSessionException('Cannot start session from closed store');
    }

    if (session != null) {
      throw AskarSessionException('Session already opened');
    }

    try {
      final sessionStartResult = await askarSessionStart(
        store,
        asTransaction: isTransaction,
        profile: profile,
      );

      final sessionHandle = sessionStartResult.getValueOrException();

      return Session(handle: sessionHandle, isTransaction: isTransaction);
    } catch (e) {
      throw AskarSessionException('Failed to start session: $e');
    }
  }
}
