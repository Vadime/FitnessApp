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
      config: ThemeConfig(
        title: const String.fromEnvironment('application_name'),
        logoLocation: const String.fromEnvironment('application_logo'),
        primaryColor: Color(
          int.parse(const String.fromEnvironment('primary')),
        ),
        lightBackgroundColor: Color(
          int.parse(
            const String.fromEnvironment('background_light'),
          ),
        ),
        lightCardColor: Color(
          int.parse(const String.fromEnvironment('card_light')),
        ),
        lightNeutralColor: Color(
          int.parse(const String.fromEnvironment('neutral_light')),
        ),
        darkBackgroundColor: Color(
          int.parse(const String.fromEnvironment('background_dark')),
        ),
        darkCardColor: Color(
          int.parse(const String.fromEnvironment('card_dark')),
        ),
        darkNeutralColor: Color(
          int.parse(const String.fromEnvironment('neutral_dark')),
        ),
        darkTextColor: Colors.white,
        lightTextColor: Colors.black,
        radius: 10,
        padding: 20,
        opacity: 1,
      ),
      home: const HomeScreen(),
      login: const OnboardingScreen(),
      initialize: () async {
        await Database.initializeApp();
      },
    ),
  );
}
