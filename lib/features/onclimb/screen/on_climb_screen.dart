import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/onclimb/controller/on_climb_controller.dart';
import 'package:chrismiche/features/onclimb/widgets/floor_and_height_stats.dart' show FloorAndHeightStats;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnClimbScreen extends StatelessWidget {
  OnClimbScreen({super.key});

  final OnClimbController controller = Get.put(OnClimbController());

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
            child: Image.asset(
              ImagePath.liftCharacterBoy,
              height: MediaQuery.of(context).size.height * 0.7,        
              width: MediaQuery.of(context).size.height * 0.7,
            ),
          ),

          
          Positioned(
            top: 65,
            child: FloorAndHeightStats(),
          ),
        ],
      ),
    );
  }
}
