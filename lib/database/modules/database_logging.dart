part of '../modules/database.dart';

class DatabaseLogging extends DatabaseModule {
  static final DatabaseLogging _instance = DatabaseLogging._internal();

  static crashlytics.FirebaseCrashlytics get crashlyticsInstance =>
      crashlytics.FirebaseCrashlytics.instance;

  static analytics.FirebaseAnalytics get analyticsInstance =>
      analytics.FirebaseAnalytics.instance;

  static performance.FirebasePerformance get performanceInstance =>
      performance.FirebasePerformance.instance;

  // log info into firebase
  static void log(dynamic message) {
    Logging.log(message);
    crashlyticsInstance.log(message);
  }

  // log error into firebase
  static void error(e, StackTrace s) {
    Logging.logDetails('', e, s);
    crashlyticsInstance.recordError(e, s);
  }

  static void setUserId(String? uid) {
    if (uid == null) return;
    crashlyticsInstance.setUserIdentifier(uid);
  }

  static void crash(String error, StackTrace stack) {
    crashlyticsInstance.recordError(error, stack);
    crashlyticsInstance.crash();
  }

  factory DatabaseLogging() => _instance;

  @override
  Future<void> init(bool useEmulator) async {
    await analyticsInstance.setAnalyticsCollectionEnabled(true);
    await performanceInstance.setPerformanceCollectionEnabled(true);

    await crashlyticsInstance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = crashlyticsInstance.recordFlutterError;
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      crashlyticsInstance.recordError(error, stack, fatal: false);
      return true;
    };

    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await crashlyticsInstance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
          fatal: false,
        );
      }).sendPort,
    );
    await firestore.FirebaseFirestore.setLoggingEnabled(true);
  }

  DatabaseLogging._internal();
}
