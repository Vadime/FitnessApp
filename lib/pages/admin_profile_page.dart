import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/admin_user_feedback_screen.dart';
import 'package:fitnessapp/pages/branding_popup.dart';
import 'package:fitnessapp/pages/profile_edit_popup.dart';
import 'package:fitnessapp/pages/profile_password_change_popup.dart';
import 'package:fitnessapp/widgets/profile_header_widget.dart';
import 'package:fitnessapp/widgets/user_workout_graph.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage>
    with AutomaticKeepAliveClientMixin {
  List<WorkoutStatistic>? statistics;

  @override
  void initState() {
    WorkoutStatisticsRepository.getWorkoutDatesStatistics().then((value) {
      statistics = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    User? currentUser = UserRepository.currentUser;
    return ScrollViewWidget(
      maxInnerWidth: 600,
      children: [
        ProfileHeaderWidget(currentUser: currentUser),
        const SizedBox(height: 20),
        if (statistics != null)
          UserWorkoutGraph(
            statistics: statistics!,
          ),
        const SizedBox(height: 20),
        ListTileWidget(
          title: 'Nutzer Feedback',
          padding: const EdgeInsets.all(20),
          trailing: const Icon(
            Icons.feedback_rounded,
          ),
          onTap: () => Navigation.push(
            widget: const AdminUserFeedbackScreen(),
          ),
        ),
        const SizedBox(height: 20),
        TextWidget('Einstellungen', style: context.textTheme.bodyMedium),
        const SizedBox(height: 20),
        CardWidget(
          children: [
            ListTileWidget(
              title: 'Profil bearbeiten',
              padding: const EdgeInsets.all(20),
              trailing: const Icon(
                Icons.edit_rounded,
              ),
              onTap: () =>
                  Navigation.pushPopup(widget: const ProfileEditPopup(3)),
            ),
            ListTileWidget(
              title: 'Passwort ändern',
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
        ThemeSelectionComponent(
          controller: ThemeController.of(context),
        ),
        const SizedBox(height: 20),
        ListTileWidget(
          title: 'Ausloggen',
          padding: const EdgeInsets.all(20),
          trailing: Icon(
            Icons.logout_rounded,
            color: context.config.errorColor,
          ),
          // sign out user from firebase auth
          onTap: () => UserRepository.signOutCurrentUser(),
        ),
        const SizedBox(height: 20),
        const BrandingWidget(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
