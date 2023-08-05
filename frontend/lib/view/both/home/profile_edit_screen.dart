import 'package:fitness_app/database/user_repository.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/src/file_picking.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/both/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SafeArea(
            bottom: false,
            child: SizedBox(height: 20),
          ),

          Row(
            children: [
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () async {
                  var image = await FilePicking.pickImage();
                  if (image != null) {
                    try {
                      await UserRepository.updateCurrentUserImage(image: image);
                      setState(() {
                        currentUser = UserRepository.currentUser;
                      });
                    } catch (e) {
                      return Messaging.show(message: e.toString());
                    }
                  } else {
                    Messaging.show(message: 'No image selected');
                  }
                },
                child: CircleAvatar(
                  radius: context.shortestSide / 7,
                  backgroundColor: context.theme.cardColor,
                  foregroundImage: currentUser?.imageURL == null
                      ? null
                      : NetworkImage(
                          currentUser!.imageURL!,
                        ),
                  child: Icon(
                    Icons.person_4_rounded,
                    size: context.shortestSide / (5),
                    color: context.theme.scaffoldBackgroundColor,
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyTextField(
                          bloc: nameBloc,
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          bloc: emailBloc,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // save changes button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                try {
                  await UserRepository.updateCurrentUserProfile(
                    displayName: nameBloc.state.text,
                    email: emailBloc.state.text!,
                  );
                } catch (e) {
                  return Messaging.show(
                    message: e.toString(),
                  );
                }

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
          const SafeArea(
            top: false,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
