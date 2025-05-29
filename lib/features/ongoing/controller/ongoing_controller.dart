import 'dart:async';
import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart' show Urls;
import 'package:chrismiche/core/services/shared_preferences_data_helper.dart'
    show SharedPreferencesDataHelper;
import 'package:chrismiche/core/services/shared_preferences_helper.dart' show SharedPreferencesHelper;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OngoingController extends GetxController
    with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;
  final double imageWidth = 1000;
  final double viewportWidth = 400;
  double maxScrollExtent = 0;

  @override
  void onInit() {
    super.onInit();
    SharedPreferencesDataHelper.clearLegacyClimbingData();
    updateCurrentDate();
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTracking();
    });

    Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (isTracking.value && !isPaused.value) {
         _checkDateChangeAndStore();
      }
    });

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (isTracking.value && !isPaused.value) {
        final now = DateTime.now();
        final currentFormattedDate = DateFormat("d, MMMM, y").format(now);
        await SharedPreferencesDataHelper.saveDailyOngoingTracking(
          totalDistance.value,
          totalClimbed.value,
          currentFormattedDate,
        );
        await SharedPreferencesDataHelper.printSavedTrackingData();
      }
    });
  }

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

    final now = DateTime.now();
    final currentFormattedDate = DateFormat("d, MMMM, y").format(now);
    SharedPreferencesDataHelper.saveDailyOngoingTracking(
      totalDistance.value,
      totalClimbed.value,
      currentFormattedDate,
    );

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
            Text('Elevation Climbed: ${totalClimbed.value.toStringAsFixed(2)} meters'),
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

  RxString currentDate = ''.obs;

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat("d, MMMM, y").format(now);
  }

  final RxString _lastSavedDate = ''.obs;

  void _checkDateChangeAndStore() async {
    final now = DateTime.now();
    final currentFormattedDate = DateFormat("d, MMMM, y").format(now);

    if (_lastSavedDate.value.isEmpty) {
      _lastSavedDate.value = currentFormattedDate;
      return;
    }

    if (_lastSavedDate.value != currentFormattedDate) {
      await SharedPreferencesDataHelper.saveDailyOngoingTracking(
        totalDistance.value,
        totalClimbed.value,
        _lastSavedDate.value,
      );
      await SharedPreferencesDataHelper.printSavedTrackingData();
      
      _reset();
      _lastSavedDate.value = currentFormattedDate;
    }
  }

  Future<void> updateDistance(String date, double distance) async{
    try{
      String? token = await SharedPreferencesHelper.getAccessToken(); 
      if(token == null) {
        if (kDebugMode) {
          print("No token found");
        }
        return;
      }
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/movements/ongoing'), 
        headers: {
          'Content-Type': 'application/json', 
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'date': date,
          'distance': distance,
        })
      ); 

      if (response.statusCode == 200){
        if (kDebugMode) {
          print("The data inseted successfully");
        } 
      } else{
        if (kDebugMode) {
          print("Error updating distance: ${response.statusCode}"); 
        }
      }
    } catch (e){
      if (kDebugMode) {
        print("The error of fetching distance is $e");
      }
    }
  }
}