import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: [
                      // old password
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
              const Spacer(),
              // save button
              ElevatedButton(
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
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
