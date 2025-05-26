import 'package:chrismiche/features/marathon/controller/marathon_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonCounters extends StatelessWidget {
  MarathonCounters({super.key});

  final MarathonController controller = Get.find<MarathonController>();

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
              '⏱️ ${controller.currentDate.value}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '${(controller.totalDistance.value / 0.762).toStringAsFixed(2)} Steps',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
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
