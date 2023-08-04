import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class DeleteAccountPopup extends StatelessWidget {
  const DeleteAccountPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Delete Account', style: context.textTheme.titleLarge),
            const SizedBox(height: 10),
            const Text('Are you sure you want to delete your account?'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                FirebaseAuth.instance.currentUser?.delete();
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
