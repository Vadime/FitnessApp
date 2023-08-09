import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserProfileFriendAddPopup extends StatefulWidget {
  const UserProfileFriendAddPopup({super.key});

  @override
  State<UserProfileFriendAddPopup> createState() =>
      _UserProfileFriendAddPopupState();
}

class _UserProfileFriendAddPopupState extends State<UserProfileFriendAddPopup> {
  EmailBloc emailBloc = EmailBloc(
    initialValue: '',
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Add Friend', style: context.textTheme.titleMedium),
          const SizedBox(height: 20),
          MyCard.single(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: MyTextField(
              bloc: emailBloc,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // check if there is an error in email
              if (emailBloc.isValid()) {
                // add friend
                try {
                  await UserRepository.addFriend(
                    emailBloc.state.text ?? '',
                  );
                  Navigation.flush(widget: const HomeScreen(initialIndex: 3));
                } catch (e) {
                  Navigation.pushMessage(
                    message: e.toString(),
                  );
                  return;
                }
              }
            },
            child: const Text('Add Friend'),
          ),
        ],
      ),
    );
  }
}
