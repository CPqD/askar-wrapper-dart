import 'package:askar_flutter_sdk/askar/askar_wrapper.dart';
import 'package:askar_flutter_sdk/askar/crypto/handles.dart';
import 'package:askar_flutter_sdk/askar/exceptions/exceptions.dart';
import 'session.dart';

class OpenSession {
  final StoreHandle store;
  final String profile;
  final bool isTransaction;
  Session? session;

  OpenSession({required this.store, required this.profile, required this.isTransaction});

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
        profile,
        isTransaction,
      );

      final sessionHandle = sessionStartResult.getValueOrException();

      return Session(handle: sessionHandle, isTransaction: isTransaction);
    } catch (e) {
      throw AskarSessionException('Failed to start session: $e');
    }
  }
}
