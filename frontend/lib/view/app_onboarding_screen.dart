import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/models/onboarding_page_data.dart';
import 'package:onboarding/view/onboarding_screen.dart';

class AppOnboardingScreen extends StatelessWidget {
  const AppOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      data: const [
        OnboardingPageData(
          title: 'OB FETT',
          description: 'Pläne für jeden Fitnesslevel',
          image: 'res/logo/foreground.png',
          color: Colors.red,
        ),
        OnboardingPageData(
          title: 'DÜNN',
          description: 'Pläne für jeden Fitnesslevel',
          image: 'res/logo/foreground.png',
          color: Colors.blue,
        ),
        OnboardingPageData(
          title: 'ODER DOOF',
          description: 'Pläne für jeden Fitnesslevel',
          image: 'res/logo/foreground.png',
          color: Colors.green,
        ),
        OnboardingPageData(
          title: 'DU BIST HIER RICHTIG',
          description: 'Pläne für jeden Fitnesslevel',
          image: 'res/logo/foreground.png',
          color: Colors.amber,
        ),
      ],
      onDone: () => Navigation.flush(widget: const LoginScreen()),
    );
  }
}
