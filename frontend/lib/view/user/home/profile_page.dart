import 'package:fitness_app/bloc/theme/theme_bloc.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/both/change_password_screen.dart';
import 'package:fitness_app/view/both/home/drawer_theme_change_popup.dart';
import 'package:fitness_app/view/user/home/drawer_accunt_delete_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = UserRepository.currentUser;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SafeArea(
          bottom: false,
          child: SizedBox(height: 0),
        ),
        Row(
          children: [
            CircleAvatar(
              radius: context.shortestSide / 7,
              backgroundColor: context.theme.cardColor,
              foregroundImage: currentUser?.imageURL == null
                  ? null
                  : NetworkImage(
                      currentUser!.imageURL!,
                    ),
              child: Icon(
                Icons.person_4_rounded,
                size: context.shortestSide / (5),
                color: context.theme.scaffoldBackgroundColor,
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      title: const Text('Name'),
                      subtitle: Text(currentUser?.displayName ?? '-'),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      title: const Text('Email'),
                      subtitle: Text(currentUser?.email ?? '-'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Card(
          child: SizedBox(
            height: 300,
            child: Center(
              child: Text(
                'Vieleicht noch ein paar Statistiken vom Nutzer\n👍',
                textAlign: TextAlign.center,
                style: context.textTheme.labelMedium,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('Settings', style: context.textTheme.bodyMedium),
        const SizedBox(height: 20),
        Card(
          child: Column(
            children: [
              // toggle theme mode
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                title: const Text('Change Theme'),
                trailing: Icon(
                  {
                    ThemeMode.system: Icons.settings_rounded,
                    ThemeMode.light: Icons.light_mode_rounded,
                    ThemeMode.dark: Icons.dark_mode_rounded,
                  }[context.read<ThemeBloc>().state],
                ),
                onTap: () =>
                    Navigation.pushPopup(widget: const ChangeThemePopup()),
              ),
              // change password
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),

                title: const Text('Change Password'),
                trailing: const Icon(
                  Icons.password_rounded,
                ),
                // sign out user from firebase auth
                onTap: () =>
                    Navigation.push(widget: const ChangePasswordScreen()),
              ),
              // sign out
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),

                title: const Text('Sign Out'),
                trailing: const Icon(
                  Icons.logout_rounded,
                ),
                // sign out user from firebase auth
                onTap: () => UserRepository.signOutCurrentUser(),
              ),
              // delete account
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                title: const Text('Delete Account'),
                trailing: const Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                ),
                onTap: () {
                  // delete user from firebase auth
                  Navigation.pushPopup(widget: const DeleteAccountPopup());
                },
              ),
            ],
          ),
        ),
        const SafeArea(
          top: false,
          child: SizedBox(height: 20),
        ),
      ],
    );
  }
}
