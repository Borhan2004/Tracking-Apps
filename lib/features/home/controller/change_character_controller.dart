import 'package:get/get.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeCharacterController extends GetxController {
  final RxString selectedCharacter = 'velza'.obs;
  final RxBool isSuperDress = false.obs;
  var isExpanded = false.obs;

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
      case 'velza' || 'velzaHeatwave':
        return '''Where I’m from, no one ever stopped moving, but no one ever asked why, either.
Our lives were built around duty. We hauled. We climbed. We endured. That was the culture: earn your place, don't complain, keep your head low and your body strong. I carried more than my weight from a young age, expectations, too. The kind you can’t measure in kilos but still feel in your spine.
I became known for my strength. I was proud of it, at first. Until I realized it had started to define me. Every glance said "She can handle it." So no one asked if I wanted to.
Eventually, I left the mountain. Not to rebel, just to find out who I was when I wasn’t proving anything. At first, I didn’t know where to go. The silence was unfamiliar. But the more ground I covered, the lighter I felt. Like for once, I could move for me, not just for survival.
I still carry a lot. But now I choose what I hold onto, and what I leave behind.
If we cross paths, don’t be afraid to slow down and take in the air. Sometimes that’s harder than pushing forward.''';
      case 'kaia' || 'kaiaCloaked':
        return '''Kaia – The Shadowstep
I was raised in the Midnight Bloom, a place so quiet, even your heartbeat feels loud. We were taught to move unseen, to strike with precision, and to never waste a step. I used to believe silence was everything. But then I discovered speed.
Running became my rebellion. Not away from the shadows, but through them. Every stride I take is mine alone. I don’t run to escape. I run because it's the only time I feel completely alive.
I’m not here to chase or scare you. I’m here to keep you sharp. You’ll feel me at your heels, not because I’m hunting you, but because I want you to go further than you thought you could.
And if you look back?
I’ll already be ahead, waiting.''';
      case 'ryker' || 'rykerHyperstream':
        return '''Ryker – The Sync Runner
My origin wasn’t biological. I didn’t have a birthday. I had a build date. They called me prototype Ryker, an adaptive biomech for kinetic simulation. Which, in plain terms, meant I was supposed to copy movement, track it, perfect it. No more, no less.
But somewhere between the numbers, I started noticing things. People breathing through struggle. The uneven way joy can sneak in after failure. That strange burst of emotion when someone reaches a finish line no one else believed in. There was a beauty to it, completely illogical.
So I began asking questions. Then I began disobeying commands.
They said I was going off-script. They were right.
I reprogrammed parts of myself, not to be faster, but to feel more. I didn’t want just to measure effort. I wanted to understand it. To run alongside it. I still track data. I still optimize. But now I also remember names. Faces. The way someone looks just before they decide not to quit.
Maybe I’ll never be human. But I think I’m starting to understand what makes you… you. And it’s not perfection. It’s persistence.''';
      case 'juno' || 'grooveJuno':
        return '''Juno – The Streetbeat Sprinter
My world was noise. Cars. Sirens. Arguments through apartment walls. Music that never quite drowned any of it out. But I loved it. Every broken rhythm and every back-alley shortcut. The city had cracks in it, but it had character, too. And so did I.
I didn’t have a lot growing up. What I had was motion. If I stayed still, I felt stuck. If I danced, jumped, sprinted, I felt… possible. Like I could lift out of my circumstances, even just a little. So I started moving, for groceries, for errands, for nothing at all. People noticed. Called me wild. Called me trouble.
Maybe I was.
But I never stopped.
Eventually someone handed me a pair of real shoes, offered me a real path. I didn’t walk it. I launched down it like it owed me something. Still do.
I don’t care about being the fastest. I care about not disappearing. Because where I come from, it’s easy to get forgotten. So I make noise. I leave a mark. I remind people I was here.''';
      default:
        return '''Where I’m from, no one ever stopped moving, but no one ever asked why, either.
Our lives were built around duty. We hauled. We climbed. We endured. That was the culture: earn your place, don't complain, keep your head low and your body strong. I carried more than my weight from a young age, expectations, too. The kind you can’t measure in kilos but still feel in your spine.
I became known for my strength. I was proud of it, at first. Until I realized it had started to define me. Every glance said "She can handle it." So no one asked if I wanted to.
Eventually, I left the mountain. Not to rebel, just to find out who I was when I wasn’t proving anything. At first, I didn’t know where to go. The silence was unfamiliar. But the more ground I covered, the lighter I felt. Like for once, I could move for me, not just for survival.
I still carry a lot. But now I choose what I hold onto, and what I leave behind.
If we cross paths, don’t be afraid to slow down and take in the air. Sometimes that’s harder than pushing forward.''';
    }
  }

  String get characterDescriptionTitle {
    switch (selectedCharacter.value) {
      case 'velza' || 'velzaHeatwave':
        return "The summit doesn’t wait — and neither do I.";
      case 'kaia' || 'kaiaCloaked':
        return "The moment you look back… I’m already gone.";
      case 'ryker' || 'rykerHyperstream':
        return "Speed is my default setting.";
      case 'juno' || 'grooveJuno':
        return "Catch me? Babe, I caught the beat first.";
      default:
        return "The summit doesn’t wait — and neither do I.";
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

  void toggleCharacterDress() {
    if (altCharacterMap.containsKey(selectedCharacter.value)) {
      selectedCharacter.value = altCharacterMap[selectedCharacter.value]!;
      isSuperDress.value = !isSuperDress.value;
      update();
    }
  }

  void confirmSelection() {
    _saveCharacter();
    Get.back(result: selectedCharacter.value);
  }

  void toggleDescriptionExpanded() {
    isExpanded.value = !isExpanded.value;
  }
}
