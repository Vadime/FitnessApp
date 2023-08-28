import 'package:fitnessapp/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      views: const [
        OnboardingView(
          title: 'OB FETT',
          description: 'Pläne für jeden Fitnesslevel',
          image: 'res/logo/foreground.png',
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        OnboardingView(
          title: 'DÜNN',
          description: 'Pläne für jeden Fitnesslevel',
          image: 'res/logo/foreground.png',
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        OnboardingView(
          title: 'ODER DOOF',
          description: 'Pläne für jeden Fitnesslevel',
          image: 'res/logo/foreground.png',
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        OnboardingView(
          title: 'DU BIST HIER RICHTIG',
          description: 'Pläne für jeden Fitnesslevel',
          image: 'res/logo/foreground.png',
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
      ],
      onDone: () => Navigation.flush(
        widget: const LoginScreen(),
      ),
    );
  }
}
