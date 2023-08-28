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
      config: const ThemeConfig(
        title: 'Fitness App',
        logoLocation: 'res/logo/foreground.png',
        primaryColor: Color(0xFFFF9800),
        lightBackgroundColor: Color(0xFFEEEEEE),
        lightCardColor: Color(0xFFFFFFFF),
        lightNeutralColor: Color(0xFFE0E0E0),
        darkBackgroundColor: Color(0xFF000000),
        darkCardColor: Color(0xFF212121),
        darkNeutralColor: Color(0xFF616161),
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
