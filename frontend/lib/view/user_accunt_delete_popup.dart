import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserAccountDeletePopup extends StatefulWidget {
  const UserAccountDeletePopup({super.key});

  @override
  State<UserAccountDeletePopup> createState() => _UserAccountDeletePopupState();
}

class _UserAccountDeletePopupState extends State<UserAccountDeletePopup> {
  PasswordBloc passwordBloc = PasswordBloc();

  String error = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Delete Account', style: context.textTheme.titleLarge),
          const SizedBox(height: 10),
          const Text('Are you sure you want to delete your account?'),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: MyTextField(
                bloc: passwordBloc,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (error.isNotEmpty)
            Text(
              error,
              textAlign: TextAlign.center,
              style: context.textTheme.labelSmall!
                  .copyWith(color: Colors.red, fontSize: 10),
            ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.currentUser
                    ?.reauthenticateWithCredential(
                  EmailAuthProvider.credential(
                    email: FirebaseAuth.instance.currentUser!.email!,
                    password: passwordBloc.state.text ?? '',
                  ),
                );
                await FirebaseAuth.instance.currentUser?.delete();
              } catch (e) {
                error = e.toString().split('] ').last;
                setState(() {});
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
