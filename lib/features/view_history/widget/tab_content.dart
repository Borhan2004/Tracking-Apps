import 'package:chrismiche/features/view_history/controller/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabContent extends StatelessWidget {
  final HistoryController controller;
  final List<Map<String, dynamic>> runHistory;
  final List<Map<String, dynamic>> climbHistory;
  final List<Map<String, dynamic>> achieveHistory;

  const TabContent({
    super.key,
    required this.controller,
    required this.runHistory,
    required this.climbHistory,
    required this.achieveHistory,
  });

  double _calculateTotalDistance(List<Map<String, dynamic>> history) {
    double totalMeters = 0;
    for (var item in history) {
      String walk = item['walk'];
      if (walk.contains('KM')) {
        double km = double.parse(walk.replaceAll(' KM', ''));
        totalMeters += km * 1000;
      } else if (walk.contains('Meter')) {
        double meters = double.parse(walk.replaceAll(' Meter', ''));
        totalMeters += meters;
      }
    }
    return totalMeters;
  }

  Widget _buildTabContent(
    BuildContext context,
    List<Map<String, dynamic>> history,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
              Spacer(),
              Text(
                'Achievements',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
              Spacer(),
              Text(
                'Average',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...history.map(
          (his) => Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    his['date'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      'Time: ${his['time']}, Walk: ${his['walk']}, Floors: ${his['floor']}',
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    _calculateTotalDistance([his]).toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Total Aggregate Row
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
              const Text(''),
              Text(
                _calculateTotalDistance(history).toStringAsFixed(0),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Obx(
        () =>
            controller.activeTab.value == 'Run'
                ? _buildTabContent(context, runHistory)
                : controller.activeTab.value == 'Climb'
                ? _buildTabContent(context, climbHistory)
                : controller.activeTab.value == 'Achieve'
                ? _buildTabContent(context, achieveHistory)
                : Container(height: 200, color: Colors.white),
      ),
    );
  }
}
