import 'package:fitnessapp/pages/home_screen.dart';
import 'package:fitnessapp/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

import 'database/src/database.dart';
import 'models/src/user.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            var bloc = AuthenticationController();
            UserRepository.authStateChanges.listen((User? user) async {
              if (user == null) {
                bloc.logout();
              } else {
                await UserRepository.refreshUserRole();
                bloc.login();
              }
            });
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) => ThemeController(
            config: ThemeConfig.standard(
              title: const String.fromEnvironment('application_name'),
              lightBackgroundColor: Colors.grey.shade200,
              darkCardColor: Colors.grey.shade900,
            ),
          ),
        ),
      ],
      child: BlocListener<AuthenticationController, bool>(
        listener: (context, state) {
          if (state) {
            Navigation.flush(widget: const HomeScreen());
          } else {
            Navigation.flush(
              widget: const AppOnboardingScreen(),
            );
          }
        },
        child: BlocBuilder<ThemeController, ThemeMode>(
          builder: (context, state) {
            return MaterialApp(
              navigatorKey: Navigation.navigatorKey,
              title: context.config.title,
              themeMode: state,
              theme: context.config.genTheme(Brightness.light),
              darkTheme: context.config.genTheme(Brightness.dark),
              home: const Scaffold(),
            );
          },
        ),
      ),
    );
  }
}
