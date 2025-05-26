import 'package:chrismiche/core/utils/constants/image_path.dart' show ImagePath;
import 'package:chrismiche/features/home/controller/change_character_controller.dart';
import 'package:chrismiche/features/marathon_climbed/controller/marathon_climbed_controller.dart';
import 'package:chrismiche/features/onclimb/widgets/floor_and_height_stats.dart'
    show FloorAndHeightStats;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonClimbedScreen extends StatelessWidget {
  MarathonClimbedScreen({super.key});

  final MarathonClimbedController controller = Get.put(
    MarathonClimbedController(),
  );

  final ChangeCharacterController elevatorController = Get.put(
    ChangeCharacterController(),
  );

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
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

          Positioned(
            top: MediaQuery.of(context).size.height * 0.13,
            child: Obx(
              () => Image.asset(
                elevatorController.elevatorCharacterImagePath,
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.height * 0.7,
              ),
            ),
          ),
          Positioned(top: 65, child: FloorAndHeightStats()),
          Positioned(
            bottom: 40,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!controller.isTracking.value) ...[
                    ElevatedButton(
                      onPressed: () => controller.startTracking(screenHeight),
                      child: const Text('Start'),
                    ),
                    const SizedBox(width: 20),
                  ],
                  SizedBox(
                    width: controller.isTracking.value ? 250 : null,
                    height: controller.isTracking.value ? 60 : null,
                    child: ElevatedButton(
                      onPressed: controller.stopTracking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            controller.isTracking.value
                                ? const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                )
                                : null,
                      ),
                      child: Text(
                        'Stop',
                        style: TextStyle(
                          fontSize: controller.isTracking.value ? 18 : 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
