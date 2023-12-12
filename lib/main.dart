import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:fitnessapp/pages/onboarding_screen.dart';
import 'package:fitnessapp/utils/firestore_theme_mode_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:widgets/widgets.dart';

void main() {
  // ensure that the widgets binding is initialized
  // the splash screen is shown until FlutterNativeSplash.remove() is called
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  runApp(
    ThemeApp(
      config: ThemeConfig(
        title: 'Fitness App',
        logoLocation: 'res/logo/foreground.png',
        primaryColor: const Color(0xFFFF9800),
        neutralColor: const Color(0xFF9E9E9E),
        errorColor: const Color(0xFFC62828),
        lightBackgroundColor: const Color(0xFFEEEEEE),
        lightCardColor: const Color(0xFFFFFFFF),
        darkBackgroundColor: const Color(0xFF000000),
        darkCardColor: const Color(0xFF212121),
        darkTextColor: Colors.white,
        lightTextColor: Colors.black,
        radius: 10,
        padding: 20,
        opacity: 0.8,
      ),
      themeModeSaver: FirestoreThemeModeSaver(),
      home: const HomeScreen(),
      login: const OnboardingScreen(),
      initialize: (BuildContext context) async {
        await Database().init(false);
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}
