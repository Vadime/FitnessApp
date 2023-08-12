import 'package:fitness_app/bloc/theme/theme_bloc.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/profile_edit_screen.dart';
import 'package:fitness_app/view/profile_header_widget.dart';
import 'package:fitness_app/view/profile_password_change_popup.dart';
import 'package:fitness_app/view/profile_theme_change_popup.dart';
import 'package:fitness_app/view/profile_user_stats_graph.dart';
import 'package:fitness_app/view/user_accunt_delete_popup.dart';
import 'package:fitness_app/view/user_feedback_screen.dart';
import 'package:fitness_app/view/user_profile_friend_add_popup.dart';
import 'package:fitness_app/view/user_profile_friends_widget.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = UserRepository.currentUser;

    return ListView(
      padding: const EdgeInsets.all(20).addSafeArea(context),
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
        MyCard(
          children: [
            MyListTile(
              title: 'User Feedback',
              trailing: Icon(
                Icons.feedback_rounded,
                color: Colors.accents[1],
              ),
              onTap: () => Navigation.pushPopup(
                widget: const UserFeedbackPopup(),
              ),
            ),
            MyListTile(
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
        MyCard(
          children: [
            MyListTile(
              title: 'Edit Profile',
              trailing: Icon(
                Icons.edit_rounded,
                color: Colors.accents[5],
              ),
              onTap: () =>
                  Navigation.pushPopup(widget: const ProfileEditPopup()),
            ),
            MyListTile(
              title: 'Change Password',
              trailing: Icon(
                Icons.password_rounded,
                color: Colors.accents[3],
              ),
              onTap: () => Navigation.pushPopup(
                widget: const ProfilePasswordChangePopup(),
              ),
            ),
            MyListTile(
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
        MyListTile(
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
