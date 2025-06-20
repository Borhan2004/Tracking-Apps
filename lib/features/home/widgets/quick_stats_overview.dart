import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/features/details/controller/details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickStatsOverview extends StatelessWidget {
  QuickStatsOverview({super.key});

  final controller = Get.put(DetailsController());


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    '📏 Distance Today',
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Obx(
                    () => Text(
                      "${controller.ongoingDistance.value.toStringAsFixed(2)} meters",
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "🏢 Floors Climbed",
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Obx(
                    () => Text(
                      "${controller.climbingDistance.value.toStringAsFixed(2)} meters",
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
