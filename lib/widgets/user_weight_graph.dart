import 'dart:math';

import 'package:fitnessapp/models/models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserWeightGraph extends StatefulWidget {
  final List<Health> healthList;

  const UserWeightGraph({
    required this.healthList,
    super.key,
  });

  @override
  State<UserWeightGraph> createState() => _UserWeightGraphState();
}

class _UserWeightGraphState extends State<UserWeightGraph> {
  final double spaceForDate = 30;

  @override
  Widget build(BuildContext context) {
    var weightData = widget.healthList.map((e) => e.weight).toList();
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < weightData.length; i++)
                  FlSpot(i.toDouble(), weightData[i].toDouble()),
              ],
              isCurved: true,
              color: Colors.orange,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(
                show: true,
              ),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white,
              tooltipPadding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              //fitInsideVertically: true,
              fitInsideHorizontally: true,
              tooltipRoundedRadius: context.config.radius,
              tooltipHorizontalOffset: 0,
              tooltipMargin: 20,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  return LineTooltipItem(
                    '${barSpot.y} kg',
                    context.textTheme.labelSmall!,
                  );
                }).toList();
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                'Gewicht (kg)',
                style: context.textTheme.labelMedium,
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) =>
                    // distinguish between whole and decimal numbers
                    value % 1 == 0
                        ? TextWidget(
                            // get decimal from value

                            value.toStringAsFixed(0),
                            style: context.textTheme.labelSmall,
                          )
                        : TextWidget(
                            value.toStringAsFixed(1),
                            style: context.textTheme.labelSmall,
                          ),
              ),
            ),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(
              axisNameSize: 40,
              axisNameWidget: LineChartWidgetLegend(),
            ),
            bottomTitles: AxisTitles(
              axisNameSize: 20,
              axisNameWidget: bottomAxisName(),
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (i, m) => SizedBox(
                  width: spaceForDate,
                  child: FittedBox(
                    child: TextWidget(
                      widget.healthList[i.toInt()].date.ddMM,
                      style: context.textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: true),
          minX: 0,
          maxX: weightData.length.toDouble() - 1,
          minY: weightData.reduce(min).toDouble(),
          maxY: weightData.reduce(max).toDouble(),
        ),
      ),
    );
  }

  bottomAxisName() => Row(
        children: [
          Text(
            'Datum',
            style: context.textTheme.labelMedium,
          ),
          const Spacer(),
        ],
      );
}

class LineChartWidgetLegend extends StatelessWidget {
  const LineChartWidgetLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Gewichtsverlauf',
            style: context.textTheme.labelLarge,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
