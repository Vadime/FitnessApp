import 'package:fitnessapp/database/database.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Change Password', style: context.textTheme.titleLarge),
        const SizedBox(height: 20),
        CardWidget(
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
        const SizedBox(height: 20),
        // save changes
        ElevatedButtonWidget(
          'Change Password',
          onPressed: () async {
            // check if there is an error in password
            if (!oldPasswordBloc.isValid()) {
              return Messaging.info(
                oldPasswordBloc.errorText,
                context: context,
              );
            }
            // check if there is an error in password
            if (!newPasswordBloc.isValid()) {
              return Messaging.info(
                newPasswordBloc.errorText,
                context: context,
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
              Messaging.info(
                e.toString(),
                context: context,
              );
            }
          },
        ),
      ],
    );
  }
}
