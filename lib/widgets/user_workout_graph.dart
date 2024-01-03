import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/user_workout_info_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widgets/widgets.dart';

class UserWorkoutGraph extends StatefulWidget {
  final List<WorkoutStatistic> statistics;
  const UserWorkoutGraph({
    required this.statistics,
    super.key,
  });

  @override
  State<UserWorkoutGraph> createState() => _UserWorkoutGraphState();
}

class _UserWorkoutGraphState extends State<UserWorkoutGraph> {
  final List<WorkoutStatistic> filteredStatistics = [];

  final double spaceForDate = 30;

  /// Filter by Month or all
  /// if null, show all
  /// if DateTime, show from this date to end of month
  DateTime? filterDate;

  @override
  void initState() {
    filteredStatistics.addAll(widget.statistics);
    super.initState();
  }

  List<MapEntry<DateTime, List<WorkoutStatistic>>> sortStatisticsByDate(
    List<WorkoutStatistic> stats,
  ) {
    Map<DateTime, List<WorkoutStatistic>> map = {};
    // count number of workouts done in one day
    for (WorkoutStatistic stat in stats) {
      if (map.containsKey(stat.startTime?.dateOnly)) {
        map[stat.startTime!.dateOnly]!.add(stat);
      } else {
        if (stat.startTime != null) {
          map.putIfAbsent(stat.startTime!.dateOnly, () => [stat]);
        }
      }
    }
    return map.entries.toList();
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
    List<MapEntry<DateTime, List<WorkoutStatistic>>> workoutCount =
        sortStatisticsByDate(filteredStatistics);

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.start,
          maxY: findMostWorkoutsOnDate(workoutCount).toDouble(),
          minY: 0,
          barTouchData: BarTouchData(
            touchCallback: (event, response) {
              if (response == null) {
                return;
              }
              if (event is FlLongPressEnd ||
                  event is FlPanEndEvent ||
                  event is FlTapUpEvent) {
                WorkoutStatistic workout =
                    workoutCount[response.spot!.touchedBarGroupIndex]
                        .value[response.spot!.touchedRodDataIndex];
                Navigation.push(
                  widget: UserWorkoutInfoScreen(workout: workout.workout),
                );
              }
            },
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: context.config.cardColor(context.brightness),
              tooltipPadding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              tooltipMargin: 2,
              fitInsideVertically: true,
              fitInsideHorizontally: true,
              tooltipRoundedRadius: context.config.radius,
              tooltipHorizontalOffset: 0,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                WorkoutStatistic workout =
                    workoutCount[group.x.toInt()].value[rodIndex];
                return BarTooltipItem(
                  workout.workout.name,
                  context.textTheme.labelSmall!,
                );
              },
            ),
          ),
          groupsSpace: spaceForDate,
          barGroups: List.generate(workoutCount.length, (dayIndex) {
            List<WorkoutStatistic> workoutsPerDay =
                workoutCount[dayIndex].value;
            return BarChartGroupData(
              x: dayIndex,
              groupVertically: true,
              barRods: List.generate(workoutsPerDay.length, (workoutIndex) {
                WorkoutStatistic workout = workoutsPerDay[workoutIndex];
                return BarChartRodData(
                  fromY: workoutIndex.toDouble(),
                  toY: workoutIndex.toDouble() + 1,
                  color: workout.difficulty.getColor(context),
                  borderRadius: BorderRadius.circular(
                    context.config.radius,
                  ),
                );
              }),
            );
          }),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(
            show: true,
            drawVerticalLine: true,
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                'Anzahl',
                style: context.textTheme.labelMedium,
              ),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => TextWidget(
                  value.toInt().toString(),
                  style: context.textTheme.labelSmall,
                ),
              ),
            ),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(
              axisNameSize: 40,
              axisNameWidget: BarChartWidgetLegend(),
            ),
            bottomTitles: AxisTitles(
              axisNameSize: 20,
              axisNameWidget: bottomAxisName(),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (i, m) => SizedBox(
                  width: spaceForDate,
                  child: FittedBox(
                    child: TextWidget(
                      workoutCount[i.toInt()].key.ddMM,
                      style: context.textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bottomAxisName() => Row(
        children: [
          Text(
            filterDate == null
                ? 'Alle Trainings'
                : DateFormat('MMMM yyyy').format(filterDate!),
            style: context.textTheme.labelMedium,
          ),
          const Spacer(),
          FittedBox(
            child: TextButtonWidget(
              'Filter',
              onPressed: () {
                // Filter by Month or all
                Navigation.pushPopup(
                  widget: ColumnWidget(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          context.config.radius,
                        ),
                        child: SizedBox(
                          height: 200,
                          child: ListView(
                            padding: const EdgeInsets.all(0),
                            children: [
                              for (var month in getMonths(
                                UserRepository.currentUser?.createdAt ??
                                    DateTime.now(),
                                DateTime.now(),
                              )) ...[
                                ListTileWidget(
                                  title: DateFormat('MMMM yyyy').format(month),
                                  onTap: () {
                                    setState(() {
                                      filterDate = month.dateOnly;
                                      filteredStatistics.clear();

                                      var createdAt = UserRepository
                                              .currentUser?.createdAt ??
                                          DateTime.now();
                                      // put every month in [filtered] from [createdAt] up until DateTime.now()
                                      for (var i = createdAt;
                                          i.isBefore(DateTime.now());
                                          i = i.add(const Duration(days: 1))) {
                                        if (filterDate == null) {
                                          filteredStatistics
                                              .addAll(widget.statistics);
                                        }
                                        if (i.month == filterDate!.month &&
                                            i.year == filterDate!.year) {
                                          filteredStatistics.addAll(
                                            widget.statistics.where(
                                              (element) =>
                                                  element.date!.year ==
                                                      filterDate!.year &&
                                                  element.date!.month ==
                                                      filterDate!.month,
                                            ),
                                          );
                                        }
                                      }
                                    });
                                    Navigation.pop();
                                  },
                                ),
                              ],
                              ListTileWidget(
                                title: 'Alle Trainings',
                                onTap: () {
                                  setState(() {
                                    filterDate = null;
                                    filteredStatistics.clear();
                                    filteredStatistics
                                        .addAll(widget.statistics);
                                  });
                                  Navigation.pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );

  // Hilfsfunktion, um eine Liste von DateTime-Objekten zu erstellen
  List<DateTime> getMonths(DateTime start, DateTime end) {
    List<DateTime> months = [];
    DateTime current = DateTime(start.year, start.month);
    while (current.isBefore(end)) {
      months.add(current);
      current = DateTime(current.year, current.month + 1);
    }
    return months;
  }
}

class BarChartWidgetLegend extends StatelessWidget {
  const BarChartWidgetLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Trainings pro Tag',
            style: context.textTheme.labelLarge,
          ),
          const Spacer(),
          for (var diff in WorkoutDifficulty.values) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              decoration: BoxDecoration(
                color: diff.getColor(context),
                borderRadius: BorderRadius.circular(context.config.radius),
              ),
              alignment: Alignment.center,
              child: FittedBox(
                child: TextWidget(
                  diff.str,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
