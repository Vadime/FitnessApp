import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class Logging {
  // log info into firebase
  static void log(String message) {
    FirebaseCrashlytics.instance.log(message);
  }

  // log error into firebase
  static void error(e, StackTrace s) {
    FirebaseCrashlytics.instance.recordError(e, s);
  }

  static void setUserId(String? uid) {
    if (uid == null) return;
    FirebaseCrashlytics.instance.setUserIdentifier(uid);
  }

  static void crash(String error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    FirebaseCrashlytics.instance.crash();
  }
}
