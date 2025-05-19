import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/onclimb/controller/on_climb_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnClimbScreen extends StatelessWidget {
  OnClimbScreen({super.key});

  final OnClimbController controller = Get.put(OnClimbController());

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Vertical scrolling image background
          SizedBox(
            height: screenHeight,
            child: AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, child) {
                return SingleChildScrollView(
                  controller: controller.scrollController,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Image.asset(
                        ImagePath.upCover,
                        height: controller.imageHeight,
                        width: screenWidth,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Static character image
          Positioned(
            child: Image.asset(
              ImagePath.liftCharacterBoy,
              height: 200,
              width: 200,
            ),
          ),

          // Start & Stop buttons
          Positioned(
            bottom: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => controller.startAnimation(screenHeight),
                  child: const Text('Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: controller.stopAnimation,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Stop'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
