import 'dart:async';
import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/core/services/shared_preferences_data_helper.dart'
    show SharedPreferencesDataHelper;
import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OnClimbController extends GetxController
    with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;

  final double imageHeight = 2000;
  double maxScrollExtent = 0;

  RxBool isTracking = false.obs;
  RxBool isPaused = false.obs;
  RxDouble totalDistance = 0.0.obs;
  RxDouble totalClimbed = 0.0.obs;
  RxInt floorCount = 0.obs;
  RxDouble savedTotalClimbed = 0.0.obs;
  RxString currentDate = ''.obs;
  final RxString _lastSavedDate = ''.obs;

  Position? _lastPosition;
  Timer? _timer;
  StreamSubscription<Position>? _positionStream;

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
        animationController.forward();
      }
    });
    SharedPreferencesDataHelper.clearLegacyClimbingData();
    _loadSavedData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTracking(imageHeight);
    });

    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (isTracking.value && !isPaused.value) {
        _checkDateChangeAndStore();
      }
    });

    Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (isTracking.value && !isPaused.value) {
        final now = DateTime.now();
        final currentFormattedDate = DateFormat("d MMMM, y").format(now);
        await SharedPreferencesDataHelper.saveDailyClimbingTracking(
          totalClimbed.value,
          floorCount.value,
          currentFormattedDate,
        );
        String? token = await SharedPreferencesHelper.getAccessToken();
        if (token == null) {
          if (kDebugMode) {
            await SharedPreferencesDataHelper.saveDailyClimbingTracking(
              totalClimbed.value,
              floorCount.value,
              currentFormattedDate,
            );
            print("Token is null, data saved to SharedPreferences only");
          }
        } else {
          if (kDebugMode) {
            print("Token found, sending data to API------------");
            await sendData(currentFormattedDate, totalDistance.value);
            await SharedPreferencesDataHelper.saveDailyClimbingTracking(
              totalClimbed.value,
              floorCount.value,
              currentFormattedDate,
            );
          }
        }
        await SharedPreferencesDataHelper.printSavedTrackingData();
      }
    });
  }

  Future<void> _loadSavedData() async {
    final lastSavedDate = await SharedPreferencesDataHelper.getLastSavedDate();
    final dateToFetch = lastSavedDate ?? currentDate.value;
    final climbed = await SharedPreferencesDataHelper.getClimbedByDate(
      dateToFetch,
    );
    final floors = await SharedPreferencesDataHelper.getFloorCountByDate(
      dateToFetch,
    );

    savedTotalClimbed.value = climbed ?? 0.0;
    floorCount.value = floors ?? 0;
    currentDate.value = dateToFetch;
    _lastSavedDate.value = dateToFetch;

    await SharedPreferencesDataHelper.printSavedTrackingData();
  }

  void startAnimation(double viewportHeight) {
    maxScrollExtent = imageHeight - viewportHeight;
    if (maxScrollExtent <= 0) return;

    scrollController.jumpTo(maxScrollExtent);
    animationController.forward();
  }

  void stopAnimation() {
    animationController.stop();
  }

  @override
  void onClose() {
    scrollController.dispose();
    animationController.dispose();
    _timer?.cancel();
    _positionStream?.cancel();
    super.onClose();
  }

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
          floorCount.value = (((totalClimbed.value / 2.4384).floor()) ~/ 4);
        }
      }
      _lastPosition = position;
    });

    double lastTotalClimbed = totalClimbed.value;
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
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

  void stopTracking() async {
    _timer?.cancel();
    _positionStream?.cancel();
    stopAnimation();

    isTracking.value = false;
    isPaused.value = false;
  }

  void _reset() {
    totalDistance.value = 0.0;
    totalClimbed.value = 0.0;
    floorCount.value = 0;
    _lastPosition = null;
  }

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat("d MMMM, y").format(now);
  }

  void _checkDateChangeAndStore() async {
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
        await SharedPreferencesDataHelper.saveDailyClimbingTracking(
          totalClimbed.value,
          floorCount.value,
          _lastSavedDate.value,
        );
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
        await SharedPreferencesDataHelper.saveDailyClimbingTracking(
          totalClimbed.value,
          floorCount.value,
          _lastSavedDate.value,
        );
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
      final climbed =
          await SharedPreferencesDataHelper.getClimbedByDate(
            currentFormattedDate,
          ) ??
          0.0;
      final floors =
          await SharedPreferencesDataHelper.getFloorCountByDate(
            currentFormattedDate,
          ) ??
          0;
      totalDistance.value = distance;
      totalClimbed.value = climbed;
      floorCount.value = floors;
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
      final url = '${Urls.baseUrl}/movements/on-climbing';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"date": date, "distance": distance}),
      );
      if (kDebugMode) {
        print("The response of sending climbing data is ${response.body}");
      }
      if (response.statusCode != 200) {
        if (kDebugMode) {
          print("Error sending climbing data: ${response.statusCode}");
        }
        Get.snackbar('Error', 'Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print("The error for sending climbing data is $e");
      }
      Get.snackbar('Error', 'Network error while sending data');
    }
  }
}
