import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/src/friend.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:fitnessapp/widgets/profile_user_stats_graph.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserProfileFriendsGraphPopup extends StatelessWidget {
  final Friend friend;
  const UserProfileFriendsGraphPopup({
    required this.friend,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileUserStatsGraph(
          interpretation: '${friend.displayName}\'s workout statistics',
          loader: UserRepository.getWorkoutDatesStatistics(
            friend.uid,
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButtonWidget(
            'Remove Friend',
            onPressed: () async {
              await UserRepository.removeFriend(friend);
              Navigation.flush(
                widget: const HomeScreen(
                  initialIndex: 3,
                ),
              );
            },
            foregroundColor: context.config.errorColor,
          ),
        ),
      ],
    );
  }
}
