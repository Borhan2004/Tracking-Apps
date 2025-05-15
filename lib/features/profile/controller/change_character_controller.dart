import 'package:get/get.dart';

class ChangeCharacterController extends GetxController {
  final RxString selectedGame = ''.obs;

  void toggleGameSelection(String game) {
    if (selectedGame.value == game) {
      selectedGame.value = '';
    } else {
      selectedGame.value = game;
    }
  }

  @override
  void onInit() {
    super.onInit();
    selectedGame.value = 'girl';
  }
}
