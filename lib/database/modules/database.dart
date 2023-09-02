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
import 'package:fitnessapp/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:widgets/widgets.dart';

part '../models/course_repository.dart';
part '../models/exercise_repository.dart';
part '../models/feedback_repository.dart';
part '../models/user_repository.dart';
part '../models/workout_repository.dart';
part '../models/workout_statistics_repository.dart';
part 'auth.dart';
part 'error_handler.dart';
part 'functions.dart';
part 'logging.dart';
part 'messaging.dart';
part 'storage.dart';
part 'store.dart';

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
  }) async {
    try {
      await core.Firebase.initializeApp(options: _firebaseOptions);

      await Auth.init(useEmulator);
      await Store.init(useEmulator);
      await Storage.init(useEmulator);
      await Functions.init(useEmulator);
      await Messaging.init(useEmulator);
      await DatabaseLogging.init(useEmulator);

      await UserRepository.checkAuthenticationState();
    } catch (e, s) {
      handleException(e, s);
    }
  }
}
