import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

void main() {
  runApp(const MatApp());
}

class MatApp extends StatelessWidget {
  const MatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeController(config: ThemeConfig.standard()),
      child: BlocBuilder<ThemeController, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
              navigatorKey: Navigation.key,
              themeMode: state,
              theme: ThemeController.of(context).lightTheme,
              darkTheme: ThemeController.of(context).lightTheme,
              home: const App());
        },
      ),
    );
  }
}

class App2 extends StatelessWidget {
  const App2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.config.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              MultiSelectionButton(
                  controller: MultiSelectionController<int>([]),
                  buttons: const [
                    ButtonData('Hals', 0),
                    ButtonData('Rücken', 1),
                    ButtonData('Arme', 2),
                    ButtonData('Brust', 3),
                    ButtonData('Beine', 4),
                    ButtonData('Hüfte', 5),
                    ButtonData('Langes Wort', 6),
                  ]),
              const Spacer(),
              SlidingSegmentedButton(
                  controller: SegmentedButtonController(0),
                  segments: const [
                    ButtonData('Hello', 0),
                    ButtonData('Hello', 1),
                    ButtonData('Hello', 2),
                  ]),
              Center(
                  child: TextButtonWidget(
                'Hello World',
                onPressed: () {},
              )),
              const Spacer(),
              const ListTileWidget(
                title: 'Hello World',
                //subtitle: "Hello World\n\nadsfdsf",
              ),
              const Spacer(),
              ElevatedButtonWidget(
                'Hello World',
                onPressed: () {},
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      onEmailSignUp: (email, password) {
        Logging.log(email.text);
        Logging.log(password.text);
      },
      onEmailSignIn: (email, password) {
        Logging.log(email.text);
        Logging.log(password.text);
      },
      onEmailSendPassword: (email) {
        Logging.log(email.text);
      },
      onPhoneSendCode: (phone) {
        Logging.log(phone.text);
      },
      onAppleLogin: () {
        ToastController().show('Not implemented');
      },
    );
  }
}
