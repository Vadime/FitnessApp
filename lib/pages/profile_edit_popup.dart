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
  late TextFieldController contactBloc;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = UserRepository.currentUser;
    nameBloc = TextFieldController.name(text: currentUser?.displayName);
    if (currentUser?.contactAdress.type == ContactType.email) {
      contactBloc =
          TextFieldController.email(text: currentUser?.contactAdress.value);
    } else if (currentUser?.contactAdress.type == ContactType.phone) {
      contactBloc =
          TextFieldController.phone(text: currentUser?.contactAdress.value);
    } else {
      contactBloc = TextFieldController(
        currentUser?.contactAdress.name,
        text: currentUser?.contactAdress.value,
      );
    }
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
            ImageWidget(
              NetworkImage(currentUser!.imageURL!),
              width: 100,
              height: 100,
              onTap: () async {
                var image = await FilePicking.pickImage();
                if (image != null) {
                  try {
                    await UserRepository.updateCurrentUserImage(image: image);
                    setState(() {
                      currentUser = UserRepository.currentUser;
                    });
                  } catch (e) {
                    Logging.log(e);
                    return Messaging.info(
                      e.toString(),
                      context: context,
                    );
                  }
                } else {}
              },
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CardWidget(
                children: [
                  TextFieldWidget(
                    controller: nameBloc,
                    autofocus: true,
                  ),
                  TextFieldWidget(
                    controller: contactBloc,
                    autofocus: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButtonWidget(
          'Save Changes',
          onPressed: () async {
            // check if there is an error in email
            if (!contactBloc.isValid()) {
              return Messaging.info(
                contactBloc.errorText!,
                context: context,
              );
            }
            // check if there is an error in name
            if (!nameBloc.isValid()) {
              return Messaging.info(
                nameBloc.errorText!,
                context: context,
              );
            }

            // update user profile
            try {
              await UserRepository.updateCurrentUserProfile(
                displayName: nameBloc.text,
                email: contactBloc.text,
              );
            } catch (e) {
              return Messaging.info(
                e.toString(),
                context: context,
              );
            }

            Navigation.flush(
              widget: const HomeScreen(
                initialIndex: 3,
              ),
            );
          },
        ),
      ],
    );
  }
}
