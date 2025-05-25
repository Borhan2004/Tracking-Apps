import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonController extends GetxController with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;

  final double imageWidth = 1000;
  final double viewportWidth = 400;
  double maxScrollExtent = 0;
  final RxBool isRunning = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animationController.addListener(() {
      if (scrollController.hasClients) {
        final value = animationController.value * maxScrollExtent;
        scrollController.jumpTo(value);
      }
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
        animationController.forward();
      }
    });
  }

  void startAnimation() {
    maxScrollExtent = imageWidth - viewportWidth;
    if (maxScrollExtent <= 0) return;
    animationController.forward();
    isRunning.value = true; 
  }

  void stopAnimation() {
    animationController.stop();
    isRunning.value = false; 
  }

  @override
  void onClose() {
    scrollController.dispose();
    animationController.dispose();
    super.onClose();
  }
}