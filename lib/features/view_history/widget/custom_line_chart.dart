import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatelessWidget {
  final List<FlSpot> data;
  const CustomLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: _buildTitlesData(),
        borderData: _buildBorderData(),
        gridData: _buildGridData(),
        lineBarsData: [_buildLineChartBarData()],
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          minIncluded: false,
          maxIncluded: false,
          getTitlesWidget: (value, meta) {
            return Text('Day ${value.toInt()}');
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          minIncluded: false,
          maxIncluded: false,
        ),
      ),
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: Colors.black, width: 1),
        left: BorderSide(color: Colors.green, width: 1),
      ),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(show: true);
  }

  LineChartBarData _buildLineChartBarData() {
    return LineChartBarData(
      spots: data,
      color: Colors.blue,
      barWidth: 1,
      isCurved: true,
      belowBarData: BarAreaData(show: true, color: Colors.transparent),
    );
  }
}
