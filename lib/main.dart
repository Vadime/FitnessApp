import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/admin_home_screen.dart';
import 'package:fitnessapp/pages/onboarding_screen.dart';
import 'package:fitnessapp/pages/user_home_screen.dart';
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
        neutralColor: Color(0xFF9E9E9E),
        errorColor: Color(0xFFC62828),
        lightBackgroundColor: Color(0xFFEEEEEE),
        lightCardColor: Color(0xFFFFFFFF),
        darkBackgroundColor: Color(0xFF000000),
        darkCardColor: Color(0xFF212121),
        darkTextColor: Colors.white,
        lightTextColor: Colors.black,
        radius: 10,
        padding: 20,
        opacity: 0.8,
      ),
      themeModeSaver: FirestoreThemeModeSaver(),
      homeBuilder: (_) => UserRepository.currentUserRole == UserRole.admin
          ? const AdminHomeScreen()
          : const UserHomeScreen(),
      loginBuilder: (_) => const OnboardingScreen(),
      initialize: (BuildContext context) async {
        await Database.initializeApp(
          onMessage: (message) {
            Toast.info(message.notification, context: context);
          },
        );
      },
    ),
  );
}
