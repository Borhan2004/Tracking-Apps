import 'package:chrismiche/core/common/styles/global_text_style.dart' show getTextStyle;
import 'package:chrismiche/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickStatsOverview extends StatelessWidget {
   QuickStatsOverview({super.key});

  final HomeController controller = Get.find<HomeController>(); 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          "📏 Distance Today\n${controller.distanceToday.value.toStringAsFixed(2)} meters",
                          textAlign: TextAlign.center,
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          "🏢 Floors Climbed\n${controller.floorsClimbed.value.toStringAsFixed(2)} meters",
                          textAlign: TextAlign.center,
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
  }
}