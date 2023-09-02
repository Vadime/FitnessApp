import 'package:fitnessapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ProfileUserStatsGraph extends StatelessWidget {
  final Future<List<WorkoutStatistic>> loader;
  final String interpretation;
  const ProfileUserStatsGraph({
    required this.loader,
    this.interpretation = 'Trainings per Day',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
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

          List<ChartWidgetBarGroup> barGroups = workoutCount.entries
              .toList()
              .asMap()
              .entries
              .map(
                (e) => ChartWidgetBarGroup(
                  title: e.value.key.strNotYear,
                  x: e.key,
                  rods: e.value.value
                      .asMap()
                      .entries
                      .map(
                        (e) => ChartWidgetBarRod(
                          e.key.toDouble(),
                          color: e.value.difficulty.getColor(context),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList();
          return BarChartWidget(
            maxY: findMax(workoutCount).toDouble(),
            barGroups: barGroups,
            topAxis: const ChartWidgetAxis(
              axisNameSpace: 40,
              axisName: BarChartWidgetLegend(),
            ),
            bottomAxis: ChartWidgetAxis(
              axisName: Text(interpretation),
              axisNameSpace: 40,
              axisTitles: barGroups.map((e) => e.title).toList(),
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
