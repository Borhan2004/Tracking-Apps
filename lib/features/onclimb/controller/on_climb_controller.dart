// Importing necessary Dart and Flutter packages
import 'dart:async';
import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart'; // API endpoint URLs
import 'package:chrismiche/core/services/location_service.dart'; // Location service abstraction
import 'package:chrismiche/core/services/shared_preferences_data_helper.dart'; // SharedPreferences helper
import 'package:chrismiche/core/services/shared_preferences_helper.dart'; // Token helper
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/material.dart'; // Core Flutter widgets
import 'package:get/get.dart'; // GetX state management
import 'package:geolocator/geolocator.dart'; // Location services
import 'package:http/http.dart' as http; // HTTP requests
import 'package:intl/intl.dart'; // Date formatting

// Controller for managing climbing activity tracking
class OnClimbController extends GetxController
    with GetTickerProviderStateMixin {
  // Location service instance
  final locationService = LocationService();

  // Reactive variables for state management
  final RxDouble totalElevation = 0.0.obs; // Total elevation gained
  final RxDouble totalDistance = 0.0.obs; // Total horizontal distance
  final RxList<double> altitudeRoute = <double>[].obs; // Altitude history
  final RxBool isTracking = false.obs; // Tracking status
  final RxBool isPaused = false.obs; // Pause status
  final RxInt floorCount = 0.obs; // Number of floors climbed
  final RxString currentDate = ''.obs; // Current date (formatted)
  final RxDouble offset = 0.0.obs; // Scroll offset for animation

  // Animation and scrolling configuration
  late AnimationController animationController;
  final double imageHeight = 2000.0; // Height of the scrollable image
  double maxScrollExtent = 0.0; // Maximum scrollable extent
  static const double minAltitudeThreshold =
      0.5; // Minimum elevation change to register
  double scrollSpeed = 50.0; // Pixels per meter of distance

  // Location tracking variables
  StreamSubscription<Position>? _positionSub; // Stream for location updates
  Position? _lastPosition; // Last recorded position

  // Initialize controller
  @override
  void onInit() {
    super.onInit();
    // Set current date
    updateCurrentDate();
    // Initialize animation controller with a long duration to allow continuous updates
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(days: 1), // Long duration to keep running
    );
    // Update offset based on totalDistance changes
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
    // Clear old data and load saved data
    SharedPreferencesDataHelper.clearLegacyClimbingData();
    _loadSavedData();
    // Start tracking after UI is built
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
    scrollSpeed = imageWidth / meters; // Adjust scroll speed based on distance
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
      animationController.repeat(); // Start continuous animation
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

    // Listen to location updates
    _positionSub = locationService.getPositionStream().listen((
      Position position,
    ) {
      if (_lastPosition == null) {
        _lastPosition = position;
        altitudeRoute.add(position.altitude);
        return;
      }

      // Calculate distance and elevation
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
                4); // 1 floor = 2.4384m, grouped by 4
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

  // Stop tracking and save data
  void stopClimbTracking() async {
    isTracking.value = false;
    isPaused.value = false;
    _positionSub?.cancel();
    _positionSub = null;
    stopAnimation();

    final now = DateTime.now();
    final currentFormattedDate = DateFormat("d MMMM, y").format(now);

    // Save data to SharedPreferences
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
