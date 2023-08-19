import 'package:fitnessapp/bloc/theme/theme_bloc.dart';
import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/view/admin_user_feedback_screen.dart';
import 'package:fitnessapp/view/profile_edit_screen.dart';
import 'package:fitnessapp/view/profile_header_widget.dart';
import 'package:fitnessapp/view/profile_password_change_popup.dart';
import 'package:fitnessapp/view/profile_theme_change_popup.dart';
import 'package:fitnessapp/view/profile_user_stats_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

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
        ProfileHeaderWidget(currentUser: currentUser),
        const SizedBox(height: 20),
        ProfileUserStatsGraph(
          loader: WorkoutStatisticsRepository.getWorkoutDatesStatistics(),
        ),
        const SizedBox(height: 20),
        ListTile(
          title: const Text('User Feedback'),
          trailing: Icon(
            Icons.feedback_rounded,
            color: Colors.accents[2],
          ),
          onTap: () => Navigation.push(
            widget: const AdminUserFeedbackScreen(),
          ),
        ),
        const SizedBox(height: 20),
        Text('Settings', style: context.textTheme.bodyMedium),
        const SizedBox(height: 20),
        Card(
          child: Column(
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
                title: 'Change Theme',
                trailing: Icon(
                  {
                    ThemeMode.system: Icons.settings_rounded,
                    ThemeMode.light: Icons.light_mode_rounded,
                    ThemeMode.dark: Icons.dark_mode_rounded,
                  }[context.read<ThemeBloc>().state],
                  color: Colors.accents[3],
                ),
                onTap: () => Navigation.pushPopup(
                  widget: const ProfileThemeChangePopup(),
                ),
              ),
              ListTileWidget(
                title: 'Change Password',
                trailing: Icon(
                  Icons.password_rounded,
                  color: Colors.accents[4],
                ),
                // sign out user from firebase auth
                onTap: () => Navigation.pushPopup(
                  widget: const ProfilePasswordChangePopup(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          title: const Text('Sign Out'),
          trailing: Icon(
            Icons.logout_rounded,
            color: Colors.accents[0],
          ),
          // sign out user from firebase auth
          onTap: () => UserRepository.signOutCurrentUser(),
        ),
        const SafeArea(
          top: false,
          child: SizedBox(height: 0),
        ),
      ],
    );
  }
}
