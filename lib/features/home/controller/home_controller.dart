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

  void fetchInitialData() {
    distanceToday.value = 0.0;
    floorsClimbed.value = 0.0;
    lastRun.value = "2 hr 11 mins, 8 KM, 6 Floors";
  }

  void startNewRun() => Get.toNamed('/ongoing');
  void viewHistory() => Get.toNamed('/statistics');
  void changeCharacter() => Get.toNamed('/character-setup');
  void navigateToScreen(String route) => Get.toNamed(route);
}