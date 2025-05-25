import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonController extends GetxController with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;
  late AudioPlayer audioPlayer;

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
    audioPlayer = AudioPlayer();
    audioPlayer.setSource(AssetSource('music/Running.wav'));

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

  void startAnimation() async {
    maxScrollExtent = imageWidth - viewportWidth;
    if (maxScrollExtent <= 0) return;
    animationController.forward();
    isRunning.value = true;
    await audioPlayer.setSource(AssetSource('music/Running.wav')); 
    await audioPlayer.resume(); 
  }

  void stopAnimation() async {
    animationController.stop();
    isRunning.value = false;
    await audioPlayer.stop(); 
  }

  @override
  void onClose() {
    scrollController.dispose();
    animationController.dispose();
    audioPlayer.dispose();
    super.onClose();
  }
}