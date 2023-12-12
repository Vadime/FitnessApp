import 'package:fitnessapp/database/database.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserAccountDeletePopup extends StatefulWidget {
  const UserAccountDeletePopup({super.key});

  @override
  State<UserAccountDeletePopup> createState() => _UserAccountDeletePopupState();
}

class _UserAccountDeletePopupState extends State<UserAccountDeletePopup> {
  TextFieldController passwordBloc = TextFieldController.password();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget('Delete Account', style: context.textTheme.titleLarge),
        const SizedBox(height: 10),
        const TextWidget('Are you sure you want to delete your account?'),
        const SizedBox(height: 20),
        TextFieldWidget(
          controller: passwordBloc,
          autofocus: true,
        ),
        const SizedBox(height: 20),
        ElevatedButtonWidget(
          'Delete',
          backgroundColor: context.config.errorColor,
          onPressed: () async {
            try {
              await UserRepository.deleteUser(passwordBloc.text);
            } catch (e) {
              passwordBloc.setError(e.toString());
            }
          },
        ),
      ],
    );
  }
}
