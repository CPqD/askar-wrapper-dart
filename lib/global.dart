import 'askar/askar_callbacks.dart';
import 'askar/enums/askar_store_key_method.dart';

String? specUri;
final String passKey = 'mySecretKey';
final String profile = 'rekey';
final bool recreate = false;
final StoreKeyMethod method = StoreKeyMethod.argon2IMod;

AskarCallbackResult<dynamic>? storeHandle;
AskarCallbackResult<dynamic>? sessionHandle;
