import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/profile_edit_popup.dart';
import 'package:fitnessapp/pages/profile_password_change_popup.dart';
import 'package:fitnessapp/pages/user_accunt_delete_popup.dart';
import 'package:fitnessapp/pages/user_feedback_popup.dart';
import 'package:fitnessapp/widgets/profile_header_widget.dart';
import 'package:fitnessapp/widgets/profile_user_stats_graph.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = UserRepository.currentUser;

    return ListView(
      padding: const EdgeInsets.all(20).add(context.safeArea),
      children: [
        ProfileHeaderWidget(currentUser: currentUser),
        //const SizedBox(height: 40),
        //Text('Statistics', style: context.textTheme.bodyMedium),
        const SizedBox(height: 20),
        ProfileUserStatsGraph(
          loader: UserRepository.getWorkoutDatesStatistics(),
        ),
        const SizedBox(height: 20),
        Text('Settings', style: context.textTheme.bodyMedium),
        const SizedBox(height: 20),
        ListTileWidget(
          padding: const EdgeInsets.all(20),
          title: 'User Feedback',
          trailing: const Icon(
            Icons.feedback_rounded,
          ),
          onTap: () => Navigation.pushPopup(
            widget: const UserFeedbackPopup(),
          ),
        ),
        const SizedBox(height: 20),
        ThemeSelectionComponent(
          controller: ThemeController.of(context),
        ),
        const SizedBox(height: 20),
        CardWidget(
          children: [
            ListTileWidget(
              padding: const EdgeInsets.all(20),
              title: 'Edit Profile',
              trailing: const Icon(
                Icons.edit_rounded,
              ),
              onTap: () =>
                  Navigation.pushPopup(widget: const ProfileEditPopup()),
            ),
            ListTileWidget(
              padding: const EdgeInsets.all(20),
              title: 'Change Password',
              trailing: const Icon(
                Icons.password_rounded,
              ),
              onTap: () => Navigation.pushPopup(
                widget: const ProfilePasswordChangePopup(),
              ),
            ),
            ListTileWidget(
              padding: const EdgeInsets.all(20),
              title: 'Sign Out',
              trailing: const Icon(
                Icons.logout_rounded,
              ),
              onTap: () => UserRepository.signOutCurrentUser(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ListTileWidget(
          title: 'Delete Account',
          padding: const EdgeInsets.all(20),
          trailing: Icon(
            Icons.delete_rounded,
            color: context.config.errorColor,
          ),
          onTap: () {
            // delete user from firebase auth
            Navigation.pushPopup(widget: const UserAccountDeletePopup());
          },
        ),
      ],
    );
  }
}
