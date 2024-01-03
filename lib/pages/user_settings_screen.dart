import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/pages/branding_popup.dart';
import 'package:fitnessapp/pages/profile_edit_screen.dart';
import 'package:fitnessapp/pages/profile_password_change_screen.dart';
import 'package:fitnessapp/pages/user_accunt_delete_popup.dart';
import 'package:fitnessapp/pages/user_feedback_popup.dart';
import 'package:fitnessapp/pages/user_help_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Einstellungen',
      body: ScrollViewWidget(
        children: [
          TextWidget(
            'Darstellung',
            style: context.textTheme.labelLarge,
          ),
          const SizedBox(height: 20),
          ThemeSelectionComponent(
            controller: ThemeController.of(context),
          ),
          const SizedBox(height: 20),
          TextWidget(
            'Profileinstellungen',
            style: context.textTheme.labelLarge,
          ),
          const SizedBox(height: 20),
          CardWidget(
            children: [
              ListTileWidget(
                title: 'Profil bearbeiten',
                trailing: const Icon(
                  Icons.edit_rounded,
                ),
                onTap: () async {
                  await Navigation.push(
                    widget: const ProfileEditScreen(4),
                  );
                },
              ),
              ListTileWidget(
                title: 'Passwort ändern',
                trailing: const Icon(
                  Icons.password_rounded,
                ),
                onTap: () => Navigation.push(
                  widget: const ProfilePasswordChangeScreen(),
                ),
              ),
              ListTileWidget(
                title: 'Ausloggen',
                trailing: const Icon(
                  Icons.logout_rounded,
                ),
                onTap: () => UserRepository.signOutCurrentUser(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextWidget(
            'Sonstiges',
            style: context.textTheme.labelLarge,
          ),
          const SizedBox(height: 20),
          CardWidget(
            children: [
              ListTileWidget(
                title: 'Nutzer Feedback',
                trailing: const Icon(
                  Icons.feedback_rounded,
                ),
                onTap: () => Navigation.push(
                  widget: const UserFeedbackScreen(),
                ),
              ),
              ListTileWidget(
                title: 'Hilfe Center',
                trailing: Icon(
                  Icons.help_center_rounded,
                  color: context.config.primaryColor,
                ),
                onTap: () {
                  // delete user from firebase auth
                  Navigation.push(
                    widget: const UserHelpScreen(),
                  );
                },
              ),
              ListTileWidget(
                title: 'Account löschen',
                trailing: Icon(
                  Icons.delete_rounded,
                  color: context.config.errorColor,
                ),
                onTap: () {
                  // delete user from firebase auth
                  Navigation.pushPopup(
                    widget: const UserAccountDeletePopup(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const BrandingWidget(),
        ],
      ),
    );
  }
}
