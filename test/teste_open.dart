import 'dart:async';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

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

void main() async {
  // Chamar a função que provisiona o store
  final result = await provisionOpen(
      'sqlite://storage.db', 'kdf:argon2i:mod', 'mySecretKey', 'rekey');
  print('Resultado final: $result');

}
