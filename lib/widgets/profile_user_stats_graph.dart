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

  List<MapEntry<DateTime, List<WorkoutStatistic>>> sortStatisticsByDate(
    List<WorkoutStatistic> stats,
  ) {
    Map<DateTime, List<WorkoutStatistic>> map = {};
    // count number of workouts done in one day
    for (WorkoutStatistic stat in stats) {
      if (map.containsKey(stat.startTime)) {
        map[stat.startTime]!.add(stat);
      } else {
        if (stat.startTime != null) {
          map.putIfAbsent(stat.startTime!, () => [stat]);
        }
      }
    }
    return map.entries.toList().sublist(
          max(map.length - 7, 0),
          map.length,
        );
  }

  int findMostWorkoutsOnDate(
    List<MapEntry<DateTime, List<WorkoutStatistic>>> map,
  ) {
    var max = 0;
    for (var stat in map) {
      if (stat.value.length > max) {
        max = stat.value.length;
      }
    }
    return max;
  }

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

          List<MapEntry<DateTime, List<WorkoutStatistic>>> workoutCount =
              sortStatisticsByDate(stats);

          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              maxY: findMostWorkoutsOnDate(workoutCount).toDouble(),
              minY: 0,
              barTouchData: BarTouchData(enabled: false),
              barGroups: List.generate(workoutCount.length, (dayIndex) {
                List<WorkoutStatistic> workoutsPerDay =
                    workoutCount[dayIndex].value;
                return BarChartGroupData(
                  x: dayIndex,
                  groupVertically: true,
                  barRods: List.generate(workoutsPerDay.length, (workoutIndex) {
                    WorkoutStatistic workout = workoutsPerDay[workoutIndex];
                    return BarChartRodData(
                      fromY: workoutIndex.toDouble() + 0.05,
                      toY: workoutIndex.toDouble() + 0.95,
                      color: workout.difficulty.getColor(context),
                      borderRadius: BorderRadius.circular(
                        context.config.radius,
                      ),
                    );
                  }),
                );
              }),
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
                        workoutCount[i.toInt()].key.ddMM,
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
