import 'package:fitness_app/bloc/authentication/authentication_bloc.dart';
import 'package:fitness_app/bloc/theme/theme_bloc.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/app_onboarding_screen.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

ThemeData genTheme(
  String primaryStr,
  String backgroundStr,
  String cardStr,
  String neutralStr,
  String textStr,
  Brightness brightness,
) {
  final primary = Color(int.tryParse(primaryStr) ?? 0);
  final background = Color(int.tryParse(backgroundStr) ?? 0);
  final card = Color(int.tryParse(cardStr) ?? 0);
  final neutral = Color(int.tryParse(neutralStr) ?? 0);
  final text = Color(int.tryParse(textStr) ?? 0);
  const double padding = 20;
  const double borderRadius = 10;
  const double elevation = 0;
  const double opacity = 0.9;
  return ThemeData(
    primaryColor: primary,
    brightness: brightness,
    canvasColor: Colors.transparent,
    shadowColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: primary.withOpacity(opacity),
    ),
    
    snackBarTheme: SnackBarThemeData(
      elevation: elevation,
      backgroundColor: background.withOpacity(opacity),
      showCloseIcon: true,
      closeIconColor: text,
      contentTextStyle: TextStyle(
        color: text,
        fontSize: 14,
      ),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.fromLTRB(padding, 0, padding, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      minLeadingWidth: 0,
      horizontalTitleGap: 0,
      minVerticalPadding: 0,
      tileColor: card,
      iconColor: primary.withOpacity(opacity),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.fromLTRB(10, 0, 10, 0),
        ),
        side: MaterialStatePropertyAll(
          BorderSide(
            color: background,
            width: 4,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size(0, 0),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: MaterialStateProperty.all(
          card,
        ),
        animationDuration: const Duration(milliseconds: 100),
        elevation: MaterialStateProperty.all(elevation),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,

      //buttonColor: AppConfig.primaryColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      //foregroundColor: text,
      elevation: elevation,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: neutral,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(Size.zero),
        padding: MaterialStateProperty.all(
          const EdgeInsets.fromLTRB(5, 2, 5, 2),
        ),
      ),
    ),
    fontFamily: 'Varela Round',
    textTheme: TextTheme(
      // DISPLAY
      displayLarge:
          const TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
      displayMedium: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      displaySmall: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      // DISPLAY
      headlineLarge:
          const TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
      headlineMedium:
          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      // TITLE
      titleLarge: const TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
      titleMedium: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      titleSmall: const TextStyle(fontSize: 20),
      // BODY
      bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      bodySmall: const TextStyle(fontSize: 14),
      // LABEL
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: text.withOpacity(0.6),
      ),
      labelMedium: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(fontSize: 12, color: text.withOpacity(0.6)),
    ),
    colorScheme: ColorScheme.fromSeed(
      background: background,
      onBackground: background,
      brightness: brightness,
      seedColor: primary,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: background,
      modalBackgroundColor: background,
      surfaceTintColor: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      scrolledUnderElevation: 0,
      systemOverlayStyle: brightness != Brightness.light
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      backgroundColor: background.withOpacity(opacity),
      titleTextStyle: TextStyle(
        color: text,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: neutral,
      indent: 10,
      endIndent: 10,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      elevation: elevation,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: elevation,
      backgroundColor: background.withOpacity(opacity),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme: IconThemeData(
        color: text,
      ),
      unselectedIconTheme: IconThemeData(
        color: neutral,
      ),
    ),
    cardColor: card,
    cardTheme: CardTheme(
      color: card,
      margin: const EdgeInsets.all(0),
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        elevation: const MaterialStatePropertyAll(elevation),
        foregroundColor: MaterialStatePropertyAll(
          text,
        ),
        backgroundColor: MaterialStatePropertyAll(
          primary,
        ),
      ),
    ),
  );
}

class App extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocListener<AuthenticationBloc, AuthenticationState?>(
        listener: (context, state) {
          if (state is UserAuthenticatedState) {
            Navigation.flush(widget: const HomeScreen());
            return;
          } else if (state is UserUnauthenticatedState) {
            Navigation.flush(
              widget: const AppOnboardingScreen(),
            );
            return;
          }
          return;
        },
        child: BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (context, state) {
            return MaterialApp(
              
              navigatorKey: navigatorKey,
              scaffoldMessengerKey: messengerKey,
              title: const String.fromEnvironment('title'),
              themeMode: state,
              theme: genTheme(
                const String.fromEnvironment('primary'),
                const String.fromEnvironment('backgroundLight'),
                const String.fromEnvironment('neutralLight'),
                const String.fromEnvironment('neutralLight'),
                const String.fromEnvironment('backgroundDark'),
                Brightness.light,
              ),
              darkTheme: genTheme(
                const String.fromEnvironment('primary'),
                const String.fromEnvironment('backgroundDark'),
                const String.fromEnvironment('cardDark'),
                const String.fromEnvironment('neutralDark'),
                const String.fromEnvironment('backgroundLight'),
                Brightness.dark,
              ),
              home: Container(
                color: context.theme.scaffoldBackgroundColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
