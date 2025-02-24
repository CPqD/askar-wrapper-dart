import 'package:askar_wrapper_dart/askar_wrapper_dart.dart';
import 'package:example/repository/askar_store_repository.dart';

String? specUri;
final String passKey = 'mySecretKey';
final String profile = 'rekey';
final bool recreate = true;
final StoreKeyMethod method = StoreKeyMethod.argon2IMod;
LocalKeyHandle localKeyHandle = LocalKeyHandle(0);
String thumbprint = "";

StoreRepository? store;
