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
        BlocProvider(create: (context) => LoadingController()),
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
        listener: (context, state) => Navigation.flush(
          widget: state ? const HomeScreen() : const AppOnboardingScreen(),
        ),
        child: BlocBuilder<ThemeController, ThemeMode>(
          builder: (context, themeMode) => Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: MaterialApp(
                  navigatorKey: Navigation.navigatorKey,
                  title: context.config.title,
                  themeMode: themeMode,
                  theme: context.config.genTheme(Brightness.light),
                  darkTheme: context.config.genTheme(Brightness.dark),
                  home: const LoadingScreen(),
                ),
              ),
              const Positioned.fill(child: LoadingScreen()),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingController, bool>(
      builder: (context, loading) => IgnorePointer(
        ignoring: !loading,
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          opacity: loading ? 1 : 0,
          child: Container(
            color: context.theme.primaryColor.withOpacity(1),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: Stack(
                children: [
                  Center(
                    child: ImageWidget(
                      AssetImage('res/logo/foreground.png'),
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
