import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:chrismiche/core/services/shared_preferences_data_helper.dart';

class DetailsController extends GetxController {
  final RxDouble meters = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await SharedPreferencesDataHelper.clearLegacyClimbingData();
    await updateMeters();
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      await updateMeters();
    });
  }

  Future<void> updateMeters() async {
    try {
      final String today = DateFormat("d, MMMM, y").format(DateTime.now());
      final double? distance = await SharedPreferencesDataHelper.getDistanceByDate(today);

      if (distance != null) {
        meters.value = distance;
        debugPrint(
          'DetailsController: Updated meters to ${meters.value.toStringAsFixed(2)} meters for today: $today',
        );
      } else {
        meters.value = 0.0;
        debugPrint('DetailsController: No distance data found for today: $today');
      }
    } catch (e) {
      debugPrint('DetailsController: Error retrieving distance: $e');
      meters.value = 0.0;
    }
  }

  double parcent(double data) {
    return data - data.toInt();
  }
}
