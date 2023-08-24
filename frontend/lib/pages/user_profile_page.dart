import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/profile_edit_screen.dart';
import 'package:fitnessapp/pages/profile_password_change_popup.dart';
import 'package:fitnessapp/pages/user_accunt_delete_popup.dart';
import 'package:fitnessapp/pages/user_feedback_screen.dart';
import 'package:fitnessapp/pages/user_profile_friend_add_popup.dart';
import 'package:fitnessapp/widgets/profile_header_widget.dart';
import 'package:fitnessapp/widgets/profile_user_stats_graph.dart';
import 'package:fitnessapp/widgets/user_profile_friends_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = UserRepository.currentUser;

    return ListView(
      padding: const EdgeInsets.all(20).add(context.safeArea),
      children: [
        ProfileHeaderWidget(currentUser: currentUser),
        const SizedBox(height: 40),
        Row(
          children: [
            Text('Freunde', style: context.textTheme.bodyMedium),
            const Spacer(),
            TextButton(
              onPressed: () => Navigation.pushPopup(
                widget: const UserProfileFriendAddPopup(),
              ),
              child: Text(
                'Hinzufügen',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const UserProfileFriendsWidget(),
        const SizedBox(height: 40),
        Text('Statistics', style: context.textTheme.bodyMedium),
        const SizedBox(height: 40),
        ProfileUserStatsGraph(
          loader: UserRepository.getWorkoutDatesStatistics(),
        ),
        const SizedBox(height: 40),
        Text('Settings', style: context.textTheme.bodyMedium),
        const SizedBox(height: 20),
        CardWidget(
          children: [
            ListTileWidget(
              title: 'User Feedback',
              trailing: const Icon(
                Icons.feedback_rounded,
              ),
              onTap: () => Navigation.pushPopup(
                widget: const UserFeedbackPopup(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        BlocBuilder<ThemeController, ThemeMode>(
          builder: (context, state) {
            return ThemeSelectionComponent(
              controller: ThemeController.of(context),
            );
          },
        ),
        const SizedBox(height: 20),
        CardWidget(
          children: [
            ListTileWidget(
              title: 'Edit Profile',
              trailing: const Icon(
                Icons.edit_rounded,
              ),
              onTap: () =>
                  Navigation.pushPopup(widget: const ProfileEditPopup()),
            ),
            ListTileWidget(
              title: 'Change Password',
              trailing: const Icon(
                Icons.password_rounded,
              ),
              onTap: () => Navigation.pushPopup(
                widget: const ProfilePasswordChangePopup(),
              ),
            ),
            ListTileWidget(
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
          trailing: Icon(
            Icons.delete_rounded,
            color: context.theme.colorScheme.error,
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
