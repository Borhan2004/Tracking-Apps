import 'package:get/get.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart';

class ChangeCharacterController extends GetxController {
  final RxString selectedCharacter = 'girl'.obs;

  String get characterImagePath {
    return selectedCharacter.value == 'girl'
        ? ImagePath.gitlCharacter
        : ImagePath.boyCharacter;
  }

  String get characterName {
    return selectedCharacter.value == 'girl' ? 'Violetina' : 'Avijit';
  }

  void toggleCharacter() {
    selectedCharacter.value =
        selectedCharacter.value == 'girl' ? 'boy' : 'girl';
  }

  void confirmSelection() {
    Get.back(result: selectedCharacter.value);
  }
}
