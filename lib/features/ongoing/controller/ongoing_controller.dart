import 'dart:async';
import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/core/services/shared_preferences_data_helper.dart';
import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OngoingController extends GetxController
    with GetTickerProviderStateMixin {
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

  final List<Position> _positionWindow = [];
  final int _windowSize = 5;
  final double _movementThreshold = 6;
  final double _minAccuracy = 25;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
      offset.value = offsetAnimation.value;
    });

    ever(totalDistance, (double distance) => _updateAnimation(distance));
    _initLocation();
    _startDateListener();

    Timer.periodic(const Duration(seconds: 15), (_) async {
      if (isMoving.value) await _saveData();
    });
  }

  void setScrollSpeed(double imageWidth, double meters) {
    scrollSpeedPerMeter = imageWidth / meters;
    update();
  }

  void startAnimation(double viewportWidth) {
    maxScrollExtent = 2000.0 - viewportWidth;
    if (maxScrollExtent <= 0) return;
    _updateAnimation(totalDistance.value);
    if (isMoving.value && !animationController.isAnimating) {
      animationController.repeat();
    }
  }

  void stopAnimation() {
    animationController.stop();
  }

  void _updateAnimation(double distance) {
    final targetOffset = distance * scrollSpeedPerMeter;
    offsetAnimation = Tween<double>(
      begin: offset.value,
      end: targetOffset,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );

    animationController
      ..reset()
      ..forward();
  }

  void _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) await Geolocator.openLocationSettings();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar('Permission Denied', 'Location permission is required.');
        return;
      }
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
      ),
    ).listen(_handlePosition);
  }

  void _handlePosition(Position position) {
    // Discard poor accuracy
    if (position.accuracy > _minAccuracy) {
      if (kDebugMode)
        debugPrint("Ignored: accuracy too low (${position.accuracy}m)");
      return;
    }

    _positionWindow.add(position);
    if (_positionWindow.length > _windowSize) {
      _positionWindow.removeAt(0);
    }

    if (_positionWindow.length >= 2) {
      double sumDistance = 0.0;
      for (int i = 1; i < _positionWindow.length; i++) {
        sumDistance += Geolocator.distanceBetween(
          _positionWindow[i - 1].latitude,
          _positionWindow[i - 1].longitude,
          _positionWindow[i].latitude,
          _positionWindow[i].longitude,
        );
      }

      double averageMovement = sumDistance / (_positionWindow.length - 1);

      if (averageMovement >= _movementThreshold) {
        isMoving.value = true;
        if (_lastPosition != null) {
          final distance = Geolocator.distanceBetween(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
            position.latitude,
            position.longitude,
          );
          totalDistance.value += distance;
          totalSteps.value =
              (totalDistance.value / averageStrideLength).round();
        }
        if (!animationController.isAnimating) animationController.repeat();
      } else {
        isMoving.value = false;
        stopAnimation();
      }
    }

    _lastPosition = position;
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

        final distance =
            await SharedPreferencesDataHelper.getDistanceByDate(today) ?? 0.0;
        totalDistance.value = distance;
        totalSteps.value = (distance / averageStrideLength).round();
      }
    });
  }

  void _updateDate() {
    currentDate.value = DateFormat("d MMMM, y").format(DateTime.now());
  }

  Future<void> _saveData() async {
    final date = currentDate.value;
    await SharedPreferencesDataHelper.saveDailyOngoingTracking(
      totalDistance.value,
      date,
    );
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token != null) await sendData(date, totalDistance.value);
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
