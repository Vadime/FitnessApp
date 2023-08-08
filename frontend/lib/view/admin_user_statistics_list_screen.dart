import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

extension on String {
  DateTime toDateTime() {
    var arr = split('.');
    return DateTime(int.parse(arr[2]), int.parse(arr[1]), int.parse(arr[0]));
  }
}

class UserStatisticsListScreen extends StatelessWidget {
  const UserStatisticsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Statistics'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<dynamic>>(
            future: FirebaseFirestore.instance
                .collectionGroup('workoutStatistics')
                .get()
                .then((value) {
              return (value.docs
                  .map(
                    (e) => e.data()['date'] ?? DateTime.now().formattedDate,
                  )
                  .toList());
            }),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<String> dates = snapshot.data!.cast<String>()
                ..sort(
                  (a, b) => a.toDateTime().compareTo(b.toDateTime()),
                );

              Map<String, int> workoutCount = {};
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

              if (workoutCount.isEmpty) {
                return Center(
                  child: Text(
                    'No workouts found',
                    style: context.textTheme.labelSmall,
                  ),
                );
              }

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  // one over the max value of the workout count
                  maxY: findMax(workoutCount).toDouble() + 1,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey.shade900,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.round()} workouts',
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
                      //axisNameWidget: const Text('Dates'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (index, meta) {
                          return Text(
                            (workoutCount.keys
                                    .elementAt(index.toInt())
                                    .split('.')
                                  ..removeLast())
                                .join('.')
                                .toString(),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(),
                    leftTitles: AxisTitles(
                      axisNameWidget:
                          const Text('Anzahl der Workouts aller Nutzer'),
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
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
