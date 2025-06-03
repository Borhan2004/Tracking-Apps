import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:chrismiche/core/localization/end_points.dart' show Urls;
import 'package:chrismiche/core/services/shared_preferences_helper.dart'
    show SharedPreferencesHelper;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:chrismiche/core/services/tracking_data_storage.dart';
import 'package:chrismiche/features/details/controller/details_controller.dart';
import 'package:geolocator/geolocator.dart';

class MarathonController extends GetxController
    with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;
  late AudioPlayer audioPlayer;

  final double imageWidth = 1000;
  final double viewportWidth = 400;
  double maxScrollExtent = 0;
  final RxBool isRunning = false.obs;

  RxDouble totalDistance = 0.0.obs;
  Rx<Duration> elapsedTime = Duration.zero.obs;
  Timer? _timer;
  Timer? _restartTimer;
  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;

  @override
  void onInit() async {
    super.onInit();
    scrollController = ScrollController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    audioPlayer = AudioPlayer();
    audioPlayer.setSource(AssetSource('music/Running.wav'));

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

    updateCurrentDate();
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (isRunning.value) {
        _checkDateChangeAndReset();
      }
    });

    restartAnimationAtSpecificTime(const TimeOfDay(hour: 0, minute: 0));
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

  void startAnimation() async {
    if (!await _checkAndRequestLocationPermission()) return;

    maxScrollExtent = imageWidth - viewportWidth;
    if (maxScrollExtent <= 0) return;
    animationController.forward();
    isRunning.value = true;
    await audioPlayer.setSource(AssetSource('music/Running.wav'));
    await audioPlayer.resume();

    _startDistanceUpdate();
    _startTimer();
  }

  void stopAnimation() async {
    animationController.stop();
    isRunning.value = false;
    await audioPlayer.stop();
    _stopDistanceUpdate();
    _stopTimer();

    try {
      await TrackingDataStorage.saveDailyTracking(
        totalDistance.value,
        currentDate.value,
      );
      debugPrint(
        'Stop: Saved totalDistance: ${totalDistance.value} for ${currentDate.value}',
      );

      if (Get.isRegistered<DetailsController>()) {
        final detailsController = Get.find<DetailsController>();
        await detailsController.updateDistance();
        debugPrint(
          'Stop: Notified DetailsController to update meters to ${totalDistance.value}',
        );
      }

      showDateAndDistance();

      totalDistance.value = 0.0;
      elapsedTime.value = Duration.zero;
      debugPrint('Stop: Reset totalDistance to 0.0 and elapsedTime to 0');
    } catch (e) {
      debugPrint('Stop: Error saving distance: $e');
      Get.snackbar('Error', 'Failed to save distance: $e');
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    animationController.dispose();
    audioPlayer.dispose();
    _stopDistanceUpdate();
    _stopTimer();
    _restartTimer?.cancel();
    super.onClose();
  }

  RxString currentDate = ''.obs;

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat("d MMMM, y").format(now);
  }

  void showDateAndDistance() {
    Get.dialog(
      AlertDialog(
        title: const Text('Marathon Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${currentDate.value}'),
            Text('Distance: ${totalDistance.value.toStringAsFixed(2)} meters'),
            Text('Steps: ${(totalDistance.value / 0.762).toInt()}'),
            Text('Elapsed Time: ${_formatDuration(elapsedTime.value)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              sendData(
                currentDate.value,
                _formatDuration(elapsedTime.value),
                totalDistance.value,
              );
              Get.back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _startDistanceUpdate() {
    _lastPosition = null;
    _positionStream?.cancel();
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
  }

  void _stopDistanceUpdate() {
    _positionStream?.cancel();
    _positionStream = null;
    _lastPosition = null;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isRunning.value) {
        timer.cancel();
        return;
      }
      elapsedTime.value += const Duration(seconds: 1);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _reset() {
    totalDistance.value = 0.0;
    elapsedTime.value = Duration.zero;
  }

  final RxString _lastSavedDate = ''.obs;

  void _checkDateChangeAndReset() async {
    final now = DateTime.now();
    final currentFormattedDate = DateFormat("d, MMMM, y").format(now);

    if (_lastSavedDate.value.isEmpty) {
      _lastSavedDate.value = currentFormattedDate;
      return;
    }

    if (_lastSavedDate.value != currentFormattedDate) {
      try {
        await TrackingDataStorage.saveDailyTracking(
          totalDistance.value,
          _lastSavedDate.value,
        );
        debugPrint(
          'Date change: Saved distance: ${totalDistance.value} for ${_lastSavedDate.value}',
        );

        if (Get.isRegistered<DetailsController>()) {
          final detailsController = Get.find<DetailsController>();
          await detailsController.updateDistance();
          debugPrint(
            'Date change: Notified DetailsController to update meters to ${totalDistance.value}',
          );
        }
      } catch (e) {
        debugPrint('Date change: Error saving distance: $e');
        Get.snackbar('Error', 'Failed to save distance: $e');
      }
      _reset();
      _lastSavedDate.value = currentFormattedDate;
    }
  }

  void restartAnimationAtSpecificTime(TimeOfDay restartTime) {
    _restartTimer?.cancel();
    _restartTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

      if (currentTime.hour == restartTime.hour &&
          currentTime.minute == restartTime.minute) {
        stopAnimation();
        _reset();
        startAnimation();
        Get.snackbar(
          'Animation Restarted',
          'Running animation restarted at $restartTime.',
        );
      }
    });
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
      final url = '${Urls.baseUrl}/instant-movements/tracking-run';

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
