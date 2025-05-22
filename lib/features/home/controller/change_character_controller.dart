import 'package:get/get.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart';

class ChangeCharacterController extends GetxController {
  final RxString selectedCharacter = 'girl'.obs;
  final RxBool isSuperDress = false.obs; 

  String get characterImagePath {
    return selectedCharacter.value == 'girl'
        ? ImagePath.gitlCharacter
        : ImagePath.boyCharacter;
  }

  String get characterName {
    if (selectedCharacter.value == 'girl') {
      return isSuperDress.value ? 'Violetina Super' : 'Violetina';
    } else {
      return isSuperDress.value ? 'Avijit Super' : 'Avijit';
    }
  }

  void toggleCharacter() {
    selectedCharacter.value =
        selectedCharacter.value == 'girl' ? 'boy' : 'girl';
  }

  void toggleCharacterDressUp() {
    isSuperDress.value = true; 
  }

  void toggleCharacterDressDown() {
    isSuperDress.value = false; 
  }

  void confirmSelection() {
    Get.back(result: selectedCharacter.value);
  }
}
