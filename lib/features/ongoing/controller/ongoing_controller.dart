import 'dart:async';
import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart' show Urls;
import 'package:chrismiche/core/services/shared_preferences_data_helper.dart'
    show SharedPreferencesDataHelper;
import 'package:chrismiche/core/services/shared_preferences_helper.dart'
    show SharedPreferencesHelper;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OngoingController extends GetxController
    with GetTickerProviderStateMixin {
  ScrollController? scrollController;
  AnimationController? animationController;
  final double imageWidth = 1000;
  final double viewportWidth = 400;
  double maxScrollExtent = 0;

  @override
  void onInit() async {
    super.onInit();
    scrollController = ScrollController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animationController!.addListener(() {
      if (scrollController!.hasClients) {
        final value = animationController!.value * maxScrollExtent;
        scrollController!.jumpTo(value);
      }
    });

    animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController!.reset();
        animationController!.forward();
      }
    });

    await SharedPreferencesDataHelper.clearLegacyClimbingData();
    updateCurrentDate();

    final now = DateTime.now();
    final currentFormattedDate = DateFormat("d MMMM, y").format(now);
    final distance =
        await SharedPreferencesDataHelper.getDistanceByDate(
          currentFormattedDate,
        ) ??
        0.0;
    totalDistance.value = distance;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTracking();
    });

    Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (isTracking.value && !isPaused.value) {
        await _checkDateChangeAndStore();
      }
    });

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (isTracking.value && !isPaused.value) {
        final now = DateTime.now();
        final currentFormattedDate = DateFormat("d MMMM, y").format(now);
        String? token = await SharedPreferencesHelper.getAccessToken();
        if (token == null) {
          if (kDebugMode) {
            print("Token is null, saving to SharedPreferences");
          }
          await SharedPreferencesDataHelper.saveDailyOngoingTracking(
            totalDistance.value,
            currentFormattedDate,
          );
          await SharedPreferencesDataHelper.printSavedTrackingData();
        } else {
          if (kDebugMode) {
            print("Token found, sending data to API///////");
          }
          await sendData(currentFormattedDate, totalDistance.value);
          await SharedPreferencesDataHelper.saveDailyOngoingTracking(
            totalDistance.value,
            currentFormattedDate,
          );
          await SharedPreferencesDataHelper.printSavedTrackingData();
        }
      }
    });
  }

  void startAnimation() {
    if (animationController == null || scrollController == null) return;
    maxScrollExtent = imageWidth - viewportWidth;
    if (maxScrollExtent <= 0) return;
    animationController!.forward();
  }

  void stopAnimation() {
    if (animationController == null) return;
    animationController!.stop();
  }

  @override
  void onClose() {
    scrollController?.dispose();
    animationController?.dispose();
    _timer?.cancel();
    _positionStream?.cancel();
    super.onClose();
  }

  RxBool isTracking = false.obs;
  RxBool isPaused = false.obs;
  RxDouble totalDistance = 0.0.obs;

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
      }
      _lastPosition = position;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    if (!isPaused.value) return;

    isPaused.value = false;
    _positionStream?.resume();

    bool isAnimating = animationController?.isAnimating ?? false;
    double lastDistance = totalDistance.value;
    int unchangedCount = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

  void stopTracking() async {
    _timer?.cancel();
    _positionStream?.cancel();
    stopAnimation();

    final now = DateTime.now();
    final currentFormattedDate = DateFormat("d MMMM, y").format(now);
    await SharedPreferencesDataHelper.saveDailyOngoingTracking(
      totalDistance.value,
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
    _lastPosition = null;
  }

  RxString currentDate = ''.obs;

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat("d MMMM, y").format(now);
  }

  final RxString _lastSavedDate = ''.obs;

  Future<void> _checkDateChangeAndStore() async {
    final now = DateTime.now();
    final currentFormattedDate = DateFormat("d MMMM, y").format(now);

    if (_lastSavedDate.value.isEmpty) {
      _lastSavedDate.value = currentFormattedDate;
      return;
    }

    if (_lastSavedDate.value != currentFormattedDate) {
      String? token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        if (kDebugMode) {
          print("Token is null, saving to SharedPreferences on date change");
        }
        await SharedPreferencesDataHelper.saveDailyOngoingTracking(
          totalDistance.value,
          _lastSavedDate.value,
        );
        await SharedPreferencesDataHelper.printSavedTrackingData();
      } else {
        if (kDebugMode) {
          print(
            "Token found, sending data to API and saving to SharedPreferences on date change",
          );
        }
        await sendData(_lastSavedDate.value, totalDistance.value);
        await SharedPreferencesDataHelper.saveDailyOngoingTracking(
          totalDistance.value,
          _lastSavedDate.value,
        );
        await SharedPreferencesDataHelper.printSavedTrackingData();
      }

      _reset();
      _lastSavedDate.value = currentFormattedDate;

      final distance =
          await SharedPreferencesDataHelper.getDistanceByDate(
            currentFormattedDate,
          ) ??
          0.0;
      totalDistance.value = distance;
    }
  }

  Future<void> sendData(String date, double distance) async {
    try {
      String? token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        if (kDebugMode) {
          print("No access token found");
        }
        return;
      }
      final url = '${Urls.baseUrl}/movements/ongoing';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"date": date, "distance": distance}),
      );

      if (kDebugMode) {
        print("The response of sending marathon data is ${response.body}");
      }

      if (response.statusCode == 200) {
      } else {
        if (kDebugMode) {
          print("Error sending marathon data: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("The error for sending marathon data is $e");
      }
    }
  }
}
