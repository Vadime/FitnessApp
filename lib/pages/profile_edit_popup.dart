import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ProfileEditPopup extends StatefulWidget {
  final int initialHomeIndex;
  const ProfileEditPopup(this.initialHomeIndex, {super.key});

  @override
  State<ProfileEditPopup> createState() => _ProfileEditPopupState();
}

class _ProfileEditPopupState extends State<ProfileEditPopup> {
  late TextFieldController nameBloc;
  late TextFieldController contactBloc;

  @override
  void initState() {
    super.initState();
    nameBloc = TextFieldController.name(text: UserRepository.currentUserName);
    if (UserRepository.currentUserContact?.type == ContactType.email) {
      contactBloc =
          TextFieldController.email(text: UserRepository.currentUserEmail);
    } else if (UserRepository.currentUserContact?.type == ContactType.phone) {
      contactBloc =
          TextFieldController.phone(text: UserRepository.currentUserPhone);
    } else {
      contactBloc = TextFieldController(
        UserRepository.currentUserContact?.name,
        text: UserRepository.currentUserContact?.value,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextWidget('Edit Profile', style: context.textTheme.titleLarge),
        const SizedBox(height: 20),
        Row(
          children: [
            ImageWidget(
              UserRepository.currentUserImageURL == null
                  ? null
                  : NetworkImage(UserRepository.currentUserImageURL!),
              radius: 50,
              width: 100,
              height: 100,
              onTap: () async {
                var image = await FilePicking.pickImage();
                if (image == null) return;
                try {
                  await UserRepository.updateCurrentUserImage(image: image);
                  setState(() {});
                } catch (e) {
                  ToastController().show(e);
                  return;
                }
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
                  // only enable to change contactInfo if it is an Email one
                  // because phone number updates needs a verification code
                  // can be done in the future
                  TextFieldWidget(
                    controller: contactBloc,
                    // enabled: UserRepository.currentUserContact?.type ==
                    //     ContactType.email,
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
            if (!contactBloc.isValid()) return;
            // check if there is an error in name
            if (!nameBloc.isValid()) return;

            // update user profile
            try {
              await UserRepository.updateCurrentUserName(nameBloc.text);
              if (UserRepository.currentUserContact?.type ==
                  ContactType.email) {
                await UserRepository.updateCurrentUserEmail(contactBloc.text);
                await UserRepository.reloadCurrentUser();
                navigate();
              } else if (UserRepository.currentUserContact?.type ==
                  ContactType.phone) {
                await UserRepository.updateCurrentUserPhone(
                  phoneNumber: contactBloc.text,
                  onCompletion: () async {
                    await UserRepository.reloadCurrentUser();
                    navigate();
                  },
                  onCodeSent: onPhoneVerifyCode,
                  onFailed: (error) {
                    contactBloc.setError(error);
                  },
                );
              }
            } catch (e) {
              return ToastController().show(e);
            }
          },
        ),
      ],
    );
  }

  Future<void> onPhoneVerifyCode(verificationId, token) async {
    Navigation.pushPopup(
      widget: VerifyPhoneCodeView(
        verifyPhoneCode: (code) async {
          await UserRepository.verifyUpdatedPhoneCode(
            verificationId: verificationId,
            smsCode: code.text,
          );
          await UserRepository.reloadCurrentUser();
          navigate();
        },
      ),
    );
  }

  navigate() => Navigation.flush(
        widget: HomeScreen(
          initialIndex: widget.initialHomeIndex,
        ),
      );
}
