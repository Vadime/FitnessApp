import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/pages/terms_screen.dart';
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
      termsScreen: const TermsScreen(),
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
        ToastController().show('Email sent!');
      },
      onPhoneSendCode: (phone) async {
        await UserRepository.loginWithPhoneNumber(
          phoneNumber: phone.text,
          onCodeSent: onPhoneVerifyCode,
          onFailed: (error) {
            phone.setError(error);
          },
        );
      },
      onAppleLogin: () async {
        await UserRepository.signInWithApple();
      },
      onGoogleLogin: () async {
        await UserRepository.signInWithGoogle();
      },
    );
  }

  void onPhoneVerifyCode(verificationId, token) {
    Navigation.pop();
    Navigation.push(
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
