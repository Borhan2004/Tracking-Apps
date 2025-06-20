import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatelessWidget {
  final List<FlSpot> data;

  const CustomLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              minIncluded: false,
              maxIncluded: false,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              minIncluded: false,
              maxIncluded: false,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            color: Colors.blueAccent,
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.8),
                Colors.blueAccent.withOpacity(0.4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.teal.withOpacity(0.3),
                  Colors.tealAccent.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Colors.teal,
                );
              },
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBorder: BorderSide(
              color: Colors.blueAccent.withOpacity(0.9),
              width: 1,
            ),
            tooltipPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            tooltipMargin: 10,
            getTooltipColor: (LineBarSpot spot) {
              return Colors.blueAccent.withOpacity(0.9);
            },
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '(${spot.x.toStringAsFixed(1)}, ${spot.y.toStringAsFixed(1)})',
                  TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList();
            },
          ),
        ),
        minX: data.isNotEmpty ? data.first.x - 0.5 : 0,
        maxX: data.isNotEmpty ? data.last.x + 0.5 : 1,
        minY:
            data.isNotEmpty
                ? data.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 5
                : 0,
        maxY:
            data.isNotEmpty
                ? data.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5
                : 10,
      ),
    );
  }
}
