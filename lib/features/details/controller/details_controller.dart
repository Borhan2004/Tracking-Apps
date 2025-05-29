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
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      String? token = await SharedPreferencesHelper.getAccessToken();
      final String currentDate = DateFormat('dd MMMM, yyyy').format(DateTime.now());
      if (token == null) {
        await updateDistance();
        if (kDebugMode) {
          print('DetailsController: Token is null, updated distances from SharedPreferences');
        }
      } else {
        await fetchMovementDistances(currentDate);
        if (kDebugMode) {
          print('DetailsController: Token found, fetched distances from API for date: $currentDate');
        }
      }
    });
  }

  Future<void> updateDistance() async {
    try {
      final String today = DateFormat("d MMMM, y").format(DateTime.now());
      final double? distance =
          await SharedPreferencesDataHelper.getDistanceByDate(today);
      final double? climbed =
          await SharedPreferencesDataHelper.getClimbedByDate(today);

      if (distance != null) {
        ongoingDistance.value = distance;
        debugPrint(
          'DetailsController: Updated runMeter to ${ongoingDistance.value.toStringAsFixed(2)} meters for today: $today',
        );
      } else {
        ongoingDistance.value = 0.0;
        debugPrint(
          'DetailsController: No distance data found for today: $today',
        );
      }

      if (climbed != null) {
        climbingDistance.value = climbed;
        debugPrint(
          'DetailsController: Updated climbMeter to ${climbingDistance.value.toStringAsFixed(2)} meters for today: $today',
        );
      } else {
        climbingDistance.value = 0.0;
        debugPrint(
          'DetailsController: No climbed data found for today: $today',
        );
      }
    } catch (e) {
      debugPrint('DetailsController: Error retrieving data: $e');
      ongoingDistance.value = 0.0;
      climbingDistance.value = 0.0;
    }
  }

  double parcent(double data) {
    return data - data.toInt();
  }

  Future<void> fetchMovementDistances(String date) async {
    try {
      String? token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        print('Token is null');
        return;
      }

      final url = Uri.parse(
        '${Urls.baseUrl}/movements/all-movements-history?date=$date',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("///////The response of the statastic part is ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final statData = StatDataModel.fromJson(jsonResponse);
        ongoingDistance.value =
            statData.ongoingMovements?.isNotEmpty == true
                ? statData.ongoingMovements!.first.distance ?? 0.0
                : 0.0;

        climbingDistance.value =
            statData.climbingMovements?.isNotEmpty == true
                ? statData.climbingMovements!.first.distance ?? 0.0
                : 0.0;
      } else {
        print('Failed to fetch movements: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching movement data: $e');
    }
  } 


  
}
