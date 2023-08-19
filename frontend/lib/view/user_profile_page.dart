import 'package:fitnessapp/bloc/theme/theme_bloc.dart';
import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/view/profile_edit_screen.dart';
import 'package:fitnessapp/view/profile_header_widget.dart';
import 'package:fitnessapp/view/profile_password_change_popup.dart';
import 'package:fitnessapp/view/profile_theme_change_popup.dart';
import 'package:fitnessapp/view/profile_user_stats_graph.dart';
import 'package:fitnessapp/view/user_accunt_delete_popup.dart';
import 'package:fitnessapp/view/user_feedback_screen.dart';
import 'package:fitnessapp/view/user_profile_friend_add_popup.dart';
import 'package:fitnessapp/view/user_profile_friends_widget.dart';
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
            )
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
              trailing: Icon(
                Icons.feedback_rounded,
                color: Colors.accents[1],
              ),
              onTap: () => Navigation.pushPopup(
                widget: const UserFeedbackPopup(),
              ),
            ),
            ListTileWidget(
              title: 'Change Theme',
              trailing: Icon(
                {
                  ThemeMode.system: Icons.settings_rounded,
                  ThemeMode.light: Icons.light_mode_rounded,
                  ThemeMode.dark: Icons.dark_mode_rounded,
                }[context.read<ThemeBloc>().state],
                color: Colors.accents[2],
              ),
              onTap: () =>
                  Navigation.pushPopup(widget: const ProfileThemeChangePopup()),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CardWidget(
          children: [
            ListTileWidget(
              title: 'Edit Profile',
              trailing: Icon(
                Icons.edit_rounded,
                color: Colors.accents[5],
              ),
              onTap: () =>
                  Navigation.pushPopup(widget: const ProfileEditPopup()),
            ),
            ListTileWidget(
              title: 'Change Password',
              trailing: Icon(
                Icons.password_rounded,
                color: Colors.accents[3],
              ),
              onTap: () => Navigation.pushPopup(
                widget: const ProfilePasswordChangePopup(),
              ),
            ),
            ListTileWidget(
              title: 'Sign Out',
              trailing: Icon(
                Icons.logout_rounded,
                color: Colors.accents[4],
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
            color: Colors.accents[0],
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
