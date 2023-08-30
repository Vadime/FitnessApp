import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/models/src/friend.dart';
import 'package:fitnessapp/pages/profile_edit_popup.dart';
import 'package:fitnessapp/pages/profile_password_change_popup.dart';
import 'package:fitnessapp/pages/user_accunt_delete_popup.dart';
import 'package:fitnessapp/pages/user_feedback_popup.dart';
import 'package:fitnessapp/pages/user_profile_friend_add_popup.dart';
import 'package:fitnessapp/widgets/profile_header_widget.dart';
import 'package:fitnessapp/widgets/profile_user_stats_graph.dart';
import 'package:fitnessapp/widgets/user_profile_friends_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  List<Friend>? friends;

  @override
  void initState() {
    super.initState();
    UserRepository.getFriends()
        .then((value) => setState(() => friends = value));
  }

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
            TextButtonWidget(
              'Hinzufügen',
              onPressed: () => Navigation.pushPopup(
                widget: const UserProfileFriendAddPopup(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (friends == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (friends!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget('You have no friends'),
          )
        else
          for (Friend friend in friends!)
            ListTileWidget(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              padding: const EdgeInsets.all(20),
              title: friend.displayName,
              subtitle: friend.contactMethod.value,
              onTap: () => Navigation.pushPopup(
                widget: UserProfileFriendsGraphPopup(
                  friend: friend,
                ),
              ),
              trailing: ImageWidget(
                NetworkImage(friend.imageURL ?? ''),
                width: 40,
                height: 40,
              ),
            ),
        const SizedBox(height: 40),
        Text('Statistics', style: context.textTheme.bodyMedium),
        const SizedBox(height: 20),
        ProfileUserStatsGraph(
          loader: UserRepository.getWorkoutDatesStatistics(),
        ),
        const SizedBox(height: 30),
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
