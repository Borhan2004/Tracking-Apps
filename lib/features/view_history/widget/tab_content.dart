import 'package:chrismiche/features/view_history/controller/history_controller.dart';
import 'package:chrismiche/features/view_history/widget/history_list.dart';
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
                ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: runHistory.length,
                  itemBuilder: (context, index) {
                    final his = runHistory[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: HistoryList(
                        date: his['date'],
                        time: his['time'],
                        walk: his['walk'],
                        floor: his['floor'],
                      ),
                    );
                  },
                )
                : controller.activeTab.value == 'Climb'
                ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: climbHistory.length,
                  itemBuilder: (context, index) {
                    final his = climbHistory[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: HistoryList(
                        date: his['date'],
                        time: his['time'],
                        walk: his['walk'],
                        floor: his['floor'],
                      ),
                    );
                  },
                )
                : controller.activeTab.value == 'Achieve'
                ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: achieveHistory.length,
                  itemBuilder: (context, index) {
                    final his = achieveHistory[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: HistoryList(
                        date: his['date'],
                        time: his['time'],
                        walk: his['walk'],
                        floor: his['floor'],
                      ),
                    );
                  },
                )
                : Container(height: 200, color: Colors.white),
      ),
    );
  }
}
