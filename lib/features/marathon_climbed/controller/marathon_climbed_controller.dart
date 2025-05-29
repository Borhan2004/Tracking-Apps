import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/core/services/climbing_data_storage.dart';
import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MarathonClimbedController extends GetxController with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;
  late AudioPlayer audioPlayer;

  final double imageHeight = 2000;
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
    audioPlayer = AudioPlayer();
    audioPlayer.setSource(AssetSource('music/Running.wav')); 

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
    audioPlayer.dispose();
    _timer?.cancel();
    _trackingTimer?.cancel();
    _positionStream?.cancel();
    super.onClose();
  }

  RxBool isTracking = false.obs;
  RxBool isPaused = false.obs;
  RxDouble totalDistance = 0.0.obs;
  RxDouble totalClimbed = 0.0.obs;
  RxInt floorCount = 0.obs;
  RxString elapsedTime = '00:00:00'.obs; 
  Timer? _trackingTimer;
  int _secondsElapsed = 0;

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
    _secondsElapsed = 0;
    elapsedTime.value = '00:00:00';

    _trackingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isTracking.value || isPaused.value) return;
      _secondsElapsed++;
      _updateElapsedTime();
    });

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

    await audioPlayer.setSource(AssetSource('music/Elevator.wav'));
    await audioPlayer.resume(); 

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

  void pauseTracking() async {
    isPaused.value = true;
    _positionStream?.pause();
    _timer?.cancel();
    _trackingTimer?.cancel();
    stopAnimation();
    await audioPlayer.pause();
  }

  void resumeTracking() async {
    isPaused.value = false;
    _positionStream?.resume();
    await audioPlayer.resume();
    _trackingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isTracking.value || isPaused.value) return;
      _secondsElapsed++;
      _updateElapsedTime();
    });
  }

  void stopTracking() async {
    _timer?.cancel();
    _trackingTimer?.cancel();
    _positionStream?.cancel();
    stopAnimation();
    await audioPlayer.stop(); 

    final storage = ClimbingDataStorage();
    await storage.saveClimbingData(totalClimbed.value, currentDate.value);

    isTracking.value = false;
    isPaused.value = false;

    Get.dialog(
      AlertDialog(
        title: const Text('Tracking Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${currentDate.value}'),
            Text('Floors Climbed: ${floorCount.value} floors'),
            Text('Height Climbed: ${totalClimbed.value.toStringAsFixed(2)} meters'),
            Text('Time Elapsed: ${elapsedTime.value}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              sendData(currentDate.value, elapsedTime.value, totalClimbed.value);
              Get.back();
              _reset();
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  void _updateElapsedTime() {
    final hours = (_secondsElapsed ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_secondsElapsed % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
    elapsedTime.value = '$hours:$minutes:$seconds';
  }

  void _reset() {
    totalDistance.value = 0.0;
    totalClimbed.value = 0.0;
    floorCount.value = 0;
    elapsedTime.value = '00:00:00';
    _secondsElapsed = 0;
    _lastPosition = null;
  }

  RxString currentDate = ''.obs;

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat("d MMMM, y").format(now);
  }
  
  Future<void> sendData(String date, String time, double distance) async {
    try {
      EasyLoading.show(status: "Sending data...");
      String? token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        if (kDebugMode) {
          print("No access token found");
        }
        return;
      }
      final url = '${Urls.baseUrl}/instant-movements/tracking-climb';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "date": date,
          "time": time,
          "distance": distance,
        }),
      );

      if (kDebugMode) {
        print("The response of sending marathon data is ${response.body}");
      }

      if (response.statusCode == 200) {
        EasyLoading.showSuccess("Data sent successfully");
      } else {
        EasyLoading.showError("Failed to send data: ${response.statusCode}");
        if (kDebugMode) {
          print("Error sending marathon data: ${response.statusCode}");
        }
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
      if (kDebugMode) {
        print("The error for sending marathon data is $e");
      }
    } finally {
      EasyLoading.dismiss();
    }
  }
}