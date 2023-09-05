import 'dart:math';

import 'package:fitnessapp/models/models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ProfileUserStatsGraph extends StatelessWidget {
  final Future<List<WorkoutStatistic>> loader;
  const ProfileUserStatsGraph({
    required this.loader,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: FutureBuilder<List<WorkoutStatistic>>(
        future: loader,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingWidget();
          }
          var stats = snapshot.data!;

          if (stats.isEmpty) {
            return const FailWidget('No workouts done yet');
          }

          Map<DateTime, List<WorkoutStatistic>> workoutCount = {};
          // count number of workouts done in one day
          for (WorkoutStatistic stat in stats) {
            if (workoutCount.containsKey(stat.dateTime)) {
              workoutCount[stat.dateTime]!.add(stat);
            } else {
              workoutCount.putIfAbsent(stat.dateTime, () => [stat]);
            }
          }

          findMax(Map<DateTime, List<WorkoutStatistic>> map) {
            var max = 0;
            for (var stat in map.values) {
              if (stat.length > max) {
                max = stat.length;
              }
            }
            return max;
          }

          List<BarChartGroupData> barGroups = workoutCount.entries
              .toList()
              .sublist(max(workoutCount.length - 7, 0), workoutCount.length)
              .asMap()
              .entries
              .map(
                (e) => BarChartGroupData(
                  x: e.key,
                  groupVertically: true,
                  barRods: e.value.value
                      .asMap()
                      .entries
                      .map(
                        (e) => BarChartRodData(
                          fromY: e.key.toDouble() + 0.05,
                          toY: e.key.toDouble() + 0.95,
                          color: e.value.difficulty.getColor(context),
                          borderRadius:
                              BorderRadius.circular(context.config.radius),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList();
          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              maxY: findMax(workoutCount).toDouble(),
              minY: 0,
              barTouchData: BarTouchData(enabled: false),
              barGroups: barGroups,
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(
                  axisNameSize: 40,
                  axisNameWidget: BarChartWidgetLegend(),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (i, m) => Align(
                      alignment: Alignment.bottomCenter,
                      child: TextWidget(
                        workoutCount.entries
                            .toList()
                            .sublist(
                              max(workoutCount.length - 7, 0),
                              workoutCount.length,
                            )
                            .asMap()
                            .entries
                            .toList()[i.toInt()]
                            .value
                            .key
                            .strNotYear,
                        align: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BarChartWidgetLegend extends StatelessWidget {
  const BarChartWidgetLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var diff in WorkoutDifficulty.values) ...[
            const SizedBox(width: 10),
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: diff.getColor(context),
                borderRadius: BorderRadius.circular(context.config.radius),
              ),
            ),
            const SizedBox(width: 10),
            TextWidget(diff.str),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}
