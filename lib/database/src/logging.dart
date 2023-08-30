part of 'database.dart';

class DatabaseLogging {
  // log info into firebase
  static void log(String message) {
    crashlytics.FirebaseCrashlytics.instance.log(message);
  }

  // log error into firebase
  static void error(e, StackTrace s) {
    crashlytics.FirebaseCrashlytics.instance.recordError(e, s);
  }

  static void setUserId(String? uid) {
    if (uid == null) return;
    crashlytics.FirebaseCrashlytics.instance.setUserIdentifier(uid);
  }

  static void crash(String error, StackTrace stack) {
    crashlytics.FirebaseCrashlytics.instance.recordError(error, stack);
    crashlytics.FirebaseCrashlytics.instance.crash();
  }
}
