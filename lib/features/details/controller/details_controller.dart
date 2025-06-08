import 'dart:async';
import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:chrismiche/features/details/model/stat_data_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:chrismiche/core/services/shared_preferences_data_helper.dart';

class DetailsController extends GetxController {
  final RxDouble ongoingDistance = 0.0.obs;
  final RxDouble climbingDistance = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await SharedPreferencesDataHelper.clearLegacyClimbingData();
    // Update data immediately on init
    await _updateData();
    // Periodic update every 10 seconds
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _updateData();
    });
  }

  Future<void> _updateData() async {
    final String currentDate = DateFormat("d MMMM, y").format(DateTime.now());
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token != null) {
      await fetchMovementDistances(currentDate);
    }
    // Always update from SharedPreferences as fallback
    await updateDistance();
  }

  Future<void> updateDistance() async {
    try {
      final String today = DateFormat("d MMMM, y").format(DateTime.now());
      final double? distance = await SharedPreferencesDataHelper.getDistanceByDate(today);
      final double? climbed = await SharedPreferencesDataHelper.getClimbedByDate(today);

      ongoingDistance.value = distance ?? 0.0;
      climbingDistance.value = climbed ?? 0.0;

      if (kDebugMode) {
        print('DetailsController: Updated runMeter to ${ongoingDistance.value.toStringAsFixed(2)} meters, '
              'climbMeter to ${climbingDistance.value.toStringAsFixed(2)} meters for today: $today');
      }
    } catch (e) {
      if (kDebugMode) {
        print('DetailsController: Error retrieving data: $e');
      }
      ongoingDistance.value = 0.0;
      climbingDistance.value = 0.0;
    }
  }

  double parcent(double data) {
    return data - data.toInt();
  }

  Future<void> fetchMovementDistances(String date) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) return;

      final url = Uri.parse('${Urls.baseUrl}/movements/all-movements-history?date=$date');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final statData = StatDataModel.fromJson(jsonResponse);
        ongoingDistance.value = statData.ongoingMovements?.isNotEmpty == true
            ? statData.ongoingMovements!.first.distance ?? 0.0
            : 0.0;
        climbingDistance.value = statData.climbingMovements?.isNotEmpty == true
            ? statData.climbingMovements!.first.distance ?? 0.0
            : 0.0;
      } else {
        if (kDebugMode) {
          print('DetailsController: Failed to fetch movements: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('DetailsController: Error fetching movement data: $e');
      }
    }
  }
}