import 'package:chrismiche/core/localization/end_points.dart' show Urls;
import 'package:chrismiche/core/services/shared_preferences_helper.dart' show SharedPreferencesHelper;
import 'package:chrismiche/features/home/model/movement_history.dart' show MovementHistoryResponse;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  var distanceToday = 0.0.obs;
  var floorsClimbed = 0.0.obs;
  var progressPercentage = 50.0.obs;
  var lastRun = "2 hr 11 mins, 8 KM, 6 Floors".obs;

  @override
  void onInit() {
    super.onInit();
    final today = DateFormat('d MMMM, yyyy').format(DateTime.now());
    fetchMovementData(today);
  }

  Future<void> fetchMovementData(String date) async {
    try {
      String? token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        if (kDebugMode) {
          print("No access token found");
        }
        return;
      }
      final url = '${Urls.baseUrl}/movements/all-movements-history?date=$date';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        } 
        ); 

        if (kDebugMode) {
          print("The response of home data is ${response.body}");
        }

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = MovementHistoryResponse.fromJson(decoded);

        // Use first entry from lists if available
        distanceToday.value = data.ongoingMovements?.isNotEmpty == true
            ? data.ongoingMovements!.first.distance ?? 0.0
            : 0.0;

        floorsClimbed.value = data.climbingMovements?.isNotEmpty == true
            ? data.climbingMovements!.first.distance ?? 0.0
            : 0.0;
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching movement data: $e");
    }
  }

  void startNewRun() => Get.toNamed('/ongoing');
  void viewHistory() => Get.toNamed('/statistics');
  void changeCharacter() => Get.toNamed('/character-setup');
  void navigateToScreen(String route) => Get.toNamed(route);
}
