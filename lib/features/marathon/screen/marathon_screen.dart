import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/home/controller/change_character_controller.dart';
import 'package:chrismiche/features/marathon/controller/marathon_controller.dart';
import 'package:chrismiche/features/marathon/widgets/marathon_counters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonScreen extends StatelessWidget {
  MarathonScreen({super.key});

  final MarathonController controller = Get.put(MarathonController());
  final ChangeCharacterController runningController = Get.put(
    ChangeCharacterController(),
  );

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
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
                      height: screenSize.height,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            child: Obx(
              () => Image.asset(
                runningController.characterImagePath,
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.height * 0.55,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!controller.isRunning.value)
                    ElevatedButton(
                      onPressed: () {
                        controller.startAnimation();
                      },
                      child: const Text('Start'),
                    ),
                  if (!controller.isRunning.value) const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.stopAnimation();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          controller.isRunning.value
                              ? const Size(250, 60)
                              : const Size(80, 40),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Stop'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 65,
            left: 0,
            right: 0,
            child: Column(
              children: [MarathonCounters(), const SizedBox(height: 40)],
            ),
          ),
        ],
      ),
    );
  }
}
