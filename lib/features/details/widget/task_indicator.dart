import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/features/onclimb/controller/on_climb_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskIndicator extends StatelessWidget {
  TaskIndicator({super.key});

  final OnClimbController controller = Get.find<OnClimbController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    "Date: ${controller.currentDate.value}",
                    style: getTextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'All Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: List.generate(8, (index) {
          //     List<double> height = [55, 43, 57, 33, 37, 55, 43, 57];
          //     return Container(
          //       margin: EdgeInsets.only(right: 3),
          //       height: height[index],
          //       width: 15,
          //       decoration: BoxDecoration(
          //         color: Colors.teal, // Assign a different color based on index
          //         borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(6),
          //           topRight: Radius.circular(6),
          //         ),
          //       ),
          //     );
          //   }),
          // ),
          Image.asset('assets/images/state.png', height: 70, width: 70),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
