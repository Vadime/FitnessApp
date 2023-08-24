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

  String error = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Delete Account', style: context.textTheme.titleLarge),
          const SizedBox(height: 10),
          const Text('Are you sure you want to delete your account?'),
          const SizedBox(height: 20),
          TextFieldWidget(
         controller:   passwordBloc,
          ),
          const SizedBox(height: 10),
          if (error.isNotEmpty)
            Text(
              error,
              textAlign: TextAlign.center,
              style: context.textTheme.labelSmall!.copyWith(
                color: context.colorScheme.errorContainer,
                fontSize: 10,
              ),
            ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.errorContainer,
            ),
            onPressed: () async {
              try {
                await UserRepository.deleteUser(passwordBloc.text);
              } catch (e) {
                error = e.toString().split('] ').last;
                setState(() {});
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
