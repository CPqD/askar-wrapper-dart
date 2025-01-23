import 'dart:async';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:convert';

// Definição do callback nativo
typedef ProvisionCallback = ffi.Void Function(
    ffi.Int32 a, ffi.Int32 b, ffi.Pointer<ffi.Void> c);

// Função que encapsula a chamada assíncrona ao código nativo
Future<int> provisionOpen(String uri, String keyMethod, String passKey,
    String profile) async {
  // Carregar a biblioteca nativa
  final nativeLibrary =
      ffi.DynamicLibrary.open('/usr/local/lib/libaries_askar.so');

  // Definir a função nativa
  final askar_store_open = nativeLibrary.lookupFunction<
      ffi.Int32 Function(
          ffi.Pointer<Utf8>,
          ffi.Pointer<Utf8>,
          ffi.Pointer<Utf8>,
          ffi.Pointer<Utf8>,
          ffi.Pointer<ffi.NativeFunction<ProvisionCallback>>),
      int Function(
          ffi.Pointer<Utf8>,
          ffi.Pointer<Utf8>,
          ffi.Pointer<Utf8>,
          ffi.Pointer<Utf8>,
          ffi.Pointer<ffi.NativeFunction<ProvisionCallback>>)>('askar_store_open');

  // Converter strings para ponteiros Utf8
  final uriPointer = uri.toNativeUtf8();
  final keyMethodPointer = keyMethod.toNativeUtf8();
  final passKeyPointer = passKey.toNativeUtf8();
  final profilePointer = profile.toNativeUtf8();

  // Criar um Completer para aguardar o resultado do callback
  final completer = Completer<int>();

  // Definir o callback Dart que será chamado pelo código nativo
  late final ffi.NativeCallable<ProvisionCallback> nativeCallable;
  void onProvisionCallback(int a, int errorCode, ffi.Pointer<ffi.Void> c) {
    // Processar os valores recebidos do callback
    print('Callback recebido: a=$a, errorCode=$errorCode');
    // Completar o Completer com o resultado
    completer.complete(errorCode); // Exemplo de processamento
    // Fechar o NativeCallable quando não for mais necessário
    nativeCallable.close();
  }

  // Inicializar o NativeCallable com o callback Dart
  nativeCallable =
      ffi.NativeCallable<ProvisionCallback>.listener(onProvisionCallback);

  // Obter o ponteiro para a função nativa
  final callbackPointer = nativeCallable.nativeFunction;

  // Chamar a função nativa
  final result = askar_store_open(
    uriPointer,
    keyMethodPointer,
    passKeyPointer,
    profilePointer,
    callbackPointer
  );

  print('Resultado da chamada nativa: $result');

  // Liberar memória alocada
  calloc.free(uriPointer);
  calloc.free(keyMethodPointer);
  calloc.free(passKeyPointer);
  calloc.free(profilePointer);

  // Aguardar o resultado do callback
  return completer.future;
}


Future<int> sessionUpdate(int handle, int operation, String category, String name, String value, String tags,
    int expiryMs) async {
  // Carregar a biblioteca nativa
  final nativeLibrary =
      ffi.DynamicLibrary.open('/usr/local/lib/libaries_askar.so');

    
  // Definir a função nativa
  final askar_session_update = nativeLibrary.lookupFunction<
      ffi.Int32 Function(
          ffi.Int32,
          ffi.Int32,
          ffi.Pointer<Utf8>,
          ffi.Pointer<Utf8>,
          ffi.Pointer<Utf8>,
          ffi.Pointer<Utf8>,
          ffi.Int32,
          ffi.Pointer<ffi.NativeFunction<ProvisionCallback>>,
          ffi.Int32),
      int Function(
          int,
          int,
          ffi.Pointer<Utf8>,
          ffi.Pointer<Utf8>,
          ffi.Pointer<Utf8>,
          ffi.Pointer<Utf8>,
          int,
          ffi.Pointer<ffi.NativeFunction<ProvisionCallback>>,
          int)>('askar_session_update');


  // Converter strings para ponteiros Utf8
  final categoryPointer = category.toNativeUtf8();
  final valuePointer = value.toNativeUtf8();
  final namePointer = name.toNativeUtf8();
  final tagsPointer = tags.toNativeUtf8();
 

  // Criar um Completer para aguardar o resultado do callback
  final completer = Completer<int>();

  // Definir o callback Dart que será chamado pelo código nativo
  late final ffi.NativeCallable<ProvisionCallback> nativeCallable;
  void onProvisionCallback(int a, int errorCode, ffi.Pointer<ffi.Void> c) {
    // Processar os valores recebidos do callback
    print('Callback recebido: a=$a, errorCode=$errorCode');
    // Completar o Completer com o resultado
    completer.complete(errorCode); // Exemplo de processamento
    // Fechar o NativeCallable quando não for mais necessário
    nativeCallable.close();
  }

  // Inicializar o NativeCallable com o callback Dart
  nativeCallable =
      ffi.NativeCallable<ProvisionCallback>.listener(onProvisionCallback);

  // Obter o ponteiro para a função nativa
  final callbackPointer = nativeCallable.nativeFunction;
  final callbackId = nativeCallable.nativeFunction;

    
  // Chamar a função nativa
  final result = askar_session_update( 
    handle, 
    operation,
    categoryPointer,
    namePointer,
    valuePointer,
    tagsPointer, 
    expiryMs,
    callbackPointer,
    123,
  );

  sessionUpdate(1, 1, 'category-one', 'testEntry', '', 'teste', 2000);

  print('Resultado da chamada nativa: $result');

  // Liberar memória alocada
  calloc.free(namePointer);
  calloc.free(valuePointer);
  calloc.free(categoryPointer);
  calloc.free(tagsPointer);
  calloc.free(valuePointer);

  // Aguardar o resultado do callback
  return completer.future;
}

void main() async {

  // Chamar a função que provisiona o store
  final result = await provisionOpen(
      'sqlite://storage.db', 'kdf:argon2i:mod', 'mySecretKey', 'rekey');
  print('Resultado final: $result');

  final result2 = await sessionUpdate(1, 0, 'category-one', 'testEntry', 'foobar', '', 2000);

  print('Resultado final: $result2');

}
