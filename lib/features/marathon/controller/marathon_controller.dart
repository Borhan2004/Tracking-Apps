
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class MarathonController extends GetxController with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;
  late AudioPlayer audioPlayer;

  final double imageWidth = 1000;
  final double viewportWidth = 400;
  double maxScrollExtent = 0;
  final RxBool isRunning = false.obs;

  RxDouble totalDistance = 0.0.obs;
  Timer? _distanceTimer;

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

    updateCurrentDate();

    // Periodically check for date change
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (isRunning.value) {
        _checkDateChangeAndReset();
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

    // Start updating distance
    _startDistanceUpdate();
  }

  void stopAnimation() async {
    animationController.stop();
    isRunning.value = false;
    await audioPlayer.stop(); 
    _stopDistanceUpdate();
  }

  @override
  void onClose() {
    scrollController.dispose();
    animationController.dispose();
    audioPlayer.dispose();
    _stopDistanceUpdate();
    super.onClose();
  }

  RxString currentDate = ''.obs;

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat("d, MMMM, y").format(now);
  }

  // Function to show date and running distance in a dialog
  void showDateAndDistance() {
    Get.dialog(
      AlertDialog(
        title: const Text('Marathon Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${currentDate.value}'),
            Text('Distance: ${totalDistance.value.toStringAsFixed(2)} meters'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Function to start updating distance
  void _startDistanceUpdate() {
    const double speed = 2.0; // Simulated speed in meters per second (adjustable)
    _distanceTimer?.cancel(); // Cancel any existing timer
    _distanceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isRunning.value) {
        timer.cancel();
        return;
      }
      totalDistance.value += speed; // Increment distance based on speed
    });
  }

  // Function to stop updating distance
  void _stopDistanceUpdate() {
    _distanceTimer?.cancel();
    _distanceTimer = null;
  }

  // Function to reset distance
  void _reset() {
    totalDistance.value = 0.0;
  }

  // Function to check date change and reset distance
  final RxString _lastSavedDate = ''.obs;

  void _checkDateChangeAndReset() {
    final now = DateTime.now();
    final currentFormattedDate = DateFormat("d, MMMM, y").format(now);

    if (_lastSavedDate.value.isEmpty) {
      _lastSavedDate.value = currentFormattedDate;
      return;
    }

    if (_lastSavedDate.value != currentFormattedDate) {
      _reset();
      _lastSavedDate.value = currentFormattedDate;
    }
  }
}