import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class LineChartPoint extends FlSpot {
  LineChartPoint(int x, int y) : super(x.toDouble(), y.toDouble());
}

class LineChartGraph extends LineChartBarData {
  LineChartGraph(
    List<LineChartPoint> points, {
    Color? color,
  }) : super(
          isCurved: true,
          preventCurveOverShooting: true,
          curveSmoothness: 0.1,
          color: color,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          spots: points.map((e) => FlSpot(e.x, e.y)).toList(),
        );
}

class LineChartWidget extends StatelessWidget {
  final List<LineChartGraph> graphs;
  final String? bottomTitle;
  final String? leftTitle;

  const LineChartWidget({
    this.graphs = const [],
    this.bottomTitle,
    this.leftTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        lineBarsData: graphs,
        lineTouchData: const LineTouchData(handleBuiltInTouches: false),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
              drawBelowEverything: false,
              axisNameWidget:
                  bottomTitle == null ? null : TextWidget(bottomTitle!),
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (d, w) => TextWidget(
                        (d.round() != d) ? '' : d.toInt().toString(),
                      ))),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
              axisNameWidget: leftTitle == null ? null : TextWidget(leftTitle!),
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (d, w) => TextWidget(
                      (d.round() != d) ? '' : d.toInt().toString()))),
        ),
        borderData: FlBorderData(show: false)));
  }
}
