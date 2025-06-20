import 'dart:async';
import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/core/services/shared_preferences_data_helper.dart';
import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class OngoingController extends GetxController with GetTickerProviderStateMixin {
  final totalDistance = 0.0.obs;
  final totalSteps = 0.obs;
  final currentDate = ''.obs;
  final isMoving = false.obs;
  final offset = 0.0.obs;

  Timer? resetTimer;
  StreamSubscription<StepCount>? _stepCountSubscription;
  int _initialStepCount = -1;

  double scrollSpeedPerMeter = 2.0;
  final double averageStrideLength = 0.762;
  double maxScrollExtent = 0.0;

  late AnimationController animationController;
  late Animation<double> offsetAnimation;

  @override
  void onInit() async {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        offset.value = offsetAnimation.value;
      });

    ever(totalDistance, (double distance) => _updateAnimation(distance));

    await _requestPermissions();
    await _loadInitialData();
    _initPedometer();
    _startDateListener();

    Timer.periodic(const Duration(seconds: 15), (_) async {
      await _saveData();
    });
  }

  Future<void> _requestPermissions() async {
    if (await Permission.activityRecognition.isGranted) {
      if (kDebugMode) {
        print('Activity recognition permission already granted');
      }
    } else if (await Permission.activityRecognition.request().isGranted) {
      if (kDebugMode) {
        print('Activity recognition permission granted');
      }
    } else {
      Get.snackbar('Permission Denied', 'Activity recognition permission is required for step tracking.');
      if (kDebugMode) {
        print('Activity recognition permission denied');
      }
    }
  }

  Future<void> _loadInitialData() async {
    final today = DateFormat("d MMMM, y").format(DateTime.now());
    currentDate.value = today;
    final distance = await SharedPreferencesDataHelper.getDistanceByDate(today) ?? 0.0;
    totalDistance.value = distance;
    totalSteps.value = (distance / averageStrideLength).round();
    if (kDebugMode) debugPrint('Loaded initial data: date=$today, distance=$distance, steps=${totalSteps.value}');
  }

  void setScrollSpeed(double imageWidth, double meters) {
    if (meters <= 0) return;
    scrollSpeedPerMeter = imageWidth / meters;
    update();
    if (kDebugMode) debugPrint('Set scroll speed: $scrollSpeedPerMeter');
  }

  void startAnimation(double viewportWidth) {
    maxScrollExtent = 2000.0 - viewportWidth;
    if (maxScrollExtent <= 0) {
      if (kDebugMode) debugPrint('Invalid maxScrollExtent: $maxScrollExtent');
      return;
    }
    _updateAnimation(totalDistance.value);
    if (isMoving.value && !animationController.isAnimating) {
      animationController.repeat();
    }
  }

  void stopAnimation() {
    if (animationController.isAnimating) {
      animationController.stop();
      if (kDebugMode) debugPrint('Animation stopped');
    }
  }
///////////////////////////
  void _updateAnimation(double distance) {
    if (maxScrollExtent <= 0) {
      if (kDebugMode) debugPrint('Cannot update animation: maxScrollExtent is $maxScrollExtent');
      return;
    }

    final targetOffset = (distance * scrollSpeedPerMeter).clamp(0.0, maxScrollExtent);

    if (targetOffset == offset.value) {
      if (kDebugMode) debugPrint('No animation needed: targetOffset=$targetOffset, currentOffset=${offset.value}');
      return;
    }

    offsetAnimation = Tween<double>(
      begin: offset.value,
      end: targetOffset,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );

    animationController
      ..stop()
      ..reset();
    animationController.forward();
    if (kDebugMode) debugPrint('Animation triggered for distance: $distance, targetOffset: $targetOffset');
  }

  void _initPedometer() {
    _stepCountSubscription?.cancel();
    _stepCountSubscription = Pedometer.stepCountStream.listen(
      _handleStepCount,
      onError: (error) {
        Get.snackbar('Pedometer Error', 'Failed to access pedometer: $error');
        if (kDebugMode) debugPrint('Pedometer error: $error');
      },
      cancelOnError: false,
    );
    if (kDebugMode) debugPrint('Pedometer initialized');
  }

  void _handleStepCount(StepCount event) {
    if (_initialStepCount == -1) {
      _initialStepCount = event.steps;
      if (kDebugMode) debugPrint('Initial step count set: $_initialStepCount');
      return;
    }

    int stepsSinceStart = event.steps - _initialStepCount;

    if (stepsSinceStart < 0) {
      _initialStepCount = event.steps;
      stepsSinceStart = 0;
      if (kDebugMode) debugPrint('Step count reset: new initialStepCount=$_initialStepCount');
    }

    if (stepsSinceStart >= totalSteps.value) {
      final previousSteps = totalSteps.value;
      totalSteps.value = stepsSinceStart;
      totalDistance.value = Precision(stepsSinceStart * averageStrideLength).toPrecision(2);
      isMoving.value = stepsSinceStart > previousSteps;
      if (kDebugMode) debugPrint('Step event: raw=${event.steps}, stepsSinceStart=$stepsSinceStart, totalSteps=${totalSteps.value}, distance=${totalDistance.value}, isMoving=${isMoving.value}');
    } else {
      isMoving.value = false;
      stopAnimation();
      if (kDebugMode) debugPrint('No step increase: stepsSinceStart=$stepsSinceStart, totalSteps=${totalSteps.value}');
    }
  }

  void _startDateListener() {
    resetTimer?.cancel();
    resetTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      final now = DateTime.now();
      final today = DateFormat("d MMMM, y").format(now);
      if (today != currentDate.value) {
        await _saveData();
        totalDistance.value = 0.0;
        totalSteps.value = 0;
        _initialStepCount = -1;
        currentDate.value = today;

        final distance = await SharedPreferencesDataHelper.getDistanceByDate(today) ?? 0.0;
        totalDistance.value = distance;
        totalSteps.value = (distance / averageStrideLength).round();
        if (kDebugMode) debugPrint('Date changed to $today, reset data: distance=$distance, steps=${totalSteps.value}');
      }
    });
  }

  Future<void> _saveData() async {
    final date = currentDate.value;
    await SharedPreferencesDataHelper.saveDailyOngoingTracking(
      totalDistance.value,
      date,
    );
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token != null) await sendData(date, totalDistance.value);
    if (kDebugMode) debugPrint('Saved data: date=$date, distance=${totalDistance.value}');
  }

  @override
  void onClose() {
    resetTimer?.cancel();
    _stepCountSubscription?.cancel();
    animationController.dispose();
    super.onClose();
    if (kDebugMode) debugPrint('OngoingController closed');
  }

  Future<void> sendData(String date, double distance) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        if (kDebugMode) debugPrint('No token available for sending data');
        return;
      }

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
        if (kDebugMode) debugPrint('Failed to send data: status=${response.statusCode}');
      } else {
        if (kDebugMode) debugPrint('Data sent successfully: date=$date, distance=$distance');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error while sending data: $e');
      if (kDebugMode) debugPrint('Network error while sending data: $e');
    }
  }
}

extension Precision on double {
  double toPrecision(int fractionDigits) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}