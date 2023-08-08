import 'package:flutter/material.dart';

class FooterPrivacyScreen extends StatelessWidget {
  const FooterPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Wir klauen alle deine Daten\n👍',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
