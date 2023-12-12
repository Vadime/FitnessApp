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
          title: 'OB DICK',
          description: 'Pläne für jedes Fitnesslevel',
          image: 'res/logo/foreground.png',
          backgroundColor: context.config.primaryColor,
          foregroundColor: Colors.white,
        ),
        const OnboardingView(
          title: 'DÜNN',
          description: 'Pläne für jedes Fitnesslevel',
          image: 'res/logo/foreground.png',
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
        ),
        OnboardingView(
          title: 'ODER DOOF',
          description: 'Pläne für jedes Fitnesslevel',
          image: 'res/logo/foreground.png',
          backgroundColor: context.config.primaryColor,
          foregroundColor: Colors.white,
        ),
        const OnboardingView(
          title: 'DU BIST HIER RICHTIG',
          description: 'Pläne für jedes Fitnesslevel',
          image: 'res/logo/foreground.png',
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
        ),
      ],
      onDone: () => Navigation.flush(
        widget: const LoginScreen(),
      ),
    );
  }
}
