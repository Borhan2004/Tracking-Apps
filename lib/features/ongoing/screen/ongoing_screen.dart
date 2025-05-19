import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/ongoing/controller/ongoing_controller.dart';
import 'package:chrismiche/features/ongoing/widgets/counters.dart'
    show Counters;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OngoingScreen extends StatelessWidget {
  OngoingScreen({super.key});

  final OngoingController controller = Get.put(OngoingController());

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background that covers full height and width
          AnimatedBuilder(
            animation: controller.animationController,
            builder: (context, child) {
              return SingleChildScrollView(
                controller: controller.scrollController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  children: [
                    Image.asset(
                      ImagePath.runBackground,
                      width: controller.imageWidth,
                      height: screenSize.height,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              );
            },
          ),

          // Center running boy image
          Positioned(
            top: screenSize.height * 0.15,
            left: 10,
            right: 0,
            child: Center(
              child: Image.asset(ImagePath.boyRun, height: screenSize.height * 0.8, width: screenSize.width * 0.8),
            ),
          ),

          // Positioned counters and spacing below
          Positioned(
            top: 65,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Counters(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
