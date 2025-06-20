import 'package:chrismiche/features/view_history/controller/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabButtons extends StatelessWidget {
  final HistoryController controller;

  const TabButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTabButton(context, 'Run', controller),
            _buildTabButton(context, 'Climb', controller),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    String title,
    HistoryController controller,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color:
                controller.activeTab.value == title
                    ? Colors.teal
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  controller.activeTab.value == title
                      ? Colors.teal
                      : Colors.teal.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  controller.activeTab.value == title
                      ? Colors.white
                      : Colors.teal,
            ),
          ),
        ),
      ),
    );
  }
}
