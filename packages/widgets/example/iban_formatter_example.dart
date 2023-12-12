import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

void main(List<String> args) {
  runApp(
    ThemeApp(
      config: ThemeConfig.standard(),
      login: const App(),
      home: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  TextFieldController iban = TextFieldController.iban();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            TextFieldWidget(
              controller: iban,
              margin: const EdgeInsets.all(20),
            ),
            const Spacer(),
            ElevatedButtonWidget(
              'Show IBAN',
              onPressed: () {
                ToastController().show(iban.text);
              },
              margin: const EdgeInsets.all(20),
            ),
          ],
        ),
      ),
    );
  }
}
