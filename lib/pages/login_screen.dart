import 'package:fitnessapp/database/database.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      onEmailSignUp: (email, password) async {
        await UserRepository.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
      },
      onEmailSignIn: (email, password) async {
        await UserRepository.signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
      },
      onEmailSendPassword: (email) async {
        await UserRepository.sendPasswordResetEmail(
          email: email.text,
        );
        Toast.info('Email sent!', context: context);
      },
      onPhoneSendCode: (phone) async {
        await UserRepository.loginWithPhoneNumber(
          phoneNumber: phone.text,
          onCodeSent: onPhoneVerifyCode,
          onFailed: (error) {
            phone.emptyAllowed = false;
            Toast.error(error, context: context);
          },
        );
      },
    );
  }

  void onPhoneVerifyCode(verificationId, token) {
    Navigation.pop();
    Navigation.pushPopup(
      widget: VerifyPhoneCodeView(
        verifyPhoneCode: (code) async {
          await UserRepository.verifyPhoneCode(
            verificationId: verificationId,
            smsCode: code.text,
          );
        },
      ),
    );
  }
}
