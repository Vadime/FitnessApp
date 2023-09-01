import 'package:fitnessapp/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      views: [
        OnboardingView(
          title: 'OB FETT',
          description: 'Pläne für jeden Fitnesslevel',
          image: 'res/logo/foreground.png',
          backgroundColor: context.config.primaryColor,
          foregroundColor: Colors.white,
        ),
        const OnboardingView(
          title: 'DÜNN',
          description: 'Pläne für jeden Fitnesslevel',
          image: 'res/logo/foreground.png',
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        const OnboardingView(
          title: 'ODER DOOF',
          description: 'Pläne für jeden Fitnesslevel',
          image: 'res/logo/foreground.png',
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        const OnboardingView(
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
