import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnClimbController extends GetxController with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;

  final double imageHeight = 2000; // taller than screen for scroll effect
  double maxScrollExtent = 0;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    animationController.addListener(() {
      if (scrollController.hasClients) {
        final value = (1 - animationController.value) * maxScrollExtent;
        scrollController.jumpTo(value);
      }
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
        animationController.forward(); // loop
      }
    });
  }

  void startAnimation(double viewportHeight) {
    maxScrollExtent = imageHeight - viewportHeight;
    if (maxScrollExtent <= 0) return;

    scrollController.jumpTo(maxScrollExtent); // start from bottom
    animationController.forward(); // animate upward
  }

  void stopAnimation() {
    animationController.stop();
  }

  @override
  void onClose() {
    scrollController.dispose();
    animationController.dispose();
    super.onClose();
  }
}
