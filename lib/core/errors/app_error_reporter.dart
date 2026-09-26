import 'package:flutter/foundation.dart';

abstract final class AppErrorReporter {
  static void report(Object error, StackTrace? stackTrace) {
    if (!kDebugMode) return;

    debugPrint('Unhandled application error: $error');
    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
