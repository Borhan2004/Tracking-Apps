import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/features/ongoing/controller/ongoing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Counters extends StatelessWidget {
  Counters({super.key});

  final OngoingController controller = Get.find<OngoingController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.currentDate.value,
              textAlign: TextAlign.center,
              style: getTextStyle(fontSize: 16),
            ),

            Text(
              '${(controller.totalDistance.value / 0.762).toInt()} Steps',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${controller.totalDistance.value.toStringAsFixed(2)} meters',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
