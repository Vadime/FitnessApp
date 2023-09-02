import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/widgets/user_profile_friends_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets/widgets.dart';

class FriendUI {
  final Friend friend;
  int score;

  FriendUI({required this.friend, this.score = 0});
}

class UserFriendListPage extends StatefulWidget {
  const UserFriendListPage({super.key});

  @override
  State<UserFriendListPage> createState() => _UserFriendListPageState();
}

class _UserFriendListPageState extends State<UserFriendListPage> {
  List<FriendUI>? friends;

  @override
  void initState() {
    super.initState();
    getFriendsAndStats();
  }

  Future<void> getFriendsAndStats() async {
    friends = (await UserRepository.getFriends())
        .map((e) => FriendUI(friend: e))
        .toList();
    setState(() {});
    for (var friend in friends!) {
      friend.score = await countOverallPoints(friend.friend);
      setState(() {});
    }

    var me = Friend.fromUser(UserRepository.currentUser!);
    friends!.add(
      FriendUI(
        friend: me,
        score: await countOverallPoints(me),
      ),
    );

    friends!.sort((f1, f2) => f2.score.compareTo(f1.score));

    for (var element in friends!) {
      Logging.log(element.score);
    }
    setState(() {});
  }

  Future<int> countOverallPoints(Friend friend) async {
    var listOfWorkoutStatistics =
        await UserRepository.getWorkoutDatesStatistics(
      friend.uid,
    );
    int result = 0;
    for (var stat in listOfWorkoutStatistics) {
      result += stat.points;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (friends == null) {
      return const SizedBox(
        height: 100,
        child: LoadingWidget(),
      );
    } else if (friends!.isEmpty) {
      return const SizedBox(
        height: 100,
        child: FailWidget('You have no friends'),
      );
    } else {
      return ListView(
        children: [
          const SizedBox(height: 10),
          for (int i = 0; i < friends!.length; i++)
            ListTileWidget(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              padding: const EdgeInsets.all(20),
              selectedColor:
                  UserRepository.currentUser!.uid == friends![i].friend.uid
                      ? context.config.primaryColor.withOpacity(0.2)
                      : null,
              title: friends![i].friend.displayName,
              subtitle: 'Score: ${friends![i].score}',
              // friends![i].friend.contactMethod.value,
              // from the changenotifier provider in the bottomnavigationpage
              onTap: () =>
                  UserRepository.currentUser!.uid == friends![i].friend.uid
                      ? context.read<PageController>().go(4)
                      : Navigation.pushPopup(
                          widget: UserProfileFriendsGraphPopup(
                            friend: friends![i].friend,
                          ),
                        ),
              leading: TextWidget(
                (i + 1).toString(),
                color: context.config.neutralColor,
                margin: const EdgeInsets.only(right: 20),
              ),
              trailing: ImageWidget(
                NetworkImage(friends![i].friend.imageURL ?? ''),
                width: 40,
                height: 40,
              ),
            ),
          const SizedBox(height: 10),
        ],
      );
    }
  }
}
