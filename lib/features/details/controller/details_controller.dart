import 'dart:async';
import 'package:get/get.dart';
import 'package:chrismiche/core/services/shared_preferences_data_helper.dart';
import 'package:flutter/foundation.dart';

class DetailsController extends GetxController {
  final RxDouble meters = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await updateMeters();
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      await updateMeters();
    });
  }

  Future<void> updateMeters() async {
    try {
      final lastSaved =
          await SharedPreferencesDataHelper.getLastSavedDistance();
      meters.value = lastSaved['distance'] as double;
      debugPrint(
        'DetailsController: Updated meters to ${meters.value} meters for date: ${lastSaved['date']}',
      );
    } catch (e) {
      debugPrint('DetailsController: Error retrieving last saved distance: $e');
      meters.value = 0.0;
    }
  }

  double parcent(double data) {
    return data - data.toInt();
  }
}
