import 'dart:developer' as developer;

class Logging {
  static void log(dynamic message) {
    developer.log('[Message]: $message', time: DateTime.now());
  }

  static void logDetails(dynamic message,
      [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      time: DateTime.now(),
      level: 0,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
