import 'dart:io';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cloud_functions/cloud_functions.dart' as functions;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/models/src/course.dart';
import 'package:fitnessapp/models/src/friend.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'course_repository.dart';
part 'exercise_repository.dart';
part 'feedback_repository.dart';
part 'logging.dart';
part 'user_repository.dart';
part 'workout_repository.dart';
part 'workout_statistics_repository.dart';

extension DateTimeExtension on String {
  DateTime toDateTime() {
    var arr = split('.');
    return DateTime(int.parse(arr[2]), int.parse(arr[1]), int.parse(arr[0]));
  }
}

extension StringExtension on DateTime {
  String toDate() {
    return '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.${year.toString().padLeft(4, '0')}';
  }
}

class Database {
  static FirebaseOptions get _firebaseOptions {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: String.fromEnvironment('apiKeyAndroid'),
          appId: String.fromEnvironment('appIdAndroid'),
          messagingSenderId: String.fromEnvironment('messagingSenderIdAndroid'),
          projectId: String.fromEnvironment('projectIdAndroid'),
          authDomain: String.fromEnvironment('authDomainAndroid'),
          databaseURL: String.fromEnvironment('databaseURLAndroid'),
          storageBucket: String.fromEnvironment('storageBucketAndroid'),
          measurementId: String.fromEnvironment('measurementIdAndroid'),
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: String.fromEnvironment('apiKeyIOS'),
          appId: String.fromEnvironment('appIdIOS'),
          messagingSenderId: String.fromEnvironment('messagingSenderIdIOS'),
          projectId: String.fromEnvironment('projectIdIOS'),
          authDomain: String.fromEnvironment('authDomainIOS'),
          databaseURL: String.fromEnvironment('databaseURLIOS'),
          storageBucket: String.fromEnvironment('storageBucketIOS'),
          measurementId: String.fromEnvironment('measurementIdIOS'),
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static Future<void> initializeApp() async {
    try {
      // initialize firebase app
      await Firebase.initializeApp(
        options: _firebaseOptions,
      );

      if (const String.fromEnvironment('env') == 'dev') {
        // use the local emulators
        await auth.FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
        firestore.FirebaseFirestore.instance
            .useFirestoreEmulator('localhost', 8080);
        functions.FirebaseFunctions.instance
            .useFunctionsEmulator('localhost', 5001);
        await storage.FirebaseStorage.instance
            .useStorageEmulator('localhost', 9199);
      }
      await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
        return true;
      };

      Isolate.current.addErrorListener(
        RawReceivePort((pair) async {
          final List<dynamic> errorAndStacktrace = pair;
          await FirebaseCrashlytics.instance.recordError(
            errorAndStacktrace.first,
            errorAndStacktrace.last,
            fatal: false,
          );
        }).sendPort,
      );

      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

      await auth.FirebaseAuth.instance.currentUser?.reload();
    } on auth.FirebaseAuthException {
      UserRepository.signOutCurrentUser();
    } catch (e, s) {
      DatabaseLogging.crash(e.toString().split('] ').last, s);
    }
  }
}
