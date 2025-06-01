import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/features/marathon_climbed/controller/marathon_climbed_controller.dart'
    show MarathonClimbedController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonClimbedStats extends StatelessWidget {
  MarathonClimbedStats({super.key});

  final MarathonClimbedController controller =
      Get.find<MarathonClimbedController>();

  @override
  Widget build(BuildContext context) {
    double headSize = 12;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => Text(
              " ${controller.currentDate.value}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Floor Climbed: ",
                style: getTextStyle(
                  color: Colors.white,
                  fontSize: headSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(
                () => Text(
                  "${controller.floorCount.value.toString()} floors",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Height Climbed: ",
                style: getTextStyle(
                  color: Colors.white,
                  fontSize: headSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(
                () => Text(
                  "${controller.totalClimbed.value.toStringAsFixed(2)} m",
                  style: getTextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Time Elapsed: ",
                style: getTextStyle(
                  color: Colors.white,
                  fontSize: headSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(
                () => Text(
                  controller.elapsedTime.value,
                  style: getTextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
