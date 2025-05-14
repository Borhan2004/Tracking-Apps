import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/ongoing/controller/ongoing_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OngoingScreen extends StatelessWidget {
  OngoingScreen({super.key});

  final OngoingController controller = Get.put(OngoingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
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
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Static center image
              Positioned(
                top: 110,
                child: Image.asset(ImagePath.boyRun, height: 50, width: 50),
              ),
            ],
          ),

          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.startAnimation,
                child: const Text('Start'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: controller.stopAnimation,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Stop'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
