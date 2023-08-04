import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Wir dürfen mit dir machen, was wir wollen\n👍',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
