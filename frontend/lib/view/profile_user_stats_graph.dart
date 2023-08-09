import 'package:fitness_app/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
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
            return const MyLoadingWidget();
          }
          var dates = snapshot.data!;
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

          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              // one over the max value of the workout count
              maxY: findMax(workoutCount).toDouble() + 0.6,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: context.theme.primaryColor,
                  tooltipMargin: 10,
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  tooltipRoundedRadius: 10,
                  tooltipPadding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.round()}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  axisNameWidget: const Text('Dates'),
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (index, meta) {
                      var dateToDisplay =
                          workoutCount.keys.elementAt(index.toInt());

                      return Text(
                        '${dateToDisplay.day}.${dateToDisplay.month}',
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  axisNameWidget: Text(interpretation),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: const Text('Workouts'),
                  sideTitles: SideTitles(
                    showTitles: false,
                    interval: 1,
                    getTitlesWidget: (index, meta) {
                      return Text(index.toInt().toString());
                    },
                  ),
                ),
                rightTitles: const AxisTitles(),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              gridData: const FlGridData(
                show: false,
              ),
              barGroups: [
                for (int i = 0; i < workoutCount.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        fromY: 0.1,
                        toY: workoutCount.values.toList()[i].toDouble(),
                        color: context.theme.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
