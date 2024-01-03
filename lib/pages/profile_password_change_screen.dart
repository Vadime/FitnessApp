import 'package:fitnessapp/database/database.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ProfilePasswordChangeScreen extends StatefulWidget {
  const ProfilePasswordChangeScreen({super.key});

  @override
  State<ProfilePasswordChangeScreen> createState() =>
      _ProfilePasswordChangeScreenState();
}

class _ProfilePasswordChangeScreenState
    extends State<ProfilePasswordChangeScreen> {
  TextFieldController oldPasswordBloc = TextFieldController.password(
    labelText: 'Altes Passwort',
  );
  TextFieldController newPasswordBloc = TextFieldController.password(
    labelText: 'Neues Passwort',
  );

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Passwort ändern',
      primaryButton: ElevatedButtonWidget(
        'Passwort ändern',
        onPressed: () async {
          // check if there is an error in password
          if (!oldPasswordBloc.isValid()) return;
          // check if there is an error in password
          if (!newPasswordBloc.isValid()) return;
          // check if all fields are filled
          try {
            await UserRepository.updateCurrentUserPassword(
              oldPasswordBloc.text,
              newPasswordBloc.text,
            );
            Navigation.pop();
          } catch (e) {
            newPasswordBloc.setError(e.toString());
          }
        },
      ),
      body: Center(
        child: CardWidget(
          margin: const EdgeInsets.all(20),
          children: [
            TextFieldWidget(
              controller: oldPasswordBloc,
              autofocus: true,
            ),
            TextFieldWidget(
              controller: newPasswordBloc,
              autofocus: true,
            ),
          ],
        ),
      ),
      // save changes
    );
  }
}
