import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/src/file_picking.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ProfileEditPopup extends StatefulWidget {
  const ProfileEditPopup({super.key});

  @override
  State<ProfileEditPopup> createState() => _ProfileEditPopupState();
}

class _ProfileEditPopupState extends State<ProfileEditPopup> {
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Edit Profile', style: context.textTheme.titleLarge),
          const SizedBox(height: 20),
          Row(
            children: [
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
                      return Navigation.pushMessage(message: e.toString());
                    }
                  } else {
                    Navigation.pushMessage(message: 'No image selected');
                  }
                },
                child: CircleAvatar(
                  radius: context.shortestSide / 8,
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
              const SizedBox(width: 20),
              Expanded(
                child: Card(
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // check if there is an error in email
              if (emailBloc.state.errorText != null) {
                return Navigation.pushMessage(
                  message: emailBloc.state.errorText!,
                );
              }
              // check if there is an error in name
              if (nameBloc.state.errorText != null) {
                return Navigation.pushMessage(
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
                return Navigation.pushMessage(
                  message: e.toString(),
                );
              }

              Navigation.replace(
                widget: const HomeScreen(
                  initialIndex: 3,
                ),
              );
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
