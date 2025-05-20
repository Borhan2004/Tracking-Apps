import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/features/marathon_climbed/controller/marathon_climbed_controller.dart' show MarathonClimbedController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonClimbedStats extends StatelessWidget {
  MarathonClimbedStats({super.key});

  final MarathonClimbedController controller = Get.find<MarathonClimbedController>();

  @override
  Widget build(BuildContext context) {
    double headSize = 12;
    double bodySize = 10;
     
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Date:",
                style: getTextStyle(
                  color: Colors.white,
                  fontSize: headSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(() => Text(
                    " ${controller.currentDate.value}",
                    style: getTextStyle(
                      color: Colors.white,
                      fontSize: bodySize,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              Spacer(),
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
                      style: getTextStyle(
                        color: Colors.white,
                        fontSize: bodySize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
            ],
          ),
          SizedBox(
            height: 10,
          ), 
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                ()=> Text(
                  "${controller.totalClimbed.value.toStringAsFixed(2)} m",
                  style: getTextStyle(
                    color: Colors.white,
                    fontSize: bodySize,
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
