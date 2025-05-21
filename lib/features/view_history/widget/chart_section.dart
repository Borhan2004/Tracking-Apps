import 'package:chrismiche/features/view_history/data/history_data.dart';
import 'package:flutter/material.dart';

class ChartSection extends StatelessWidget {
  final List<double> x1;
  final List<double> y1;
  final List<double> x2;
  final List<double> y2;

  const ChartSection({
    super.key,
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Expanded(child: HistoryData(x: x1, y: y1, chartTitle: 'Chart 1')),
            const SizedBox(width: 8),
            Expanded(child: HistoryData(x: x2, y: y2, chartTitle: 'Chart 2')),
          ],
        ),
      ),
    );
  }
}
