import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/pages/home_screen.dart';
import 'package:fitnessapp/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:widgets/widgets.dart';

void main() {
  // ensure that the widgets binding is initialized
  // the splash screen is shown until FlutterNativeSplash.remove() is called
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ThemeApp(
      config: ThemeConfig.standard(
        title: const String.fromEnvironment('application_name'),
        lightBackgroundColor: Colors.grey.shade200,
        darkCardColor: Colors.grey.shade900,
        primaryColor: Colors.orange,
      ),
      home: const HomeScreen(),
      login: const AppOnboardingScreen(),
      initialize: () async {
        // initialize the database
        await Database.initializeApp();

        // remove the splash screen
        FlutterNativeSplash.remove();
      },
    ),
  );
}
