import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/branding_popup.dart';
import 'package:fitnessapp/pages/profile_edit_popup.dart';
import 'package:fitnessapp/pages/profile_password_change_popup.dart';
import 'package:fitnessapp/pages/user_accunt_delete_popup.dart';
import 'package:fitnessapp/pages/user_feedback_popup.dart';
import 'package:fitnessapp/pages/user_help_screen.dart';
import 'package:fitnessapp/pages/user_statistics_screen.dart';
import 'package:fitnessapp/widgets/profile_header_widget.dart';
import 'package:fitnessapp/widgets/profile_user_stats_graph.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    User? currentUser = UserRepository.currentUser;

    return ScrollViewWidget(
      maxInnerWidth: 600,
      children: [
        ProfileHeaderWidget(currentUser: currentUser),
        const SizedBox(height: 20),
        ProfileUserStatsGraph(
          loader: UserRepository.getWorkoutDatesStatistics(),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButtonWidget(
            'Weitere Statistiken',
            onPressed: () {
              Navigation.push(
                widget: const UserStatisticsScreen(),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        ListTileWidget(
          title: 'Nutzer Feedback',
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
              title: 'Profil bearbeiten',
              trailing: const Icon(
                Icons.edit_rounded,
              ),
              onTap: () async {
                await Navigation.pushPopup(
                  widget: const ProfileEditPopup(4),
                  c: context,
                );
              },
            ),
            ListTileWidget(
              title: 'Passwort ändern',
              trailing: const Icon(
                Icons.password_rounded,
              ),
              onTap: () => Navigation.pushPopup(
                widget: const ProfilePasswordChangePopup(),
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
        CardWidget(
          children: [
            ListTileWidget(
              title: 'Help Center',
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
