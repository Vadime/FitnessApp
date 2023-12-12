import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:widgets/widgets.dart';

class ThemeApp extends StatefulWidget {
  final ThemeConfig config;
  final ThemeModeSaver? themeModeSaver;
  final Widget home;
  final Widget login;
  final Future<void> Function(BuildContext context)? initialize;
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;

  const ThemeApp({
    required this.config,
    required this.home,
    required this.login,
    this.initialize,
    this.themeModeSaver,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    super.key,
  });

  @override
  State<ThemeApp> createState() => _ThemeAppState();
}

class _ThemeAppState extends State<ThemeApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: Future(() async {
      await widget.initialize?.call(context);
      FlutterNativeSplash.remove();
    }), builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const SizedBox();
      }

      return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => ThemeController(
                  config: widget.config, saver: widget.themeModeSaver)),
        ],
        child: BlocListener<AuthenticationController, bool>(
          bloc: AuthenticationController(),
          listener: (context, state) {
            if (state) {
              ThemeController.of(context).load();
              Navigation.flush(widget: widget.home);
            } else {
              Navigation.flush(widget: widget.login);
            }
          },
          child: BlocBuilder<ThemeController, ThemeMode>(
            builder: (context, themeMode) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: MaterialApp(
                      localizationsDelegates: widget.localizationsDelegates,
                      supportedLocales: widget.supportedLocales,
                      navigatorKey: Navigation.key,
                      title: context.config.title,
                      themeMode: themeMode,
                      theme: context.config.genTheme(Brightness.light),
                      darkTheme: context.config.genTheme(Brightness.dark),
                      home: AuthenticationController().state
                          ? widget.home
                          : widget.login,
                    ),
                  ),
                  Positioned.fill(child: LoadingPage(context.config)),
                  Positioned.fill(child: ToastPage(context.config)),
                ],
              );
            },
          ),
        ),
      );
    });
  }
}
