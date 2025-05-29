import 'package:get/get.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeCharacterController extends GetxController {
  final RxString selectedCharacter = 'velza'.obs;
  final RxBool isSuperDress = false.obs;

  static const List<String> mainCharacters = ['velza', 'kaia', 'ryker', 'juno'];

  static const Map<String, String> altCharacterMap = {
    'velza': 'velzaHeatwave',
    'velzaHeatwave': 'velza',
    'kaia': 'kaiaCloaked',
    'kaiaCloaked': 'kaia',
    'ryker': 'rykerHyperstream',
    'rykerHyperstream': 'ryker',
    'juno': 'grooveJuno',
    'grooveJuno': 'juno',
  };

  static const String _characterKey = 'selectedCharacter';

  @override
  void onInit() {
    super.onInit();
    _loadSavedCharacter();
  }

  Future<void> _loadSavedCharacter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedCharacter = prefs.getString(_characterKey);
    if (savedCharacter != null) {
      selectedCharacter.value = savedCharacter;
      isSuperDress.value = savedCharacter.contains('Alt');
    }
  }

  

  Future<void> _saveCharacter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_characterKey, selectedCharacter.value);
  }

  String get characterImagePath {
    switch (selectedCharacter.value) {
      case 'velza':
        return ImagePath.velza;
      case 'velzaHeatwave':
        return ImagePath.velzaHeatwave;
      case 'kaia':
        return ImagePath.kaia;
      case 'kaiaCloaked':
        return ImagePath.kaiaCloaked;
      case 'ryker':
        return ImagePath.ryker;
      case 'rykerHyperstream':
        return ImagePath.rykerHyperstream;
      case 'juno':
        return ImagePath.juno;
      case 'grooveJuno':
        return ImagePath.grooveJuno;
      default:
        return ImagePath.velza;
    }
  }

  String get elevatorCharacterImagePath {
    switch (selectedCharacter.value) {
      case 'velza':
        return ImagePath.velzaElevator;
      case 'velzaHeatwave':
        return ImagePath.velzaHeatwaveElevator;
      case 'kaia':
        return ImagePath.kaiaElevator;
      case 'kaiaCloaked':
        return ImagePath.kaiaCloakedElevator;
      case 'ryker':
        return ImagePath.rykerElevator;
      case 'rykerHyperstream':
        return ImagePath.rykerHyperstreamElevator;
      case 'juno':
        return ImagePath.junoElevator;
      case 'grooveJuno':
        return ImagePath.grooveJunoElevator;
      default:
        return ImagePath.velzaElevator;
    }
  }

  String get characterName {
    switch (selectedCharacter.value) {
      case 'velza':
        return 'Velza';
      case 'velzaHeatwave':
        return 'Velza Heatwave';
      case 'kaia':
        return 'Kaia';
      case 'kaiaCloaked':
        return 'Kaia Cloaked';
      case 'ryker':
        return 'Ryker';
      case 'rykerHyperstream':
        return 'Ryker Hyperstream';
      case 'juno':
        return 'Juno';
      case 'grooveJuno':
        return 'Groove Juno';
      default:
        return 'Velza';
    }
  }

  String get characterDescription {
    switch (selectedCharacter.value) {
      case 'velza':
        return 'Velza, the brave explorer in classic style!';
      case 'velzaHeatwave':
        return 'Velza Heatwave in a dazzling super outfit, ready for adventure!';
      case 'kaia':
        return 'Kaia, the stealthy warrior in signature look!';
      case 'kaiaCloaked':
        return 'Kaia Cloaked in epic super gear, set to conquer challenges!';
      case 'ryker':
        return 'Ryker, the high-tech hero in standard mode!';
      case 'rykerHyperstream':
        return 'Rryker Hyperstream in futuristic super armor, ready to dominate!';
      case 'juno':
        return 'Juno, the cool skater in classic gear!';
      case 'grooveJuno':
        return 'Groove Juno in a radical super outfit, shredding the challenges!';
      default:
        return 'Velza, the brave explorer in classic style!';
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
    _saveCharacter();
    Get.back(result: selectedCharacter.value);
  }
}
