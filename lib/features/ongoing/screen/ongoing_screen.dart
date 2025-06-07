import 'package:chrismiche/features/home/controller/change_character_controller.dart';
import 'package:chrismiche/features/ongoing/controller/ongoing_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OngoingScreen extends StatelessWidget {
  OngoingScreen({super.key});

  final OngoingController controller = Get.put(OngoingController());
  final ChangeCharacterController runningController = Get.put(
    ChangeCharacterController(),
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            // Scrolling image
            SingleChildScrollView(
              controller: controller.scrollController,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              child: Image.asset(
                'assets/images/runBackground.png',
                height: screenHeight,
                fit: BoxFit.fitHeight,
              ),
            ),
            Center(
              child: Image.asset(
                runningController.characterImagePath,
                height: 650,
                width: 650,
              ),
            ),
            // Overlay with distance and date
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Distance: ${controller.totalDistance.value.toStringAsFixed(2)} m",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Date: ${controller.currentDate.value}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
