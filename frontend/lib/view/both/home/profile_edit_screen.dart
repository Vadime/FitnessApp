import 'package:fitness_app/bloc/widgets/my_text_field_bloc.dart';
import 'package:fitness_app/database/user_repository.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/both/home/home_screen.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late NameBloc nameBloc;
  late EmailBloc emailBloc;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = UserRepository.currentUser;
    nameBloc = NameBloc(initialValue: currentUser?.displayName);
    emailBloc = EmailBloc(initialValue: currentUser?.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),

            Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyTextField(
                      bloc: nameBloc,
                    ),
                    MyTextField(
                      bloc: emailBloc,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // save changes button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ElevatedButton(
                onPressed: () async {
                  // check if there is an error in email
                  if (emailBloc.state.errorText != null) {
                    return Messaging.show(
                      message: emailBloc.state.errorText!,
                    );
                  }
                  // check if there is an error in name
                  if (nameBloc.state.errorText != null) {
                    return Messaging.show(
                      message: nameBloc.state.errorText!,
                    );
                  }

                  // update user profile
                  UserRepository.updateCurrentUserProfile(
                    displayName: nameBloc.state.text,
                    email: emailBloc.state.text!,
                  );

                  // show snackbar
                  Messaging.show(
                    message: 'Profile updated successfully',
                  );
                  Navigation.replace(
                    widget: const HomeScreen(
                      initialIndex: 2,
                    ),
                  );
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
