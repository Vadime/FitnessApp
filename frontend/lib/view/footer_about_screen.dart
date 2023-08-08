import 'package:flutter/material.dart';

class FooterAboutScreen extends StatelessWidget {
  const FooterAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Muss irgendein Faultier aus meinem Team machen\n👍',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
