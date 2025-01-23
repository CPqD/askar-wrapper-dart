import 'dart:async';
import 'dart:ffi';

import 'package:import_so_libaskar/askar/askar_error_code.dart';
import 'package:import_so_libaskar/askar/askar_native_functions.dart';

base class CallbackResult {
  final ErrorCode errorCode;
  final int handle;
  final bool finished;

  CallbackResult(this.errorCode, this.handle, this.finished);
}

base class Callback<T extends Function> {
  final int id;
  final NativeCallable<T> nativeCallable;
  final Completer<CallbackResult> completer;
  final void Function() cleanupPointers;

  Callback(this.nativeCallable, this.completer, this.id, this.cleanupPointers);

  Future<CallbackResult> handleResult(int initialResult) {
    final initialErrorCode = intToErrorCode(initialResult);

    if (initialErrorCode != ErrorCode.Success) {
      print('Falhou de início');
      completer.complete(CallbackResult(initialErrorCode, -1, false));

      this.cleanupPointers();
      this.nativeCallable.close();
    }

    return this.completer.future;
  }
}

final class CallbackWithHandle extends Callback<CbFuncWithHandle> {
  @override
  final NativeCallable<CbFuncWithHandle> nativeCallable;

  CallbackWithHandle(this.nativeCallable, Completer<CallbackResult> completer,
      int callbackId, void Function() cleanupPointers)
      : super(nativeCallable, completer, callbackId, cleanupPointers);
}

final class CallbackWithoutHandle extends Callback<CbFuncWithoutHandle> {
  @override
  final NativeCallable<CbFuncWithoutHandle> nativeCallable;

  CallbackWithoutHandle(this.nativeCallable, Completer<CallbackResult> completer,
      int callbackId, void Function() cleanupPointers)
      : super(nativeCallable, completer, callbackId, cleanupPointers);
}

int _callbackIdCounter = 0;

int nextCallbackId() {
  return _callbackIdCounter++;
}

typedef CbFuncWithHandle = Void Function(CallbackId, Int32, SessionHandle);

CallbackWithHandle newCallbackWithHandle(void Function() cleanup) {
  final completer = Completer<CallbackResult>();

  late final NativeCallable<CbFuncWithHandle> nativeCallable;

  void callback(int callbackId, int errorCode, int handle) {
    completer.complete(CallbackResult(intToErrorCode(errorCode), handle, true));
    cleanup();
    nativeCallable.close();
  }

  nativeCallable = NativeCallable<CbFuncWithHandle>.listener(callback);

  return CallbackWithHandle(nativeCallable, completer, nextCallbackId(), cleanup);
}

typedef CbFuncWithoutHandle = Void Function(CallbackId, Int32);

CallbackWithoutHandle newCallbackWithoutHandle(void Function() cleanup) {
  final completer = Completer<CallbackResult>();

  late final NativeCallable<CbFuncWithoutHandle> nativeCallable;

  void callback(int callbackId, int errorCode) {
    completer.complete(CallbackResult(intToErrorCode(errorCode), -1, true));
    cleanup();
    nativeCallable.close();
  }

  nativeCallable = NativeCallable<CbFuncWithoutHandle>.listener(callback);

  return CallbackWithoutHandle(nativeCallable, completer, nextCallbackId(), cleanup);
}
