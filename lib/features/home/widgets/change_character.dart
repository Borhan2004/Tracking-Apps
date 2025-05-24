import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/features/home/controller/change_character_controller.dart';
import 'package:chrismiche/features/home/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeCharacter extends StatelessWidget {
  ChangeCharacter({super.key});

  final ChangeCharacterController _controller = Get.put(
    ChangeCharacterController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 65,
          left: 16,
          right: 16,
          bottom: 30,
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Choose your character",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Obx(
              () => Text(
                _controller.characterName,
                style: const TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => Text(
                _controller.characterDescription,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  color: const Color(0xFF555555),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => Image.asset(
                _controller.characterImagePath,
                fit: BoxFit.cover,
                height: 500,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Error loading image');
                },
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => _controller.toggleCharacter(forward: false),
                ),
                CustomIconButton(
                  icon: Icons.arrow_upward,
                  onPressed: _controller.toggleCharacterDressDown,
                ),
                CustomIconButton(
                  icon: Icons.check,
                  onPressed: _controller.confirmSelection,
                ),
                CustomIconButton(
                  icon: Icons.arrow_downward,
                  onPressed: _controller.toggleCharacterDressUp,
                ),
                CustomIconButton(
                  icon: Icons.arrow_forward,
                  onPressed: () => _controller.toggleCharacter(forward: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
