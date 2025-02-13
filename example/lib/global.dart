import 'package:askar_flutter_sdk/askar_wrapper.dart';

String? specUri;
final String passKey = 'mySecretKey';
final String profile = 'rekey';
final bool recreate = true;
final StoreKeyMethod method = StoreKeyMethod.argon2IMod;
LocalKeyHandle localKeyHandle = LocalKeyHandle(0);
String thumbprint = "";

Store? store;
