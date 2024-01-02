import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:fitnessapp/widgets/user_workout_graph.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class FriendGraphPopup extends StatelessWidget {
  final Friend friend;
  final List<WorkoutStatistic> statitics;
  const FriendGraphPopup({
    required this.friend,
    required this.statitics,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserWorkoutGraph(
          statistics: statitics,
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
