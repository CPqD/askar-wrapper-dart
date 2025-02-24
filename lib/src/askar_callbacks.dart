import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import '../../src/askar_native_functions.dart';
import '../../src/enums/askar_error_code.dart';

/// Represents a blank result from an Askar callback.
///
/// This class contains the [errorCode] and [finished] status of the callback.
base class AskarCallbackBlankResult {
  /// The error code returned by the callback.
  final ErrorCode errorCode;

  /// Indicates whether the callback has finished.
  final bool finished;

  /// Constructs an instance of [AskarCallbackBlankResult].
  AskarCallbackBlankResult(this.errorCode, this.finished);

  @override
  String toString() {
    return "AskarCallbackBlankResult($errorCode, finished: $finished)";
  }

  /// Throws an exception if the error code indicates an error.
  void throwOnError() {
    errorCode.throwOnError();
  }
}

/// Represents a result from an Askar callback with a value.
///
/// This class extends [AskarCallbackBlankResult] and includes the [value] returned by the callback.
base class AskarCallbackResult<T> extends AskarCallbackBlankResult {
  /// The value returned by the callback.
  final T value;

  /// Constructs an instance of [AskarCallbackResult].
  AskarCallbackResult(super.errorCode, super.finished, this.value);

  @override
  String toString() {
    return "AskarCallbackResult($errorCode, value: $value, finished: $finished)";
  }
}

/// Represents a callback with a specific function type.
///
/// This class contains the [id], [nativeCallable], and [completer] for the callback.
base class Callback<T extends Function> {
  /// The ID of the callback.
  final int id;

  /// The native callable function for the callback.
  final NativeCallable<T> nativeCallable;

  /// The completer for the callback result.
  final Completer<AskarCallbackResult> completer;

  /// Constructs an instance of [Callback].
  Callback(this.nativeCallable, this.completer, this.id);

  /// Handles the result of the callback.
  ///
  /// Returns a [Future] that completes with the [AskarCallbackResult].
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

/// Generates the next callback ID.
int nextCallbackId() {
  return _callbackIdCounter++;
}

typedef CbFuncWithHandle = Void Function(NativeCallbackId, Int32, NativeSessionHandle);

/// Creates a new callback with a handle.
///
/// Returns a [Callback] instance with the specified function type.
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

/// Creates a new callback with an Int64 value.
///
/// Returns a [Callback] instance with the specified function type.
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

typedef CbFuncWithInt8 = Void Function(NativeCallbackId, Int32, Int8);

/// Creates a new callback with an Int8 value.
///
/// Returns a [Callback] instance with the specified function type.
Callback<CbFuncWithInt8> newCallbackWithInt8() {
  final completer = Completer<AskarCallbackResult>();

  late final NativeCallable<CbFuncWithInt8> nativeCallable;

  void callback(int callbackId, int errorCode, int handle) {
    completer.complete(AskarCallbackResult(ErrorCode.fromInt(errorCode), true, handle));
    nativeCallable.close();
  }

  nativeCallable = NativeCallable<CbFuncWithInt8>.listener(callback);

  return Callback<CbFuncWithInt8>(nativeCallable, completer, nextCallbackId());
}

typedef CbFuncWithoutHandle = Void Function(NativeCallbackId, Int32);

/// Creates a new callback without a handle.
///
/// Returns a [Callback] instance with the specified function type.
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

/// Creates a new callback with a UTF-8 pointer.
///
/// Returns a [Callback] instance with the specified function type.
Callback<CbFuncWithPtrUft8> newCallbackWithPtrUtf8() {
  final completer = Completer<AskarCallbackResult>();

  late final NativeCallable<CbFuncWithPtrUft8> nativeCallable;

  void callback(int callbackId, int errorCode, Pointer<Utf8> utf8) {
    completer.complete(
      AskarCallbackResult(
        ErrorCode.fromInt(errorCode),
        true,
        utf8 == nullptr ? null : utf8.toDartString(),
      ),
    );
    calloc.free(utf8);
    nativeCallable.close();
  }

  nativeCallable = NativeCallable<CbFuncWithPtrUft8>.listener(callback);

  return Callback<CbFuncWithPtrUft8>(nativeCallable, completer, nextCallbackId());
}
