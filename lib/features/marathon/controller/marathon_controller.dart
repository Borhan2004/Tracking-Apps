import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:chrismiche/core/services/tracking_data_storage.dart';
import 'package:chrismiche/features/details/controller/details_controller.dart'; 

class MarathonController extends GetxController with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;
  late AudioPlayer audioPlayer;

  final double imageWidth = 1000;
  final double viewportWidth = 400;
  double maxScrollExtent = 0;
  final RxBool isRunning = false.obs;

  RxDouble totalDistance = 0.0.obs;
  RxDouble previousDayDistance = 0.0.obs; // Store last saved distance
  Timer? _distanceTimer;
  Timer? _restartTimer;

  @override
  void onInit() async {
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
    _updatePreviousDayDistance(); // Initialize last saved distance
    // Periodically check for date change
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (isRunning.value) {
        _checkDateChangeAndReset();
      }
    });

    // Start checking for animation restart time
    restartAnimationAtSpecificTime(const TimeOfDay(hour: 0, minute: 0)); // Restart at 12:00 AM daily
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

    // Save totalDistance to SharedPreferences before resetting
    try {
      await TrackingDataStorage.saveDailyTracking(
        totalDistance.value,
        currentDate.value,
      );
      debugPrint('Stop: Saved totalDistance: ${totalDistance.value} for ${currentDate.value}');
      previousDayDistance.value = totalDistance.value; // Update previous distance

      // Update DetailsController meters if it exists
      if (Get.isRegistered<DetailsController>()) {
        final detailsController = Get.find<DetailsController>();
        await detailsController.updateMeters();
        debugPrint('Stop: Notified DetailsController to update meters to ${totalDistance.value}');
      }

      totalDistance.value = 0.0; // Reset distance
      debugPrint('Stop: Reset totalDistance to 0.0');
    } catch (e) {
      debugPrint('Stop: Error saving distance: $e');
      Get.snackbar('Error', 'Failed to save distance: $e');
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    animationController.dispose();
    audioPlayer.dispose();
    _stopDistanceUpdate();
    _restartTimer?.cancel();
    super.onClose();
  }

  RxString currentDate = ''.obs;

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat("d, MMMM, y").format(now);
    _updatePreviousDayDistance(); // Update last saved distance when date changes
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

  void _checkDateChangeAndReset() async {
    final now = DateTime.now();
    final currentFormattedDate = DateFormat("d, MMMM, y").format(now);

    if (_lastSavedDate.value.isEmpty) {
      _lastSavedDate.value = currentFormattedDate;
      return;
    }

    if (_lastSavedDate.value != currentFormattedDate) {
      // Save distance before resetting
      try {
        await TrackingDataStorage.saveDailyTracking(
          totalDistance.value,
          _lastSavedDate.value,
        );
        debugPrint('Date change: Saved distance: ${totalDistance.value} for ${_lastSavedDate.value}');
        previousDayDistance.value = totalDistance.value; // Update previous distance

        // Update DetailsController meters if it exists
        if (Get.isRegistered<DetailsController>()) {
          final detailsController = Get.find<DetailsController>();
          await detailsController.updateMeters();
          debugPrint('Date change: Notified DetailsController to update meters to ${totalDistance.value}');
        }
      } catch (e) {
        debugPrint('Date change: Error saving distance: $e');
        Get.snackbar('Error', 'Failed to save distance: $e');
      }
      _reset();
      _lastSavedDate.value = currentFormattedDate;
      _updatePreviousDayDistance(); // Update last saved distance
    }
  }

  // Function to restart animation at a specific time
  void restartAnimationAtSpecificTime(TimeOfDay restartTime) {
    // Cancel any existing restart timer to avoid duplicates
    _restartTimer?.cancel();

    // Create a periodic timer to check the current time every minute
    _restartTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

      // Check if the current time matches the specified restart time
      if (currentTime.hour == restartTime.hour &&
          currentTime.minute == restartTime.minute) {
        // Stop the current animation and distance updates
        stopAnimation();

        // Reset distance to start fresh
        _reset();

        // Start the animation and distance updates again
        startAnimation();

        // Show a notification to the user
        Get.snackbar('Animation Restarted', 'Running animation restarted at $restartTime.');
      }
    });
  }

  // Function to update the last saved distance
  void _updatePreviousDayDistance() async {
    try {
      final lastSaved = await TrackingDataStorage.getLastSavedDistance();
      previousDayDistance.value = lastSaved['distance'] as double;
      debugPrint('Updated previousDayDistance: ${previousDayDistance.value} for date: ${lastSaved['date']}');
    } catch (e) {
      debugPrint('Error updating last saved distance: $e');
      Get.snackbar('Error', 'Failed to retrieve last saved distance: $e');
      previousDayDistance.value = 0.0;
    }
  }
}