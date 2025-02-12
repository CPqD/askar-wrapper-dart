import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import '../../askar/askar_native_functions.dart';
import '../../askar/enums/askar_error_code.dart';

base class AskarCallbackBlankResult {
  final ErrorCode errorCode;
  final bool finished;

  AskarCallbackBlankResult(this.errorCode, this.finished);

  @override
  String toString() {
    return "AskarCallbackBlankResult($errorCode, finished: $finished)";
  }

  void throwOnError() {
    errorCode.throwOnError();
  }
}

base class AskarCallbackResult<T> extends AskarCallbackBlankResult {
  final T value;

  AskarCallbackResult(super.errorCode, super.finished, this.value);

  @override
  String toString() {
    return "AskarCallbackResult($errorCode, value: $value, finished: $finished)";
  }
}

base class Callback<T extends Function> {
  final int id;
  final NativeCallable<T> nativeCallable;
  final Completer<AskarCallbackResult> completer;

  Callback(this.nativeCallable, this.completer, this.id);

  Future<AskarCallbackResult> handleResult(int initialResult) {
    final initialErrorCode = ErrorCode.fromInt(initialResult);

    if (initialErrorCode != ErrorCode.success) {
      completer.complete(AskarCallbackResult(initialErrorCode, false, null));

      this.nativeCallable.close();
    }

    return this.completer.future;
  }
}

int _callbackIdCounter = 0;

int nextCallbackId() {
  return _callbackIdCounter++;
}

typedef CbFuncWithHandle = Void Function(NativeCallbackId, Int32, NativeSessionHandle);

Callback<CbFuncWithHandle> newCallbackWithHandle() {
  final completer = Completer<AskarCallbackResult>();

  late final NativeCallable<CbFuncWithHandle> nativeCallable;

  void callback(int callbackId, int errorCode, int handle) {
    completer.complete(AskarCallbackResult(ErrorCode.fromInt(errorCode), true, handle));
    nativeCallable.close();
  }

  nativeCallable = NativeCallable<CbFuncWithHandle>.listener(callback);

  return Callback<CbFuncWithHandle>(nativeCallable, completer, nextCallbackId());
}

typedef CbFuncWithInt64 = Void Function(NativeCallbackId, Int32, Int64);

Callback<CbFuncWithInt64> newCallbackWithInt64() {
  final completer = Completer<AskarCallbackResult>();

  late final NativeCallable<CbFuncWithInt64> nativeCallable;

  void callback(int callbackId, int errorCode, int handle) {
    completer.complete(AskarCallbackResult(ErrorCode.fromInt(errorCode), true, handle));
    nativeCallable.close();
  }

  nativeCallable = NativeCallable<CbFuncWithInt64>.listener(callback);

  return Callback<CbFuncWithInt64>(nativeCallable, completer, nextCallbackId());
}

typedef CbFuncWithoutHandle = Void Function(NativeCallbackId, Int32);

Callback<CbFuncWithoutHandle> newCallbackWithoutHandle() {
  final completer = Completer<AskarCallbackResult>();

  late final NativeCallable<CbFuncWithoutHandle> nativeCallable;

  void callback(int callbackId, int errorCode) {
    completer.complete(AskarCallbackResult(ErrorCode.fromInt(errorCode), true, null));
    nativeCallable.close();
  }

  nativeCallable = NativeCallable<CbFuncWithoutHandle>.listener(callback);

  return Callback<CbFuncWithoutHandle>(nativeCallable, completer, nextCallbackId());
}

typedef CbFuncWithPtrUft8 = Void Function(NativeCallbackId, Int32, Pointer<Utf8>);

Callback<CbFuncWithPtrUft8> newCallbackWithPtrUtf8() {
  final completer = Completer<AskarCallbackResult>();

  late final NativeCallable<CbFuncWithPtrUft8> nativeCallable;

  void callback(int callbackId, int errorCode, Pointer<Utf8> utf8) {
    completer.complete(AskarCallbackResult(ErrorCode.fromInt(errorCode), true,
        utf8 == nullptr ? null : utf8.toDartString()));
    calloc.free(utf8);
    nativeCallable.close();
  }

  nativeCallable = NativeCallable<CbFuncWithPtrUft8>.listener(callback);

  return Callback<CbFuncWithPtrUft8>(nativeCallable, completer, nextCallbackId());
}
