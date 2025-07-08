import 'package:flutter/foundation.dart';

extension GenericExt<T> on T {
  /// Returns the value of the object if it is not null, otherwise returns the provided default value.
  T? orElse(T? defaultValue) {
    return this ?? defaultValue;
  }

  /// Returns the value of the object if it is not null, otherwise returns null.
  T? orNull() {
    return this;
  }

  void flutterLog({String? tag, String? message}) {
    if (!kDebugMode) return;
    final logTag = tag ?? 'GenericExt';
    final logMessage = message ?? toString();
    debugPrint('[$logTag] $logMessage');
  }
}

extension ObjectExt on Object? {
  void debugLog({String? tag, String? message}) {
    if (!kDebugMode) return;
    final logTag = tag ?? 'ObjectExt';
    final logMessage = message ?? toString();
    debugPrint('[$logTag] $logMessage');
  }

  /// Returns true if the object is null, otherwise false.
  bool get isNull => this == null;

  /// Returns true if the object is not null, otherwise false.
  bool get isNotNull => this != null;

  /// Returns true if the object is a String and not empty, otherwise false.
  bool get isNotEmptyString => this is String && (this as String).isNotEmpty;
}
