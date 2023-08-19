import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ProfileEditPopup extends StatefulWidget {
  const ProfileEditPopup({super.key});

  @override
  State<ProfileEditPopup> createState() => _ProfileEditPopupState();
}

class _ProfileEditPopupState extends State<ProfileEditPopup> {
  late TextFieldController nameBloc;
  late TextFieldController emailBloc;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = UserRepository.currentUser;
    nameBloc = TextFieldController.name(text: currentUser?.displayName);
    emailBloc = TextFieldController.email(text: currentUser?.email);
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
                  radius: MediaQuery.of(context).size.shortestSide / 8,
                  backgroundColor: context.theme.cardColor,
                  foregroundImage: currentUser?.imageURL == null
                      ? null
                      : NetworkImage(
                          currentUser!.imageURL!,
                        ),
                  child: Icon(
                    Icons.person_4_rounded,
                    size: MediaQuery.of(context).size.shortestSide / (5),
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
                        TextFieldWidget(
                          nameBloc,
                        ),
                        const SizedBox(height: 10),
                        TextFieldWidget(
                          emailBloc,
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
              if (emailBloc.errorText != null) {
                return Navigation.pushMessage(
                  message: emailBloc.errorText!,
                );
              }
              // check if there is an error in name
              if (nameBloc.errorText != null) {
                return Navigation.pushMessage(
                  message: nameBloc.errorText!,
                );
              }

              // update user profile
              try {
                await UserRepository.updateCurrentUserProfile(
                  displayName: nameBloc.text,
                  email: emailBloc.text,
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
