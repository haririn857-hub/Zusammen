import 'dart:async';
import 'package:flutter/foundation.dart';

mixin Initializer {
  Completer<void>? _initCompleter;

  Future<void> onInitialize();

  Future<void> initialize() async {
    if (_initCompleter != null) {
      if (_initCompleter!.isCompleted) return;
      return _initCompleter!.future;
    }
    _initCompleter = Completer<void>();
    try {
      await onInitialize();
      debugPrint('$runtimeType: Initialized successfully');
      _initCompleter!.complete();
    } catch (e, st) {
      debugPrint('$runtimeType: Failed to initialize: $e\n$st');
      _initCompleter!.completeError(e, st);
      _initCompleter = null;
      rethrow;
    }
  }

  bool get isInitialized => _initCompleter?.isCompleted ?? false;
}
