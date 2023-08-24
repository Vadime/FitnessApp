import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home_screen.dart';
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
    return Column(
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
              child: ImageWidget(
                NetworkImage(currentUser!.imageURL!),
                width: 100,
                height: 100,
                radius: 50,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CardWidget(
                children: [
                  TextFieldWidget(
                    controller: nameBloc,
                  ),
                  TextFieldWidget(
                    controller: emailBloc,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            // check if there is an error in email
            if (!emailBloc.isValid()) {
              return Navigation.pushMessage(
                message: emailBloc.errorText!,
              );
            }
            // check if there is an error in name
            if (!nameBloc.isValid()) {
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
    );
  }
}
