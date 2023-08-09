import 'package:fitness_app/app.dart';
import 'package:fitness_app/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // ensure that the widgets binding is initialized
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // make sure that the splash screen is shown until the app is ready to be shown
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // initialize the database
  await Database.initializeApp();

  // remove the splash screen
  FlutterNativeSplash.remove();

  // run the app
  runApp(const App());
}
