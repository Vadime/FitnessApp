import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ProfileUserStatsGraph extends StatelessWidget {
  final Future<List<DateTime>> loader;
  final String interpretation;
  const ProfileUserStatsGraph({
    required this.loader,
    this.interpretation = 'Number of workouts done per day',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: FutureBuilder<List<DateTime>>(
        future: loader,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingWidget();
          }
          var dates = snapshot.data!;

          if (dates.isEmpty) {
            return const FailWidget('No workouts done yet');
          }

          Map<DateTime, int> workoutCount = {};
          // count number of workouts done in one day
          for (var date in dates) {
            if (workoutCount.containsKey(date)) {
              workoutCount[date] = workoutCount[date]! + 1;
            } else {
              workoutCount.putIfAbsent(date, () => 1);
            }
          }

          findMax(it) {
            var max = 0;
            for (var i in it.values) {
              if (i > max) {
                max = i;
              }
            }
            return max;
          }

          return BarChartWidget(
            maxY: findMax(workoutCount).toDouble() + 0.6,
            bars: workoutCount.map(
              (key, value) =>
                  MapEntry('${key.day}.${key.month}', value.toDouble()),
            ),
            bottomTitle: 'Dates',
            leftTitle: 'Workouts',
            interpretation: interpretation,
          );
        },
      ),
    );
  }
}
