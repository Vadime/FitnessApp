import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:fitnessapp/widgets/friend_stats_graph.dart';
import 'package:fitnessapp/widgets/profile_user_stats_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            if (friends?.first.score != 0)
              SizedBox(
                height: 200,
                child: FriendStatsGraph(friends!),
              ),
            Flexible(
              child: CardWidget.single(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(context.config.radius),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      children: [
                        for (int i = 0; i < friends!.length; i++)
                          friendIsUser(friends![i])
                              ? ListTileWidget(
                                  title: 'You',
                                  subtitle: 'Score: ${friends![i].score}',
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                  ),
                                  selectedColor: context.config.primaryColor
                                      .withOpacity(0.05),
                                  onTap: () => BlocProvider.of<
                                      BottomNavigationPageController>(
                                    context,
                                  ).controller.go(4),
                                )
                              : Theme(
                                  data: Theme.of(context).copyWith(
                                    dividerColor: Colors.transparent,
                                  ),
                                  child: ExpansionTile(
                                    title: Text(
                                      friends![i].friend.displayName,
                                    ),
                                    subtitle:
                                        Text('Score: ${friends![i].score}'),
                                    tilePadding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    childrenPadding: const EdgeInsets.fromLTRB(
                                      20,
                                      0,
                                      20,
                                      10,
                                    ),
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
                                    ),
                                    children: [
                                      ProfileUserStatsGraph(
                                        loader:
                                            (() async => friends![i].stats)(),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: TextButtonWidget(
                                          'Remove Friend',
                                          onPressed: () async {
                                            await UserRepository.removeFriend(
                                              friends![i].friend,
                                            );
                                            Navigation.flush(
                                              widget: const HomeScreen(
                                                initialIndex: 3,
                                              ),
                                            );
                                          },
                                          foregroundColor:
                                              context.config.errorColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // if (friends != null)
            //   TextWidget(
            //     '${friends!.first.friend.displayName} hat zurzeit den größten yarak und\n${friends!.last.friend.displayName} ist ein Hurensohn!',
            //     align: TextAlign.center,
            //     color: context.config.neutralColor,
            //   ),
            const SizedBox(height: 10),
          ],
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
