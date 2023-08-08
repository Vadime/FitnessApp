import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  PasswordBloc oldPasswordBloc = PasswordBloc(
    hintText: 'Old Password',
  );
  PasswordBloc newPasswordBloc = PasswordBloc(
    hintText: 'New Password',
  );
  PasswordBloc repeatNewPasswordBloc = PasswordBloc(
    hintText: 'Repeat New Password',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        actions: [
          // save changes
          IconButton(
            onPressed: () async {
              // check if there is an error in password
              if (!oldPasswordBloc.isValid()) {
                return Messaging.show(
                  message: oldPasswordBloc.errorText,
                );
              }
              // check if there is an error in password
              if (!newPasswordBloc.isValid()) {
                return Messaging.show(
                  message: newPasswordBloc.errorText,
                );
              }
              // check if there is an error in rPassword
              if (repeatNewPasswordBloc.state.text !=
                  newPasswordBloc.state.text) {
                return Messaging.show(message: "Passwords don't match!");
              }
              // check if all fields are filled
              try {
                await UserRepository.updateCurrentUserPassword(
                  oldPasswordBloc.state.text ?? '',
                  newPasswordBloc.state.text ?? '',
                );
                Messaging.show(message: 'Password changed successfully!');
                Navigation.pop();
              } catch (e) {
                Messaging.show(message: e.toString());
              }
            },
            tooltip: 'Save Changes',
            icon: Icon(
              Icons.save_rounded,
              color: context.theme.primaryColor,
            ),
          ),
        ],
      ),
      body: Align(
        alignment: const Alignment(0, -0.5),
        child: Card(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField(
                  bloc: oldPasswordBloc,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  bloc: newPasswordBloc,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  bloc: repeatNewPasswordBloc,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
