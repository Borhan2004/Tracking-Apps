import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class OngoingController extends GetxController with GetTickerProviderStateMixin {

  ////////////Run Animation///////////
  late ScrollController scrollController;
  late AnimationController animationController;
  final double imageWidth = 1000;  
  final double viewportWidth = 400;  
  double maxScrollExtent = 0;

  void startAnimation() {
    maxScrollExtent = imageWidth - viewportWidth;
    if (maxScrollExtent <= 0) return;
    animationController.forward();
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

  

  /////// Tracking///////////
  RxBool isTracking = false.obs;
  RxBool isPaused = false.obs;
  RxDouble totalDistance = 0.0.obs;
  RxDouble totalClimbed = 0.0.obs;


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

  void startTracking() async {
  if (!await _checkAndRequestLocationPermission()) return;

  isTracking.value = true;
  isPaused.value = false;
  _lastPosition = null;

  bool isAnimating = false;
  double lastDistance = totalDistance.value;
  int unchangedCount = 0;

  // Start listening to position updates
  _positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
    ),
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
      }
    }
    _lastPosition = position;
  });

  // Real-time 1-second interval checking
  Timer.periodic(const Duration(seconds: 1), (timer) {
    if (!isTracking.value || isPaused.value) {
      timer.cancel();
      return;
    }

    if (totalDistance.value != lastDistance) {
      unchangedCount = 0;
      if (!isAnimating) {
        startAnimation();
        isAnimating = true;
      }
    } else {
      unchangedCount++;
      if (unchangedCount >= 2 && isAnimating) {
        // If distance hasn't changed for 2 consecutive checks (2s), stop animation
        stopAnimation();
        isAnimating = false;
      }
    }

    lastDistance = totalDistance.value;
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
            Text('Distance: ${totalDistance.value.toStringAsFixed(2)} meters'),
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
    _lastPosition = null;
  }


  @override
  void onInit() {
    _checkAndRequestLocationPermission(); 
    updateCurrentDate(); 
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

      // Automatically start tracking on launch
  WidgetsBinding.instance.addPostFrameCallback((_) {
    startTracking();
  });

  // Reset tracking every 1 minute
  Timer.periodic(const Duration(minutes: 1), (timer) {
    if (isTracking.value && !isPaused.value) {
      _reset();
    }
  });
  }





  RxString currentDate = ''.obs;

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat("d, MMMM, y").format(now);
  }
}