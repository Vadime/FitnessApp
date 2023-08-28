import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserProfileFriendAddPopup extends StatefulWidget {
  const UserProfileFriendAddPopup({super.key});

  @override
  State<UserProfileFriendAddPopup> createState() =>
      _UserProfileFriendAddPopupState();
}

class _UserProfileFriendAddPopupState extends State<UserProfileFriendAddPopup> {
  TextFieldController emailBloc = TextFieldController.email();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Add Friend', style: context.textTheme.titleMedium),
        const SizedBox(height: 20),
        CardWidget.single(
          child: TextFieldWidget(
            controller: emailBloc,
            autofocus: true,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButtonWidget(
          'Add Friend',
          onPressed: () async {
            // check if there is an error in email
            if (emailBloc.isValid()) {
              // add friend
              try {
                await UserRepository.addFriend(
                  emailBloc.text,
                );
                Navigation.flush(widget: const HomeScreen(initialIndex: 3));
              } catch (e) {
                Messaging.info(
                  message: e.toString(),
                );
                return;
              }
            }
          },
        ),
      ],
    );
  }
}
