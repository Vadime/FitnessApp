import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserProfileFriendAddPopup extends StatefulWidget {
  const UserProfileFriendAddPopup({super.key});

  @override
  State<UserProfileFriendAddPopup> createState() =>
      _UserProfileFriendAddPopupState();
}

class _UserProfileFriendAddPopupState extends State<UserProfileFriendAddPopup> {
  TextFieldController emailController = TextFieldController.email();
  TextFieldController phoneController = TextFieldController.phone();
  ContactType type = ContactType.email;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            TextWidget(
              'Freund hinzufügen',
              style: context.textTheme.titleMedium,
            ),
            const Spacer(),
            TextButtonWidget(
              'Ändern auf ${type == ContactType.email ? ContactType.phone.str : ContactType.email.str}',
              onPressed: () => setState(
                () => type == ContactType.email
                    ? type = ContactType.phone
                    : type = ContactType.email,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextFieldWidget(
          controller:
              type == ContactType.email ? emailController : phoneController,
          autofocus: true,
        ),
        const SizedBox(height: 20),
        ElevatedButtonWidget(
          'Freund hinzufügen',
          onPressed: () async {
            // check if there is an error in email
            if (type == ContactType.email) {
              if (emailController.isValid()) {
                // add friend
                try {
                  await UserRepository.addFriendByEmail(emailController.text);
                  Navigation.flush(
                    widget: const HomeScreen(initialIndex: 3),
                  );
                } catch (e) {
                  emailController.setError(e.toString());
                  return;
                }
              }
            }

            // check if there is an error in email
            if (type == ContactType.phone) {
              if (phoneController.isValid()) {
                // add friend
                try {
                  await UserRepository.addFriendByPhone(phoneController.text);
                  Navigation.flush(
                    widget: const HomeScreen(initialIndex: 3),
                  );
                } catch (e) {
                  phoneController.setError(e.toString());
                  return;
                }
              }
            }
            setState(() {});
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
