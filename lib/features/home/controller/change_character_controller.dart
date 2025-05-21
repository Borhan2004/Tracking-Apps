import 'package:get/get.dart';

class ChangeCharacterController extends GetxController {
  final RxString selectedGame = 'boy'.obs;
  void toggleGameSelection(String game) {
    if (selectedGame.value == game) {
      selectedGame.value = '';
    } else {
      selectedGame.value = game;
    }
  }
}
