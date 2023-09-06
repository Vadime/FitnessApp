import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/user_friend_list_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class FriendStatsGraph extends StatelessWidget {
  final List<FriendUI> friends;

  const FriendStatsGraph(this.friends, {super.key});

  @override
  Widget build(BuildContext context) {
    List<FriendUI> friendsCopy = List.from(friends);
    if (friendsCopy.length < 3) {
      friendsCopy.addAll([
        FriendUI(friend: Friend.empty(), stats: []),
        FriendUI(friend: Friend.empty(), stats: []),
        FriendUI(friend: Friend.empty(), stats: []),
      ]);
    }

    List<Icon> barIcons = [
      const Icon(Icons.star_rounded),
      const Icon(Icons.star_half_rounded),
      const Icon(Icons.star_border_rounded),
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        maxY: friendsCopy.first.score.toDouble(),
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
                    friendsCopy[i.toInt()].friend.displayName,
                    align: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
        barGroups: [
          for (int i = 0; i < 3; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: friendsCopy[i].score.toDouble(),
                  color: context.config.primaryColor,
                  width: context.mediaQuery.size.width / 10,
                  borderRadius: BorderRadius.circular(context.config.radius),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
