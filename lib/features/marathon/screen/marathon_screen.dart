import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/marathon/controller/marathon_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonScreen extends StatelessWidget {
   MarathonScreen({super.key});

  final MarathonController controller = Get.put(MarathonController()); 

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

          // Static center image
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            child: Image.asset(
              ImagePath.boyRun,
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.height * 0.55,
            ),
          ),

          

          // Buttons
          Positioned(
            bottom: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controller.startAnimation,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: controller.stopAnimation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child:  Text('Stop'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}