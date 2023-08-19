import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ProfilePasswordChangePopup extends StatefulWidget {
  const ProfilePasswordChangePopup({super.key});

  @override
  State<ProfilePasswordChangePopup> createState() =>
      _ProfilePasswordChangePopupState();
}

class _ProfilePasswordChangePopupState
    extends State<ProfilePasswordChangePopup> {
  TextFieldController oldPasswordBloc = TextFieldController.password(
    labelText: 'Old Password',
  );
  TextFieldController newPasswordBloc = TextFieldController.password(
    labelText: 'New Password',
  );
  TextFieldController repeatNewPasswordBloc = TextFieldController.password(
    labelText: 'Repeat New Password',
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Change Password', style: context.textTheme.titleLarge),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Column(
                children: [
                  TextFieldWidget(
                    oldPasswordBloc,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                    newPasswordBloc,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                    repeatNewPasswordBloc,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // save changes
          ElevatedButton(
            onPressed: () async {
              // check if there is an error in password
              if (!oldPasswordBloc.isValid()) {
                return Navigation.pushMessage(
                  message: oldPasswordBloc.errorText,
                );
              }
              // check if there is an error in password
              if (!newPasswordBloc.isValid()) {
                return Navigation.pushMessage(
                  message: newPasswordBloc.errorText,
                );
              }
              // check if there is an error in rPassword
              if (repeatNewPasswordBloc.text != newPasswordBloc.text) {
                return Navigation.pushMessage(
                  message: "Passwords don't match!",
                );
              }
              // check if all fields are filled
              try {
                await UserRepository.updateCurrentUserPassword(
                  oldPasswordBloc.text,
                  newPasswordBloc.text,
                );
                Navigation.pop();
              } catch (e) {
                Navigation.pushMessage(message: e.toString());
              }
            },
            child: const Text(
              'Change Password',
            ),
          ),
        ],
      ),
    );
  }
}
