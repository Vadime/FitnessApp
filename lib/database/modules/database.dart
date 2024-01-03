import 'dart:async';
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
import 'package:fitnessapp/database/modules/database_module.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as openfoodfacts;
import 'package:widgets/widgets.dart';

part '../models/course_repository.dart';
part '../models/exercise_repository.dart';
part '../models/feedback_repository.dart';
part '../models/food_repository.dart';
part '../models/health_repository.dart';
part '../models/meal_repository.dart';
part '../models/message_repository.dart';
part '../models/product_repository.dart';
part '../models/user_repository.dart';
part '../models/workout_repository.dart';
part '../models/workout_statistics_repository.dart';
part 'auth.dart';
part 'database_logging.dart';
part 'error_handler.dart';
part 'functions.dart';
part 'messaging.dart';
part 'storage.dart';
part 'store.dart';

class Database extends DatabaseModule {
  static final Database _instance = Database._internal();

  static core.FirebaseOptions get _firebaseOptions {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const core.FirebaseOptions(
          apiKey: String.fromEnvironment('android_apiKey'),
          appId: String.fromEnvironment('android_appId'),
          messagingSenderId:
              String.fromEnvironment('android_messagingSenderId'),
          projectId: String.fromEnvironment('android_projectId'),
          databaseURL: String.fromEnvironment('android_databaseURL'),
          storageBucket: String.fromEnvironment('android_storageBucket'),
        );
      case TargetPlatform.iOS:
        return const core.FirebaseOptions(
          apiKey: String.fromEnvironment('ios_apiKey'),
          appId: String.fromEnvironment('ios_appId'),
          messagingSenderId: String.fromEnvironment('ios_messagingSenderId'),
          projectId: String.fromEnvironment('ios_projectId'),
          databaseURL: String.fromEnvironment('ios_databaseURL'),
          storageBucket: String.fromEnvironment('ios_storageBucket'),
          androidClientId: String.fromEnvironment('ios_androidClientId'),
          iosBundleId: String.fromEnvironment('ios_iosBundleId'),
          iosClientId: String.fromEnvironment('ios_iosClientId'),
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

  factory Database() => _instance;

  @override
  Future<void> init(bool useEmulator) async {
    try {
      await core.Firebase.initializeApp(options: _firebaseOptions);

      await Auth().init(useEmulator);
      await Store().init(useEmulator);
      await Storage().init(useEmulator);
      await Functions().init(useEmulator);
      await Messaging().init(useEmulator);
      await DatabaseLogging().init(useEmulator);

      await UserRepository.checkAuthenticationState();
    } catch (e, s) {
      handleException(e, s);
    }
  }

  Database._internal();
}
