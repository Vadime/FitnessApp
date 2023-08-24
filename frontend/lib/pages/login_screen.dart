import 'package:fitnessapp/database/database.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      onEmailSignUp: (email, password) async {
        try {
          await UserRepository.createUserWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );
        } catch (e) {
          Navigation.pushMessage(message: e.toString());
          return;
        }
      },
      onEmailSignIn: (email, password) async {
        try {
          await UserRepository.signInWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );
        } catch (e) {
          Navigation.pushMessage(message: e.toString());
          return;
        }
      },
      onEmailSendPassword: (email) async {
        try {
          await UserRepository.sendPasswordResetEmail(
            email: email.text,
          );
          Navigation.pushMessage(message: 'Email sent!');
        } catch (e) {
          Navigation.pushMessage(message: e.toString());
          return;
        }
      },
      onPhoneSendCode: (phone) {
        Navigation.pushMessage(message: 'Not supported yet!');
      },
      onPhoneVerifyCode: (code) {
        Navigation.pushMessage(message: 'Not supported yet!');
      },
      onAppleLogin: () {
        Navigation.pushMessage(message: 'Not supported yet!');
      },
    );
  }
}
