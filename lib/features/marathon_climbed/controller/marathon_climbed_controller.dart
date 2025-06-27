import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/core/services/climbing_data_storage.dart';
import 'package:chrismiche/core/services/location_service.dart';
import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:chrismiche/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MarathonClimbedController extends GetxController
    with GetTickerProviderStateMixin {
  final locationService = LocationService();

  final RxDouble totalElevation = 0.0.obs;
  final RxList<double> altitudeRoute = <double>[].obs;
  final RxBool isTracking = false.obs;
  final RxInt floorCount = 0.obs;
  late AnimationController animationController;
  final RxDouble offset = 0.0.obs;
  double scrollSpeed = 50.0;
  Timer? _trackingTimer;
  int _secondsElapsed = 0;
  RxString currentDate = ''.obs;
  RxString elapsedTime = '00:00:00'.obs;
  late AudioPlayer audioPlayer;
  RxBool isPaused = false.obs;

  @override
  void onInit() {
    super.onInit();
    updateCurrentDate();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    );
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (kDebugMode) {
        print('AudioPlayer state: $state');
      }
    });
    animationController.addListener(() {
      final elapsed =
          animationController.lastElapsedDuration?.inMilliseconds ?? 0;
      offset.value = (elapsed / 1000) * scrollSpeed;
    });
  }

  void setScrollSpeed(double imageWidth, double seconds) {
    scrollSpeed = imageWidth / seconds;
    update();
  }

  StreamSubscription<Position>? _positionSub;
  double? _lastAltitude;

  static const double minAltitudeThreshold = 0.5;

  void startClimbTracking() async {
    try {
      await audioPlayer.setSource(AssetSource('music/Elevator.wav'));
      await audioPlayer.resume();
      if (kDebugMode) {
        print('Audio playback started: Elevator.wav');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error setting or playing audio: $e');
      }
      Get.snackbar('Audio Error', 'Failed to play audio: $e');
    }

    if (!animationController.isAnimating) {
      animationController.repeat();
    }
    bool permissionGranted = await locationService.ensurePermission();
    if (!permissionGranted) {
      Get.snackbar("Permission Denied", "Location permission is required.");
      if (kDebugMode) print("❌ Location permission not granted.");
      return;
    }

    if (kDebugMode) print('✅ Location permission granted');

    await _positionSub?.cancel();

    _positionSub = locationService.getPositionStream().listen((position) {
      double currentAltitude = position.altitude;

      if (_lastAltitude == null) {
        _lastAltitude = currentAltitude;
        altitudeRoute.add(currentAltitude);
        if (kDebugMode) {
          print('📍 First altitude: ${currentAltitude.toStringAsFixed(2)} m');
        }
        return;
      }

      double diff = currentAltitude - _lastAltitude!;
      if (diff.abs() >= minAltitudeThreshold) {
        totalElevation.value += diff.abs();
        _lastAltitude = currentAltitude;
        altitudeRoute.add(currentAltitude);
        countFloor();

        if (kDebugMode) {
          print('⛰️ Altitude: ${currentAltitude.toStringAsFixed(2)} m');
          print('⬆️ Gained: ${diff.toStringAsFixed(2)} m');
          print(
            '📏 Total elevation: ${totalElevation.value.toStringAsFixed(2)} m',
          );
          print('🏢 Estimated floors: ${floorCount.value}');
        }
      } else {
        if (kDebugMode) {
          print(
            '⚠️ Ignored minor altitude change: ${diff.toStringAsFixed(2)} m',
          );
        }
      }
    });

    isTracking.value = true;
    isPaused.value = false;
    _secondsElapsed = 0;
    elapsedTime.value = '00:00:00';
    _trackingTimer?.cancel();
    _trackingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isTracking.value || isPaused.value) return;
      _secondsElapsed++;
      _updateElapsedTime();
    });
  }

  void countFloor() {
    floorCount.value = ((totalElevation.value / 2.4384) / 2).floor();
  }

  void pauseClimbTracking() {
    isPaused.value = true;
    _trackingTimer?.cancel();
    if (kDebugMode) print('⏸️ Tracking paused');
  }

  void resumeClimbTracking() {
    if (!isTracking.value) return;
    isPaused.value = false;
    _trackingTimer?.cancel();
    _trackingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isTracking.value || isPaused.value) return;
      _secondsElapsed++;
      _updateElapsedTime();
    });
    if (kDebugMode) print('▶️ Tracking resumed');
  }

  void stopClimbTracking() async {
    _trackingTimer?.cancel();
    isTracking.value = false;
    isPaused.value = false;
    try {
      await audioPlayer.stop();
      if (kDebugMode) {
        print('Audio playback stopped');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping audio: $e');
      }
      Get.snackbar('Audio Error', 'Failed to stop audio: $e');
    }
    _positionSub?.cancel();
    animationController.stop();
    _positionSub = null;

    final storage = ClimbingDataStorage();
    storage.saveClimbingData(0.0, currentDate.value);

    Get.dialog(
      AlertDialog(
        title: const Text('Tracking Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${currentDate.value}'),
            Text(
              'Height Climbed: ${totalElevation.value.toStringAsFixed(2)} meters',
            ),
            Text('Floor Climbed: ${floorCount.value} floors'),
            Text('Time Elapsed: ${elapsedTime.value}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              sendData(
                currentDate.value,
                elapsedTime.value,
                totalElevation.value,
              );
              Get.to(BottomNavbarScreen());
              _reset();
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  void _reset() {
    elapsedTime.value = '00:00:00';
    _secondsElapsed = 0;
    totalElevation.value = 0.0;
    floorCount.value = 0;
    altitudeRoute.clear();
    offset.value = 0.0;
    updateCurrentDate();
    if (kDebugMode) {
      print('OnClimbController: All tracking data reset to initial values');
    }
  }

  @override
  void onClose() {
    _trackingTimer?.cancel();
    audioPlayer.dispose();
    stopClimbTracking();
    animationController.dispose();
    super.onClose();
  }

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat("d MMMM, y").format(now);
  }

  void _updateElapsedTime() {
    final hours = (_secondsElapsed ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_secondsElapsed % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
    elapsedTime.value = '$hours:$minutes:$seconds';
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
        body: jsonEncode({"date": date, "time": time, "distance": distance}),
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
