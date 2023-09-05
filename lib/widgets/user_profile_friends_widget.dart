import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:fitnessapp/widgets/profile_user_stats_graph.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserProfileFriendsGraphPopup extends StatelessWidget {
  final Friend friend;
  final Future<List<WorkoutStatistic>> loader;
  const UserProfileFriendsGraphPopup({
    required this.friend,
    required this.loader,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileUserStatsGraph(
          //interpretation: '${friend.displayName}\'s workout statistics',
          loader: loader,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(friend.displayName),
            const Spacer(),
            TextButtonWidget(
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
          ],
        ),
      ],
    );
  }
}
