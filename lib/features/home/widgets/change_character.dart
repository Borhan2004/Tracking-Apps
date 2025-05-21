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
        padding: EdgeInsets.only(top: 65, left: 16, right: 16, bottom: 30),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Choose your character",
                textAlign: TextAlign.center,
                style: getTextStyle(
                  color: Color(0xFF333333),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 30),
            Obx(
              () => Text(
                _controller.characterName,
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            Obx(
              () => Image.asset(
                _controller.characterImagePath,
                fit: BoxFit.cover,
                height: 500,
                width: double.infinity,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomIconButton(
                  icon: Icons.arrow_back,
                  onPressed: _controller.toggleCharacter,
                ),
                CustomIconButton(
                  icon: Icons.check,
                  onPressed: _controller.confirmSelection,
                ),
                CustomIconButton(
                  icon: Icons.arrow_forward,
                  onPressed: _controller.toggleCharacter,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
