import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/widgets/friend_stats_graph.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class FriendUI {
  final Friend friend;
  final List<WorkoutStatistic> stats;

  const FriendUI({required this.friend, required this.stats});

  FriendUI.empty()
      : friend = const Friend(
          uid: '',
          displayName: '',
          contactMethod: ContactMethod.unknown(),
          imageURL: null,
        ),
        stats = const [];

  int get score {
    int result = 0;
    for (var stat in stats) {
      result += stat.points;
    }
    return result;
  }
}

class UserFriendListPage extends StatefulWidget {
  const UserFriendListPage({super.key});

  @override
  State<UserFriendListPage> createState() => _UserFriendListPageState();
}

class _UserFriendListPageState extends State<UserFriendListPage>
    with AutomaticKeepAliveClientMixin {
  List<FriendUI>? friends;

  @override
  void initState() {
    super.initState();
    getFriendsAndStats();
  }

  Future<void> getFriendsAndStats() async {
    var friendList = await UserRepository.getFriends();
    friendList.add(Friend.fromUser(UserRepository.currentUser!));
    friends = List<FriendUI>.filled(
      friendList.length,
      FriendUI.empty(),
    );

    for (int i = 0; i < friendList.length; i++) {
      Friend friend = friendList[i];
      friends![i] = FriendUI(
        friend: friend,
        stats: await UserRepository.getWorkoutDatesStatistics(friend.uid),
      );
      friends!.sort((f1, f2) => f2.score.compareTo(f1.score));
      setState(() {});
    }

    setState(() {});
  }

  bool friendIsUser(FriendUI friend) =>
      UserRepository.currentUser!.uid == friend.friend.uid;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (friends == null) {
      return const SizedBox(
        height: 100,
        child: LoadingWidget(),
      );
    } else if (friends!.length == 1) {
      return const SizedBox(
        height: 100,
        child: FailWidget('You have no friends'),
      );
    } else {
      return ScrollViewWidget(
        maxInnerWidth: 600,
        children: [
          if (friends?.first.score != 0)
            SizedBox(
              height: 200,
              child: FriendStatsGraph(friends!),
            ),
          const SizedBox(height: 20),
          for (int i = 0; i < friends!.length; i++)
            //if (friendIsUser(friends![i]))
            ListTileWidget(
              title: friends![i].friend.displayName,
              subtitle: 'Score: ${friends![i].score}',
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              leading: TextWidget(
                (i + 1).toString(),
                color: context.config.neutralColor,
                margin: const EdgeInsets.only(right: 20),
              ),
              trailing: ImageWidget(
                NetworkImage(
                  friends![i].friend.imageURL ?? '',
                ),
                width: 50,
                height: 50,
                radius: 25,
              ),
              selectedColor: friendIsUser(friends![i])
                  ? context.config.primaryColor.withOpacity(0.05)
                  : null,
            ),
        ],
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
