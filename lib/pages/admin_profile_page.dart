import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/admin_user_feedback_screen.dart';
import 'package:fitnessapp/pages/profile_edit_popup.dart';
import 'package:fitnessapp/pages/profile_password_change_popup.dart';
import 'package:fitnessapp/widgets/profile_header_widget.dart';
import 'package:fitnessapp/widgets/profile_user_stats_graph.dart';
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
        ListTileWidget(
          title: 'User Feedback',
          padding: const EdgeInsets.all(20),
          trailing: const Icon(
            Icons.feedback_rounded,
          ),
          onTap: () => Navigation.push(
            widget: const AdminUserFeedbackScreen(),
          ),
        ),
        const SizedBox(height: 20),
        Text('Settings', style: context.textTheme.bodyMedium),
        const SizedBox(height: 20),
        CardWidget(
          children: [
            ListTileWidget(
              title: 'Edit Profile',
              padding: const EdgeInsets.all(20),
              trailing: const Icon(
                Icons.edit_rounded,
              ),
              onTap: () =>
                  Navigation.pushPopup(widget: const ProfileEditPopup()),
            ),
            ListTileWidget(
              title: 'Change Password',
              padding: const EdgeInsets.all(20),

              trailing: const Icon(
                Icons.password_rounded,
              ),
              // sign out user from firebase auth
              onTap: () => Navigation.pushPopup(
                widget: const ProfilePasswordChangePopup(),
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
        ListTileWidget(
          title: 'Sign Out',
          padding: const EdgeInsets.all(20),
          trailing: Icon(
            Icons.logout_rounded,
            color: context.config.errorColor,
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
