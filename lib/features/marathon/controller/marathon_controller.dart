import 'dart:async';
import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:chrismiche/core/services/tracking_data_storage.dart';
import 'package:chrismiche/features/details/controller/details_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class MarathonController extends GetxController with GetTickerProviderStateMixin {
  final RxDouble totalDistance = 0.0.obs;
  final RxInt steps = 0.obs;
  final RxBool isTracking = false.obs;
  late AudioPlayer audioPlayer;
  late AnimationController animationController;
  final RxDouble offset = 0.0.obs;
  double scrollSpeed = 50.0;
  Rx<Duration> elapsedTime = Duration.zero.obs;
  final RxInt timerSeconds = 60.obs;
  Timer? _restartTimer;
  Timer? _dateCheckTimer;
  Timer? _timer;
  Timer? _countdownTimer;
  final RxString currentDate = ''.obs;
  final RxString _lastSavedDate = ''.obs;

  StreamSubscription<StepCount>? _stepCountSubscription;
  int _initialStepCount = -1;
  static const double averageStepLength = 0.762;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    );
    animationController.addListener(() {
      final elapsed = animationController.lastElapsedDuration?.inMilliseconds ?? 0;
      offset.value = (elapsed / 1000) * scrollSpeed;
    });
    audioPlayer = AudioPlayer();
    audioPlayer.setSource(AssetSource('music/Running.wav'));

    updateCurrentDate();
    _startDateCheckTimer();
    _requestPermissions();
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

  void setScrollSpeed(double imageWidth, double seconds) {
    scrollSpeed = imageWidth / seconds;
    update();
  }

  void start() {
    if (!animationController.isAnimating) {
      animationController.repeat();
    }
  }

  void stop() {
    animationController.stop();
  }

  void startTracking() async {
    await audioPlayer.setSource(AssetSource('music/Running.wav'));
    await audioPlayer.resume();
    bool permissionGranted = await Permission.activityRecognition.isGranted;
    if (!permissionGranted) {
      Get.snackbar("Permission Denied", "Activity recognition permission is required.");
      if (kDebugMode) {
        print("❌ Activity recognition permission not granted.");
      }
      return;
    }

    if (kDebugMode) {
      print('✅ Activity recognition permission granted');
    }

    await _stepCountSubscription?.cancel();
    _stepCountSubscription = Pedometer.stepCountStream.listen(
      _handleStepCount,
      onError: (error) {
        if (kDebugMode) {
          print("❌ Error in step count stream: $error");
        }
        Get.snackbar('Pedometer Error', 'Failed to access pedometer: $error');
      },
      cancelOnError: false,
    );

    isTracking.value = true;
    _startTimer();
    _startCountdownTimer(); 
  }

  void _handleStepCount(StepCount event) {
    if (_initialStepCount == -1) {
      _initialStepCount = event.steps;
      if (kDebugMode) {
        print('📍 Initial step count set: $_initialStepCount');
      }
      return;
    }

    int stepsSinceStart = event.steps - _initialStepCount;

    if (stepsSinceStart < 0) {
      _initialStepCount = event.steps;
      stepsSinceStart = 0;
      if (kDebugMode) {
        print('📍 Step count reset: new initialStepCount=$_initialStepCount');
      }
    }

    if (stepsSinceStart >= steps.value) {
      steps.value = stepsSinceStart;
      totalDistance.value = Precision(stepsSinceStart * averageStepLength).toPrecision(2);
      if (kDebugMode) {
        print('📍 Step event: raw=${event.steps}, stepsSinceStart=$stepsSinceStart, totalSteps=${steps.value}, distance=${totalDistance.value}');
      }
    } else {
      if (kDebugMode) {
        print('⚠️ No step increase: stepsSinceStart=$stepsSinceStart, totalSteps=${steps.value}');
      }
    }
  }

  void stopTracking() async {
    await audioPlayer.stop();
    _stepCountSubscription?.cancel();
    _stepCountSubscription = null;
    isTracking.value = false;
    _stopTimer();
    _stopCountdownTimer(); 
    try {
      await TrackingDataStorage.saveDailyTracking(totalDistance.value, currentDate.value);
      if (kDebugMode) {
        print('Stop: Saved totalDistance: ${totalDistance.value} for ${currentDate.value}');
      }

      if (Get.isRegistered<DetailsController>()) {
        final detailsController = Get.find<DetailsController>();
        await detailsController.updateDistance();
        if (kDebugMode) {
          print('Stop: Notified DetailsController to update meters to ${totalDistance.value}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Stop: Error saving distance: $e');
      }
      Get.snackbar('Error', 'Failed to save distance: $e');
    }
  }

  void resetTracking() {
    stopTracking();
    totalDistance.value = 0.0;
    steps.value = 0;
    _initialStepCount = -1;
    elapsedTime.value = Duration.zero;
    timerSeconds.value = 60; 
  }

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat("d MMMM, y").format(now);
  }

  void _startDateCheckTimer() {
    _dateCheckTimer?.cancel();
    _dateCheckTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkDateChangeAndReset();
    });
  }

  void _checkDateChangeAndReset() async {
    final now = DateTime.now();
    final currentFormattedDate = DateFormat("d MMMM, y").format(now);

    if (_lastSavedDate.value.isEmpty) {
      _lastSavedDate.value = currentFormattedDate;
      updateCurrentDate();
      return;
    }

    if (_lastSavedDate.value != currentFormattedDate) {
      try {
        await TrackingDataStorage.saveDailyTracking(totalDistance.value, _lastSavedDate.value);
        if (kDebugMode) {
          print('Date change: Saved distance: ${totalDistance.value} for ${_lastSavedDate.value}');
        }

        if (Get.isRegistered<DetailsController>()) {
          final detailsController = Get.find<DetailsController>();
          await detailsController.updateDistance();
          if (kDebugMode) {
            print('Date change: Notified DetailsController to update meters to ${totalDistance.value}');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Date change: Error saving distance: $e');
        }
        Get.snackbar('Error', 'Failed to save distance: $e');
      }
      resetTracking();
      _lastSavedDate.value = currentFormattedDate;
      updateCurrentDate();
    }
  }

  void showDateAndDistance() {
    Get.dialog(
      AlertDialog(
        title: const Text('Running Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${currentDate.value}'),
            Text('Distance: ${totalDistance.value.toStringAsFixed(2)} meters'),
            Text('Steps: ${steps.value}'),
            Text('Elapsed Time: ${formatDuration(elapsedTime.value)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              sendData(
                currentDate.value,
                formatDuration(elapsedTime.value),
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

  void restartAnimationAtSpecificTime(TimeOfDay restartTime) {
    _restartTimer?.cancel();
    _restartTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

      if (currentTime.hour == restartTime.hour && currentTime.minute == restartTime.minute) {
        stop();
        resetTracking();
        start();
        Get.snackbar('Animation Restarted', 'Running animation restarted at $restartTime.');
      }
    });
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isTracking.value) {
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

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    timerSeconds.value = 60;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isTracking.value) {
        timer.cancel();
        return;
      }
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        timerSeconds.value = 60; 
      }
    });
  }

  void _stopCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    timerSeconds.value = 60;
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
        print("The response of sending running data is ${response.body}");
      }

      if (response.statusCode == 200) {
        EasyLoading.showSuccess("Data sent successfully");
      } else {
        EasyLoading.showError("Failed to send data: ${response.statusCode}");
        if (kDebugMode) {
          print("Error sending running data: ${response.statusCode}");
        }
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
      if (kDebugMode) {
        print("The error for sending running data is $e");
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    _restartTimer?.cancel();
    _dateCheckTimer?.cancel();
    _timer?.cancel();
    _countdownTimer?.cancel(); 
    _stepCountSubscription?.cancel();
    animationController.dispose();
    audioPlayer.dispose();
    stopTracking();
    super.onClose();
  }
}

extension Precision on double {
  double toPrecision(int fractionDigits) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}