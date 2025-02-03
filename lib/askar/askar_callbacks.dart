import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:import_so_libaskar/askar/enums/askar_error_code.dart';
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
    final initialErrorCode = ErrorCode.fromInt(initialResult);

    if (initialErrorCode != ErrorCode.success) {
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

final class CallbackWithInt64 extends Callback<CbFuncWithInt64> {
  @override
  final NativeCallable<CbFuncWithInt64> nativeCallable;

  CallbackWithInt64(this.nativeCallable, Completer<CallbackResult> completer,
      int callbackId, void Function() cleanupPointers)
      : super(nativeCallable, completer, callbackId, cleanupPointers);
}

final class CallbackWithPtrUft8 extends Callback<CbFuncWithPtrUft8> {
  @override
  final NativeCallable<CbFuncWithPtrUft8> nativeCallable;

  CallbackWithPtrUft8(this.nativeCallable, Completer<CallbackResult> completer,
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
    completer.complete(CallbackResult(ErrorCode.fromInt(errorCode), handle, true));
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
    completer.complete(CallbackResult(ErrorCode.fromInt(errorCode), -1, true));
    cleanup();
    nativeCallable.close();
  }

  nativeCallable = NativeCallable<CbFuncWithoutHandle>.listener(callback);

  return CallbackWithoutHandle(nativeCallable, completer, nextCallbackId(), cleanup);
}

typedef CbFuncWithInt64 = Void Function(CallbackId, Int32, Int64);

CallbackWithInt64 newCallbackWithInt64(void Function() cleanup) {
  final completer = Completer<CallbackResult>();

  late final NativeCallable<CbFuncWithInt64> nativeCallable;

  void callback(int callbackId, int errorCode, int handle) {
    completer.complete(CallbackResult(ErrorCode.fromInt(errorCode), handle, true));
    cleanup();
    nativeCallable.close();
  }

  nativeCallable = NativeCallable<CbFuncWithInt64>.listener(callback);

  return CallbackWithInt64(nativeCallable, completer, nextCallbackId(), cleanup);
}

typedef CbFuncWithPtrUft8 = Void Function(CallbackId, Int32, Pointer<Utf8>);

CallbackWithPtrUft8 newCallbackWithPtrUtf8(void Function() cleanup) {
  final completer = Completer<CallbackResult>();

  late final NativeCallable<CbFuncWithPtrUft8> nativeCallable;

  void callback(int callbackId, int errorCode, Pointer<Utf8> uft8) {
    completer.complete(CallbackResult(ErrorCode.fromInt(errorCode), -1, true));
    cleanup();
    nativeCallable.close();
  }

  nativeCallable = NativeCallable<CbFuncWithPtrUft8>.listener(callback);

  return CallbackWithPtrUft8(nativeCallable, completer, nextCallbackId(), cleanup);
}
