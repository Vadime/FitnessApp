import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/src/friend.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:fitness_app/view/profile_user_stats_graph.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class UserProfileFriendsWidget extends StatelessWidget {
  const UserProfileFriendsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserRepository.getFriends(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 100,
            child: MyLoadingWidget(),
          );
        }
        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 100,
            child: MyErrorWidget(error: 'You have no friends'),
          );
        }

        return Column(
          children: [
            for (Friend friend in snapshot.data!)
              MyListTile(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                title: friend.displayName,
                subtitle: friend.email,
                onTap: () => Navigation.pushPopup(
                  widget: UserProfileFriendsGraphPopup(
                    friend: friend,
                  ),
                ),
                trailing: CircleAvatar(
                  backgroundImage: friend.imageURL == null
                      ? null
                      : NetworkImage(friend.imageURL!),
                ),
              ),
          ],
        );
      },
    );
  }
}

class UserProfileFriendsGraphPopup extends StatelessWidget {
  final Friend friend;
  const UserProfileFriendsGraphPopup({
    required this.friend,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileUserStatsGraph(
            interpretation: '${friend.displayName}\'s workout statistics',
            loader: UserRepository.getWorkoutDatesStatistics(
              friend.uid,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await UserRepository.removeFriend(friend.uid);
              Navigation.flush(
                widget: const HomeScreen(
                  initialIndex: 3,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove Friend'),
          )
        ],
      ),
    );
  }
}
