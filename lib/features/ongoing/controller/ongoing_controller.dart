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


class OngoingController extends GetxController with GetTickerProviderStateMixin {
 final totalDistance = 0.0.obs;
  final currentDate = ''.obs;
  final isMoving = false.obs;
  final scrollController = ScrollController();
  Timer? resetTimer;
  Position? _lastPosition;

  double scrollSpeedPerMeter = 2; // Adjust for speed of scroll

  @override
  void onInit() {
    super.onInit();
    _initLocation();
    _startDateListener();
  }

  void _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) await Geolocator.openLocationSettings();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
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

    if (kDebugMode) {
      print("Raw distance: $distance");
    }

    // Accept distances between 1.5 and 30 meters
    if (distance >= 1.5 ) {
      if (kDebugMode) {
        print("Valid movement detected: $distance");
      }
      isMoving.value = true;
      totalDistance.value += distance;
      _scrollBackground(distance);
    } else {
      if (kDebugMode) {
        print("Ignored movement: $distance");
      }
      isMoving.value = false;
    }
  }
  _lastPosition = newPosition;
}



  void _scrollBackground(double distance) {
    if (!scrollController.hasClients) return;

    double scrollAmount = distance * scrollSpeedPerMeter;
    double newOffset = scrollController.offset + scrollAmount;
    double maxExtent = scrollController.position.maxScrollExtent;

    if (newOffset >= maxExtent) {
      scrollController.jumpTo(0); // Restart from beginning
    } else {
      scrollController.animateTo(
        newOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  void _startDateListener() {
  _updateDate();
  resetTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
    final now = DateTime.now();
    final today = "${now.year}-${now.month}-${now.day}";

    if (today != currentDate.value) {
      // Format date as "06 June, 2025"
      final formattedDate = SharedPreferencesDataHelper.formatDate(DateTime.now().subtract(const Duration(days: 1)));

      final distanceToSave = totalDistance.value;

      // Get token
      String? token = await SharedPreferencesHelper.getAccessToken();

      if (token != null) {
        await sendData(formattedDate, distanceToSave);
      } else {
        await SharedPreferencesDataHelper.saveDailyTracking(distanceToSave, formattedDate);
      }

      totalDistance.value = 0.0;
      _updateDate();
    }
  });
}


  void _updateDate() {
    final now = DateTime.now();
    currentDate.value = "${now.year}-${now.month}-${now.day}";
  }

  @override
  void onClose() {
    resetTimer?.cancel();
    super.onClose();
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

      if (response.statusCode != 200 && kDebugMode) {
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
