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
    var width = MediaQuery.of(context).size.width * 0.40;

    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFD4D4D4)
                    ), 
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      '⏱️ Time:\n${controller.currentDate.value}',
                      textAlign: TextAlign.center,
                      style: getTextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Container(
                  width: width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFD4D4D4)
                    ), 
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      '📏 Distance:\n${controller.totalDistance.value.toStringAsFixed(2)} meters',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        
                        fontSize: 16,),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Container(
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //       color: Color(0xFFD4D4D4)
            //     ), 
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 8,
            //       vertical: 10,
            //     ),
            //     child: Text(
            //       '🏢 Floors Climbed: ${controller.totalClimbed.value.toStringAsFixed(2)} meters',
            //       style:  getTextStyle(fontSize: 16),
            //     ),
            //   ),
            // ),
             SizedBox(height: 40),
            if (!controller.isTracking.value)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.startTracking,
                  child: const Text('Start'),
                ),
              )
            else if (controller.isPaused.value)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: controller.resumeTracking,
                    child: const Text('Resume'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: controller.stopTracking,
                    child: const Text('Stop'),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: controller.pauseTracking,
                    child: const Text('Pause'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: controller.stopTracking,
                    child: const Text('Stop'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
