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
                      '⏱️ ${controller.currentDate.value}',
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
                      '📏 ${controller.totalDistance.value.toStringAsFixed(2)} meters',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        
                        fontSize: 16,),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
