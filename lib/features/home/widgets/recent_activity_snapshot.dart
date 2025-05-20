import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/features/home/controller/home_controller.dart';
import 'package:chrismiche/features/view_history/screen/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentActivitySnapshot extends StatelessWidget {
  RecentActivitySnapshot({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Obx(
          () => Text(
            "Last Run: ${controller.lastRun.value}",
            style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        trailing: TextButton(
          onPressed: () {
            controller.viewHistory;
            Get.to(HistoryScreen());
          },
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(
            "View History 📊",
            style: getTextStyle(fontSize: 12, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
