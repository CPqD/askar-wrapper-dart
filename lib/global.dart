import 'package:import_so_libaskar/askar/askar_wrapper.dart';

import 'askar/enums/askar_store_key_method.dart';

String? specUri;
final String passKey = 'mySecretKey';
final String profile = 'rekey';
final bool recreate = true;
final StoreKeyMethod method = StoreKeyMethod.argon2IMod;
LocalKeyHandle localKeyHandle = 0;
String thumbprint = "";
