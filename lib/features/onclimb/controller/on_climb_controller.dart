import 'dart:async';
import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/core/services/location_service.dart';
import 'package:chrismiche/core/services/shared_preferences_data_helper.dart';
import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart'; 
import 'package:get/get.dart'; 
import 'package:geolocator/geolocator.dart'; 
import 'package:http/http.dart' as http; 
import 'package:intl/intl.dart';

class OnClimbController extends GetxController
    with GetTickerProviderStateMixin {
  final locationService = LocationService();

  final RxDouble totalElevation = 0.0.obs;
  final RxDouble totalDistance = 0.0.obs; 
  final RxList<double> altitudeRoute = <double>[].obs; 
  final RxBool isTracking = false.obs; 
  final RxBool isPaused = false.obs; 
  final RxInt floorCount = 0.obs; 
  final RxString currentDate = ''.obs; 
  final RxDouble offset = 0.0.obs; 

  late AnimationController animationController;
  final double imageHeight = 2000.0; 
  double maxScrollExtent = 0.0; 
  static const double minAltitudeThreshold =
      0.5; 
  double scrollSpeed = 50.0; 

  
  StreamSubscription<Position>? _positionSub; 
  Position? _lastPosition; 

  @override
  void onInit() {
    super.onInit();
    updateCurrentDate();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(days: 1), 
    );
    ever(totalDistance, (double distance) {
      if (maxScrollExtent > 0) {
        offset.value = (distance * scrollSpeed) % (maxScrollExtent * 2);
        if (kDebugMode) {
          debugPrint(
            'Distance: $distance, Offset: ${offset.value}, MaxScrollExtent: $maxScrollExtent',
          );
        }
      }
    });
    SharedPreferencesDataHelper.clearLegacyClimbingData();
    _loadSavedData();
    WidgetsBinding.instance.addPostFrameCallback((_) => startClimbTracking());
  }

  Future<void> _loadSavedData() async {
    final lastSavedDate = await SharedPreferencesDataHelper.getLastSavedDate();
    final dateToFetch = lastSavedDate ?? currentDate.value;
    final climbed =
        await SharedPreferencesDataHelper.getClimbedByDate(dateToFetch) ?? 0.0;
    final floors =
        await SharedPreferencesDataHelper.getFloorCountByDate(dateToFetch) ?? 0;
    final distance =
        await SharedPreferencesDataHelper.getDistanceByDate(dateToFetch) ?? 0.0;

    totalElevation.value = climbed;
    totalDistance.value = distance;
    floorCount.value = floors;
    currentDate.value = dateToFetch;

    if (kDebugMode) {
      print(
        'Loaded: Elevation=$climbed m, Distance=$distance m, Floors=$floors, Date=$dateToFetch',
      );
    }
  }

  void setScrollSpeed(double imageWidth, double meters) {
    scrollSpeed = imageWidth / meters;
    if (kDebugMode) {
      debugPrint(
        'ScrollSpeed set to: $scrollSpeed (imageWidth=$imageWidth, meters=$meters)',
      );
    }
    update();
  }

  void startAnimation(double viewportHeight) {
    maxScrollExtent = imageHeight - viewportHeight;
    if (maxScrollExtent <= 0) {
      if (kDebugMode) {
        debugPrint(
          'Invalid maxScrollExtent: $maxScrollExtent, viewportHeight=$viewportHeight',
        );
      }
      maxScrollExtent = 0;
      return;
    }
    if (kDebugMode) {
      debugPrint('Starting animation with maxScrollExtent=$maxScrollExtent');
    }
    offset.value = maxScrollExtent;
    if (!animationController.isAnimating) {
      animationController.repeat();
    }
  }

  void stopAnimation() {
    animationController.stop();
    if (kDebugMode) {
      debugPrint('Animation stopped');
    }
  }

  Future<bool> _checkAndRequestLocationPermission() async {
    if (!await locationService.ensurePermission()) {
      Get.snackbar('Permission Denied', 'Location permission is required.');
      return false;
    }
    return true;
  }

  void startClimbTracking() async {
    if (!await _checkAndRequestLocationPermission()) return;

    isTracking.value = true;
    isPaused.value = false;
    _lastPosition = null;
    _positionSub?.cancel();

    _positionSub = locationService.getPositionStream().listen((
      Position position,
    ) {
      if (_lastPosition == null) {
        _lastPosition = position;
        altitudeRoute.add(position.altitude);
        return;
      }

      final distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      totalDistance.value += distance;

      final elevationGain = position.altitude - _lastPosition!.altitude;
      if (elevationGain.abs() >= minAltitudeThreshold) {
        totalElevation.value += elevationGain.abs();
        altitudeRoute.add(position.altitude);
        floorCount.value =
            ((totalElevation.value / 2.4384).floor() ~/
                2); 
      }

      _lastPosition = position;
    });
  }

  void pauseClimbTracking() {
    isPaused.value = true;
    _positionSub?.pause();
    stopAnimation();
  }

  void resumeClimbTracking() {
    if (!isTracking.value) return;
    isPaused.value = false;
    _positionSub?.resume();
    if (!animationController.isAnimating) {
      animationController.repeat();
    }
  }

  void stopClimbTracking() async {
    isTracking.value = false;
    isPaused.value = false;
    _positionSub?.cancel();
    _positionSub = null;
    stopAnimation();

    final now = DateTime.now();
    final currentFormattedDate = DateFormat("d MMMM, y").format(now);

    await SharedPreferencesDataHelper.saveDailyClimbingTracking(
      totalElevation.value,
      floorCount.value,
      currentFormattedDate,
    );
    await SharedPreferencesDataHelper.saveDailyOngoingTracking(
      totalDistance.value,
      currentFormattedDate,
    );

    final token = await SharedPreferencesHelper.getAccessToken();
    if (token != null) {
      await sendData(currentFormattedDate, totalDistance.value);
    }
  }

  void updateCurrentDate() {
    currentDate.value = DateFormat("d MMMM, y").format(DateTime.now());
  }

  Future<void> sendData(String date, double distance) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/movements/on-climbing'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'date': date, 'distance': distance}),
      );

      if (response.statusCode != 200) {
        Get.snackbar('Error', 'Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error while sending data');
    }
  }

  @override
  void onClose() {
    stopClimbTracking();
    animationController.dispose();
    super.onClose();
  }
}
