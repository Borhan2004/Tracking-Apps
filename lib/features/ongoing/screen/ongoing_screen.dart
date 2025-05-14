import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/ongoing/controller/ongoing_controller.dart';
import 'package:chrismiche/features/ongoing/widgets/counters.dart'
    show Counters;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OngoingScreen extends StatelessWidget {
  OngoingScreen({super.key});

  final OngoingController controller = Get.put(OngoingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
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
                          height: MediaQuery.of(context).size.height * 0.4,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Static center image
              Positioned(
                top: MediaQuery.of(context).size.height * 0.25,
                child: Image.asset(ImagePath.boyRun, height: 80, width: 80),
              ),
            ],
          ),

          SizedBox(height: 40),

          Counters(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
