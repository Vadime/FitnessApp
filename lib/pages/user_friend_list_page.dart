import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/widgets/user_profile_friends_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class _UserFriendListPageState extends State<UserFriendListPage> {
  List<FriendUI>? friends;

  @override
  void initState() {
    super.initState();
    getFriendsAndStats();
  }

  Future<void> getFriendsAndStats() async {
    var friendList = await UserRepository.getFriends();
    friendList.add(Friend.fromUser(UserRepository.currentUser!));
    friends = List<FriendUI>.filled(friendList.length, FriendUI.empty());

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

  List<ChartWidgetBarGroup> bars() {
    List<ChartWidgetBarGroup> bars = List<ChartWidgetBarGroup>.generate(
      3,
      (index) => ChartWidgetBarGroup(
        title: '',
        x: index,
        rods: [
          ChartWidgetBarRodStd(
            0,
            color: context.config.primaryColor.withOpacity(0.2),
            width: 60,
          ),
        ],
      ),
    );

    for (int i = 0; i < 3; i++) {
      bars[i] = ChartWidgetBarGroup(
        title: friends![i].friend.displayName,
        x: i == 0
            ? 1
            : i == 1
                ? 0
                : i,
        rods: [
          ChartWidgetBarRodStd(
            friends![i].score.toDouble(),
            color: i == 0
                ? context.config.primaryColor.withOpacity(0.8)
                : i == 1
                    ? context.config.primaryColor.withOpacity(0.6)
                    : context.config.primaryColor.withOpacity(0.4),
            width: 60,
          ),
        ],
      );
    }
    var f = bars.first;
    bars[0] = bars[1];
    bars[1] = f;
    return bars;
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 10),
            if (friends?.first.score != 0)
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    BarChartWidget(
                      maxY: friends?.first.score.toDouble() ?? 0,
                      bottomAxis: ChartWidgetAxis(
                        axisTitles: bars().map((e) => e.title).toList(),
                      ),
                      barGroups: bars(),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 120,
                      child: Icon(
                        Icons.star_rounded,
                        color: context.colorScheme.secondary,
                      ),
                    ),
                    Positioned(
                      left: context.mediaQuery.size.width / 3 - 60,
                      top: 120,
                      child: Icon(
                        Icons.star_half_rounded,
                        color: context.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
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
                          ListTileWidget(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            selectedColor: UserRepository.currentUser!.uid ==
                                    friends![i].friend.uid
                                ? context.config.primaryColor.withOpacity(0.2)
                                : null,
                            title: friends![i].friend.displayName,
                            subtitle: 'Score: ${friends![i].score}',
                            // friends![i].friend.contactMethod.value,
                            // from the changenotifier provider in the bottomnavigationpage
                            onTap: () => UserRepository.currentUser!.uid ==
                                    friends![i].friend.uid
                                ? Provider.of<PageController>(context,
                                        listen: false)
                                    .go(4)
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
}
