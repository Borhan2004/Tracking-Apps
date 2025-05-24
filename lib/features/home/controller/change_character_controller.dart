import 'package:get/get.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

class ChangeCharacterController extends GetxController {
  final RxString selectedCharacter = 'Elk'.obs;
  final RxBool isSuperDress = false.obs;

  static const List<String> mainCharacters = ['Elk', 'Ninja', 'Robo', 'Skate'];

  static const Map<String, String> altCharacterMap = {
    'Elk': 'elkAlt',
    'elkAlt': 'Elk',
    'Ninja': 'ninjaAlt',
    'ninjaAlt': 'Ninja',
    'Robo': 'roboAlt',
    'roboAlt': 'Robo',
    'Skate': 'skateAlt',
    'skateAlt': 'Skate',
  };

  static const String _characterKey =
      'selectedCharacter'; // Add key for character

  @override
  void onInit() {
    super.onInit();
    _loadSavedCharacter(); // Load saved character on initialization
  }

  // Load the saved character from SharedPreferences
  Future<void> _loadSavedCharacter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedCharacter = prefs.getString(_characterKey);
    if (savedCharacter != null) {
      selectedCharacter.value = savedCharacter;
      isSuperDress.value = savedCharacter.contains('Alt');
    }
  }

  // Save the selected character to SharedPreferences
  Future<void> _saveCharacter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_characterKey, selectedCharacter.value);
  }

  String get characterImagePath {
    switch (selectedCharacter.value) {
      case 'Elk':
        return ImagePath.elk;
      case 'elkAlt':
        return ImagePath.elkAlt;
      case 'Ninja':
        return ImagePath.ninja;
      case 'ninjaAlt':
        return ImagePath.ninjaAlt;
      case 'Robo':
        return ImagePath.robo;
      case 'roboAlt':
        return ImagePath.roboAlt;
      case 'Skate':
        return ImagePath.skate;
      case 'skateAlt':
        return ImagePath.skateAlt;
      default:
        return ImagePath.elk;
    }
  }

  String get characterName {
    switch (selectedCharacter.value) {
      case 'Elk':
        return 'Elk';
      case 'elkAlt':
        return 'Elk Super';
      case 'Ninja':
        return 'Ninja';
      case 'ninjaAlt':
        return 'Ninja Super';
      case 'Robo':
        return 'Robo';
      case 'roboAlt':
        return 'Robo Super';
      case 'Skate':
        return 'Skate';
      case 'skateAlt':
        return 'Skate Super';
      default:
        return 'Elk';
    }
  }

  String get characterDescription {
    switch (selectedCharacter.value) {
      case 'Elk':
        return 'Elk, the brave explorer in classic style!';
      case 'elkAlt':
        return 'Elk in a dazzling super outfit, ready for adventure!';
      case 'Ninja':
        return 'Ninja, the stealthy warrior in signature look!';
      case 'ninjaAlt':
        return 'Ninja in epic super gear, set to conquer challenges!';
      case 'Robo':
        return 'Robo, the high-tech hero in standard mode!';
      case 'roboAlt':
        return 'Robo in futuristic super armor, ready to dominate!';
      case 'Skate':
        return 'Skate, the cool skater in classic gear!';
      case 'skateAlt':
        return 'Skate in a radical super outfit, shredding the challenges!';
      default:
        return 'Elk, the brave explorer in classic style!';
    }
  }

  void toggleCharacter({required bool forward}) {
    String currentMainCharacter =
        selectedCharacter.value.contains('Alt')
            ? altCharacterMap[selectedCharacter.value]!
            : selectedCharacter.value;

    final currentIndex = mainCharacters.indexOf(currentMainCharacter);
    int newIndex;
    if (forward) {
      newIndex = (currentIndex + 1) % mainCharacters.length;
    } else {
      newIndex =
          (currentIndex - 1 + mainCharacters.length) % mainCharacters.length;
    }

    selectedCharacter.value = mainCharacters[newIndex];
    isSuperDress.value = false;
    update();
  }

  void toggleCharacterDressUp() {
    if (!isSuperDress.value &&
        altCharacterMap.containsKey(selectedCharacter.value)) {
      selectedCharacter.value = altCharacterMap[selectedCharacter.value]!;
      isSuperDress.value = true;
    }
    update();
  }

  void toggleCharacterDressDown() {
    if (isSuperDress.value &&
        altCharacterMap.containsKey(selectedCharacter.value)) {
      selectedCharacter.value = altCharacterMap[selectedCharacter.value]!;
      isSuperDress.value = false;
    }
    update();
  }

  void confirmSelection() {
    _saveCharacter(); // Save character when confirming selection
    Get.back(result: selectedCharacter.value);
  }
}
