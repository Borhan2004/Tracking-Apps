import 'package:chrismiche/core/services/shared_preferences_data_helper.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var distanceToday = 0.0.obs;
  var floorsClimbed = 0.0.obs;
  var progressPercentage = 50.0.obs;
  var lastRun = "2 hr 11 mins, 8 KM, 6 Floors".obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await updateTrackingData();
    lastRun.value = "2 hr 11 mins, 8 KM, 6 Floors";
  }

  Future<void> updateTrackingData() async {
    final lastSavedData = await SharedPreferencesDataHelper.getLastSavedDistance();
    distanceToday.value = lastSavedData['distance'] ?? 0.0;

    final lastSavedDate = lastSavedData['date'] as String?;
    if (lastSavedDate != null && lastSavedDate.isNotEmpty) {
      final climbed = await SharedPreferencesDataHelper.getClimbedByDate(lastSavedDate);
      floorsClimbed.value = climbed ?? 0.0;
    } else {
      floorsClimbed.value = 0.0;
    }
  }

  Future<void> saveAndUpdateTrackingData(double distance, double climbed, String date) async {
    await SharedPreferencesDataHelper.saveDailyOngoingTracking(distance, climbed, date);
    await updateTrackingData();
  }
  void viewHistory() => Get.toNamed('/statistics');
  void changeCharacter() => Get.toNamed('/character-setup');
  void navigateToScreen(String route) => Get.toNamed(route);
}