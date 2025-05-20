import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MarathonClimbedController extends GetxController with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;

  final double imageHeight = 2000; // taller than screen for scroll effect
  double maxScrollExtent = 0;

  @override
  void onInit() {
    super.onInit();
    updateCurrentDate();
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






  /////////Tracking///////////////
  ///
  ///
  /////// Tracking///////////
  RxBool isTracking = false.obs;
  RxBool isPaused = false.obs;
  RxDouble totalDistance = 0.0.obs;
  RxDouble totalClimbed = 0.0.obs;
  RxInt floorCount = 0.obs; 
  

  Position? _lastPosition;
  Timer? _timer;
  StreamSubscription<Position>? _positionStream;
  Future<bool> _checkAndRequestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission Denied', 'Location permission is required.');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Permission Denied', 'Enable location from app settings.');
      await Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  void startTracking(double height) async {
    if (!await _checkAndRequestLocationPermission()) return;

    isTracking.value = true;
    isPaused.value = false;
    _lastPosition = null;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 1),
    ).listen((Position position) {
      if (_lastPosition != null) {
        double distance = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        totalDistance.value += distance;

        double elevationGain = position.altitude - _lastPosition!.altitude;
        if (elevationGain > 0) {
          totalClimbed.value += elevationGain;
          floorCount.value = (((totalClimbed.value / 2.4384).floor()) ~/ 4); 
        }
      }
      _lastPosition = position;
    });

  double lastTotalClimbed = totalClimbed.value;
  Timer.periodic(const Duration(seconds: 2), (timer) {
    // Stop checking if tracking is paused or stopped
    if (!isTracking.value || isPaused.value) {
      timer.cancel();
      return;
    }
    if (totalClimbed.value != lastTotalClimbed) {
      startAnimation(height); 
    } else {
      stopAnimation();
    }

    lastTotalClimbed = totalClimbed.value;
  });
  

  

  }
  void pauseTracking() {
    isPaused.value = true;
    _positionStream?.pause();
    _timer?.cancel();
    stopAnimation();
  }

  void resumeTracking() {
    isPaused.value = false;
    _positionStream?.resume();
  }

  void stopTracking() {
    _timer?.cancel();
    _positionStream?.cancel();
    stopAnimation(); 

    isTracking.value = false;
    isPaused.value = false;

    Get.dialog(
      AlertDialog(
        title: const Text('Tracking Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Text('Floors Climbed: ${totalClimbed.value.toStringAsFixed(2)} meters'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _reset();
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  void _reset() {
    totalDistance.value = 0.0;
    totalClimbed.value = 0.0;
    floorCount.value = 0;
    _lastPosition = null;
  }


  RxString currentDate = ''.obs;

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat("d, MMMM, y").format(now);
  }
}