import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class Logging {
  // use firebase logging
  static void init() {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  // log into firebase
  static void log(String message) {
    FirebaseCrashlytics.instance.log(message);
  }

  // log error into firebase
  static void recordError(Exception e, StackTrace s) {
    FirebaseCrashlytics.instance.recordError(e, s);
  }
}
