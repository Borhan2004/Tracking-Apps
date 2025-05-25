import 'package:get/get.dart';
import 'package:chrismiche/core/services/tracking_data_storage.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class DetailsController extends GetxController {
  final RxDouble meters = 0.0.obs; // Initialize to 0.0, updated in onInit

  @override
  void onInit() async {
    super.onInit();
    // Fetch the last saved distance from SharedPreferences
    await updateMeters();
  }

  // Method to update meters with the latest saved distance
  Future<void> updateMeters() async {
    try {
      final lastSaved = await TrackingDataStorage.getLastSavedDistance();
      meters.value = lastSaved['distance'] as double;
      debugPrint('DetailsController: Updated meters to ${meters.value} meters for date: ${lastSaved['date']}');
    } catch (e) {
      debugPrint('DetailsController: Error retrieving last saved distance: $e');
      meters.value = 0.0; // Default to 0.0 on error
    }
  }

  double parcent(double data) {
    return data - data.toInt();
  }
}