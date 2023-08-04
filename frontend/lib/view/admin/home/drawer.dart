import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/bloc/theme/theme_bloc.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/both/about_screen.dart';
import 'package:fitness_app/view/both/home/drawer_theme_change_popup.dart';
import 'package:fitness_app/view/both/home/profile_edit_screen.dart';
import 'package:fitness_app/view/both/privacy_screen.dart';
import 'package:fitness_app/view/both/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widgets/widgets.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      surfaceTintColor: context.theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 220,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.theme.primaryColor,
                  context.theme.scaffoldBackgroundColor
                ],
              ),
              color: context.theme.primaryColor,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text('Settings', style: context.textTheme.titleMedium),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(20),
            // toggle theme mode
            child: ListTile(
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
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                // edit profile
                ListTile(
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.edit_rounded),
                  onTap: () =>
                      Navigation.push(widget: const EditProfileScreen()),
                ),
                // sign out
                ListTile(
                  title: const Text('Sign Out'),
                  trailing: const Icon(
                    Icons.logout_rounded,
                  ),
                  // sign out user from firebase auth
                  onTap: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
          ),
          const Spacer(),
          Footer(
            commercialText: 'made with ❤️',
            socials: [
              SocialButton(
                text: 'Twitter',
                onPressed: () async => await UriLaunching.launch(
                  Uri.parse('https://pornhub.com'),
                ),
                icon: const FaIcon(FontAwesomeIcons.twitter),
              )
            ],
            buttons: [
              FooterButton(
                text: 'About',
                onPressed: () => Navigation.push(widget: const AboutScreen()),
              ),
              FooterButton(
                text: 'Contact',
                onPressed: () async {
                  await UriLaunching.launch(
                    Uri.parse(
                      'mailto:traumteam@email.de?subject=Angelegenheit',
                    ),
                  ).then((value) {
                    if (!value) {
                      Navigation.pop();
                      Messaging.show(
                        message: 'Could not launch url',
                      );
                    }
                  }).catchError((e) {
                    debugPrint(e.toString());
                  });
                },
              ),
              FooterButton(
                text: 'Privacy',
                onPressed: () => Navigation.push(widget: const PrivacyScreen()),
              ),
              FooterButton(
                text: 'Terms',
                onPressed: () => Navigation.push(widget: const TermsScreen()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
