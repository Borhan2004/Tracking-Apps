import 'package:chrismiche/features/view_history/widget/custom_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryData extends StatelessWidget {
  final List<double> x;
  final List<double> y;
  final String chartTitle;

  const HistoryData({
    super.key,
    required this.x,
    required this.y,
    required this.chartTitle,
  });

  @override
  Widget build(BuildContext context) {
    if (x.length != y.length) {
      return Center(
        child: Text(
          'Error: Data mismatch',
          style: TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    if (x.isEmpty || y.isEmpty) {
      return Center(
        child: Text(
          'No Data Available',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    List<FlSpot> spots = List.generate(x.length, (index) {
      return FlSpot(x[index], y[index]);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            chartTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          width: MediaQuery.of(context).size.width / 2.5,
          child: CustomLineChart(data: spots),
        ),
      ],
    );
  }
}
