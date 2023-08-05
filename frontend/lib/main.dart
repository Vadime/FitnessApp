import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_app/app.dart';
import 'package:fitness_app/bloc/theme/theme_bloc.dart';
import 'package:fitness_app/database/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

FirebaseOptions get firebaseOptions {
  if (kIsWeb) {
    return const FirebaseOptions(
      apiKey: String.fromEnvironment('apiKeyWeb'),
      appId: String.fromEnvironment('appIdWeb'),
      messagingSenderId: String.fromEnvironment('messagingSenderIdWeb'),
      projectId: String.fromEnvironment('projectIdWeb'),
      authDomain: String.fromEnvironment('authDomainWeb'),
      databaseURL: String.fromEnvironment('databaseURLWeb'),
      storageBucket: String.fromEnvironment('storageBucketWeb'),
      measurementId: String.fromEnvironment('measurementIdWeb'),
    );
  }
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

void main() async {
  // ensure that the widgets binding is initialized
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // make sure that the splash screen is shown until the app is ready to be shown
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  String? error;
  try {
    // initialize firebase app
    await Firebase.initializeApp(options: firebaseOptions);

    // use emulators for development
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
    await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

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

    await FirebaseAuth.instance.currentUser?.reload();

    // load theme data from storage
    await ThemeBloc.getThemeFromStorage();
  } on FirebaseAuthException {
    UserRepository.signOutCurrentUser();
  } catch (e) {
    error = e.toString().split('] ').last;
  }
  // remove the splash screen
  FlutterNativeSplash.remove();

  // run the app
  runApp(App(initialisationError: error));
}
