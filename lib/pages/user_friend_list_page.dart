import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/widgets/user_profile_friends_widget.dart';
import 'package:fl_chart/fl_chart.dart';
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

  List<BarChartGroupData> bars() {
    List<BarChartGroupData> bars = [];

    for (int i = 0; i < 3; i++) {
      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: friends![i].score.toDouble(),
              color: barColors(context)[i],
              width: context.mediaQuery.size.width / 10,
              borderRadius: BorderRadius.circular(context.config.radius),
            ),
          ],
        ),
      );
    }
    return bars;
  }

  List<Icon> barIcons = [
    const Icon(Icons.star_rounded),
    const Icon(Icons.star_half_rounded),
    const Icon(Icons.star_border_rounded),
  ];

  List<Color> barColors(BuildContext context) => [
        context.config.primaryColor.withOpacity(0.9),
        context.config.primaryColor.withOpacity(0.7),
        context.config.primaryColor.withOpacity(0.5),
      ];

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
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceEvenly,
                    maxY: friends?.first.score.toDouble() ?? 0,
                    minY: 0,
                    barTouchData: BarTouchData(enabled: false),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (i, m) => barIcons[i.toInt()],
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (i, m) => Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: context.mediaQuery.size.width / 3 -
                                  context.config.paddingH,
                              child: TextWidget(
                                friends![i.toInt()].friend.displayName,
                                align: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    barGroups: bars(),
                  ),
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
                                ? context.config.primaryColor.withOpacity(0.05)
                                : null,
                            title: friends![i].friend.displayName +
                                (UserRepository.currentUser!.uid ==
                                        friends![i].friend.uid
                                    ? ' - You'
                                    : ''),
                            subtitle: 'Score: ${friends![i].score}',
                            // friends![i].friend.contactMethod.value,
                            // from the changenotifier provider in the bottomnavigationpage
                            onTap: () => UserRepository.currentUser!.uid ==
                                    friends![i].friend.uid
                                ? BlocProvider.of<
                                        BottomNavigationPageController>(context)
                                    .controller
                                    .go(4)
                                : Navigation.pushPopup(
                                    widget: UserProfileFriendsGraphPopup(
                                      friend: friends![i].friend,
                                      loader: (() async => friends![i].stats)(),
                                    ),
                                  ),
                            leading: TextWidget(
                              (i + 1).toString(),
                              color: context.config.neutralColor,
                              margin: const EdgeInsets.only(right: 20),
                            ),
                            trailing: ImageWidget(
                              NetworkImage(friends![i].friend.imageURL ?? ''),
                              width: 50,
                              height: 50,
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
