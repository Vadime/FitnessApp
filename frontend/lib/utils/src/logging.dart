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
}
