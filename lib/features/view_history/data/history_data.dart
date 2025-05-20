import 'package:chrismiche/features/view_history/widget/custom_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryData extends StatelessWidget {
  final List<double> x;
  final List<double> y;

  const HistoryData({super.key, required this.x, required this.y});

  @override
  Widget build(BuildContext context) {
    if (x.length != y.length) {
      throw ArgumentError('x and y lists must have the same length');
    }
    List<FlSpot> spots = List.generate(x.length, (index) {
      return FlSpot(x[index], y[index]);
    });

    return SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width / 2.3,
      child: CustomLineChart(data: spots),
    );
  }
}
