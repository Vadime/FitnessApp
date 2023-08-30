import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cloud_functions/cloud_functions.dart' as functions;
import 'package:firebase_analytics/firebase_analytics.dart' as analytics;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart' as core;
import 'package:firebase_crashlytics/firebase_crashlytics.dart' as crashlytics;
import 'package:firebase_messaging/firebase_messaging.dart' as messaging;
import 'package:firebase_performance/firebase_performance.dart' as performance;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:fitnessapp/database/src/messaging.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/models/src/course.dart';
import 'package:fitnessapp/models/src/friend.dart';
import 'package:fitnessapp/models/src/workout_statistic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

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

class FirestoreThemeModeSaver extends ThemeModeSaver {
  @override
  Future<ThemeMode?> load(String key) async {
    try {
      var snap = await firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .get();
      return ThemeMode.values[snap.data()?[key] ?? 0];
    } catch (_) {
      // not important (happens if offline)
      Logging.log('Error loading ThemeMode');
    }
    return null;
  }

  @override
  Future<void> save(String key, ThemeMode mode) async {
    try {
      await firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .set(
        {
          key: mode.index,
        },
        firestore.SetOptions(mergeFields: [key]),
      );
    } catch (_) {
      // not important (happens if offline)
      Logging.log('Error saving ThemeMode');
    }
  }
}

class Database {
  static core.FirebaseOptions get _firebaseOptions {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const core.FirebaseOptions(
          apiKey: 'AIzaSyBmU426TVziB9QrtOqwQxcjZEDuH63bfFo',
          appId: '1:534633074686:android:de07d1fedd973d6e317aaf',
          messagingSenderId: '534633074686',
          projectId: 'fitnessapp-9dd39',
          databaseURL:
              'https://fitnessapp-9dd39-default-rtdb.europe-west1.firebasedatabase.app',
          storageBucket: 'fitnessapp-9dd39.appspot.com',
        );
      case TargetPlatform.iOS:
        return const core.FirebaseOptions(
          apiKey: 'AIzaSyC2ABCt_uX1w_RjDwgkkAMB8K6Lny_sY-E',
          appId: '1:534633074686:ios:c381d0e456202bdc317aaf',
          messagingSenderId: '534633074686',
          projectId: 'fitnessapp-9dd39',
          databaseURL:
              'https://fitnessapp-9dd39-default-rtdb.europe-west1.firebasedatabase.app',
          storageBucket: 'fitnessapp-9dd39.appspot.com',
          iosBundleId:
              '534633074686-t6eupvdqbpru0d8i63edqn8jvonkrnnb.apps.googleusercontent.com',
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

  static Future<void> initializeApp({
    bool useEmulator = false,
    void Function(messaging.RemoteMessage message)? onMessage,
  }) async {
    try {
      // initialize firebase app
      await core.Firebase.initializeApp(
        options: _firebaseOptions,
      );
      await Messaging.init(
        onMessage: onMessage,
      );
      if (useEmulator) {
        // use the local emulators
        await auth.FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
        firestore.FirebaseFirestore.instance
            .useFirestoreEmulator('localhost', 8080);
        functions.FirebaseFunctions.instance
            .useFunctionsEmulator('localhost', 5001);
        await storage.FirebaseStorage.instance
            .useStorageEmulator('localhost', 9199);
      }
      await performance.FirebasePerformance.instance
          .setPerformanceCollectionEnabled(true);
      await crashlytics.FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(true);
      FlutterError.onError =
          crashlytics.FirebaseCrashlytics.instance.recordFlutterError;
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        crashlytics.FirebaseCrashlytics.instance
            .recordError(error, stack, fatal: false);
        return true;
      };

      Isolate.current.addErrorListener(
        RawReceivePort((pair) async {
          final List<dynamic> errorAndStacktrace = pair;
          await crashlytics.FirebaseCrashlytics.instance.recordError(
            errorAndStacktrace.first,
            errorAndStacktrace.last,
            fatal: false,
          );
        }).sendPort,
      );

      await analytics.FirebaseAnalytics.instance
          .setAnalyticsCollectionEnabled(true);

      await auth.FirebaseAuth.instance.currentUser?.reload();
      await UserRepository.checkAuthenticationState();

      await firestore.FirebaseFirestore.setLoggingEnabled(true);

      const firestore.Settings(persistenceEnabled: true);

      if (kIsWeb) {
        await firestore.FirebaseFirestore.instance.enablePersistence(
          const firestore.PersistenceSettings(synchronizeTabs: true),
        );
      }
      if (kIsWeb) {
        auth.FirebaseAuth.instance.setPersistence(auth.Persistence.LOCAL);
      }
    } on auth.FirebaseAuthException catch (e, s) {
      Logging.logDetails('FirebaseAuthException setup', e, s);
      UserRepository.signOutCurrentUser();
    } on core.FirebaseException catch (e, s) {
      Logging.logDetails('FirebaseException setup', e, s);
    } catch (e, s) {
      Logging.logDetails('Error Database setup', e, s);
    }
  }
}
