import 'dart:async';
import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/core/services/shared_preferences_data_helper.dart' show SharedPreferencesDataHelper;
import 'package:chrismiche/core/services/shared_preferences_helper.dart' show SharedPreferencesHelper;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OngoingController extends GetxController with GetTickerProviderStateMixin {
  final totalDistance = 0.0.obs;
  final totalSteps = 0.obs;
  final currentDate = ''.obs;
  final isMoving = false.obs;
  final offset = 0.0.obs;
  Timer? resetTimer;
  Position? _lastPosition;

  double scrollSpeedPerMeter = 2.0;
  final double averageStrideLength = 0.762;
  double maxScrollExtent = 0.0; 

  late AnimationController animationController;
  late Animation<double> offsetAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), 
    )..addListener(() {
        offset.value = offsetAnimation.value;
        // if (kDebugMode) {
        //   debugPrint('Offset: ${offset.value}, MaxScrollExtent: $maxScrollExtent');
        // }
      });

    ever(totalDistance, (double distance) {
      _updateAnimation(distance);
    });
    _initLocation();
    _startDateListener();
    Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (isMoving.value) {
        await _saveData();
      }
    });
  }

  void setScrollSpeed(double imageWidth, double meters) {
    scrollSpeedPerMeter = imageWidth / meters; // Scroll full image over specified meters
    if (kDebugMode) {
      debugPrint('ScrollSpeed set to: $scrollSpeedPerMeter (imageWidth=$imageWidth, meters=$meters)');
    }
    update();
  }

  void startAnimation(double viewportWidth) {
    maxScrollExtent = 2000.0 - viewportWidth; // Assume image width of 2000.0
    if (maxScrollExtent <= 0) {
      if (kDebugMode) {
        debugPrint('Invalid maxScrollExtent: $maxScrollExtent, viewportWidth=$viewportWidth');
      }
      maxScrollExtent = 0;
      return;
    }
    if (kDebugMode) {
      debugPrint('Starting animation with maxScrollExtent=$maxScrollExtent');
    }
    _updateAnimation(totalDistance.value);
    if (isMoving.value && !animationController.isAnimating) {
      animationController.repeat();
    }
  }

  void stopAnimation() {
    animationController.stop();
    if (kDebugMode) {
      debugPrint('Animation stopped');
    }
  }

  void _updateAnimation(double distance) {
    final targetOffset = (distance * scrollSpeedPerMeter) % (maxScrollExtent * 2);
    offsetAnimation = Tween<double>(
      begin: offset.value,
      end: targetOffset,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );
    animationController
      ..reset()
      ..forward();
  }

  void _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) await Geolocator.openLocationSettings();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        Get.snackbar('Permission Denied', 'Location permission is required.');
        return;
      }
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      _handleMovement(position);
    });
  }

  void _handleMovement(Position newPosition) {
    if (_lastPosition != null) {
      double distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      if (distance >= 1.5) {
        isMoving.value = true;
        totalDistance.value += distance;
        totalSteps.value = (totalDistance.value / averageStrideLength).round();
        if (!animationController.isAnimating) {
          animationController.repeat();
        }
      } else {
        isMoving.value = false;
        stopAnimation();
      }
    }
    _lastPosition = newPosition;
  }

  void _startDateListener() {
    _updateDate();
    resetTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      final now = DateTime.now();
      final today = DateFormat("d MMMM, y").format(now);

      if (today != currentDate.value) {
        await _saveData();
        totalDistance.value = 0.0;
        totalSteps.value = 0;
        _lastPosition = null;
        _updateDate();

        final distance = await SharedPreferencesDataHelper.getDistanceByDate(today) ?? 0.0;
        totalDistance.value = distance;
        totalSteps.value = (distance / averageStrideLength).round();
      }
    });
  }

  void _updateDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat("d MMMM, y").format(now);
  }

  Future<void> _saveData() async {
    final formattedDate = currentDate.value;
    await SharedPreferencesDataHelper.saveDailyOngoingTracking(totalDistance.value, formattedDate);
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token != null) await sendData(formattedDate, totalDistance.value);
  }

  @override
  void onClose() {
    resetTimer?.cancel();
    animationController.dispose();
    super.onClose();
  }

  Future<void> sendData(String date, double distance) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/movements/ongoing'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"date": date, "distance": distance}),
      );

      if (response.statusCode != 200) {
        Get.snackbar('Error', 'Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error while sending data');
    }
  }
}