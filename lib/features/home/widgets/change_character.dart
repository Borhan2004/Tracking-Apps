import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/home/controller/change_character_controller.dart';
import 'package:chrismiche/features/home/widgets/custom_icon_button.dart';
import 'package:chrismiche/features/profile/widget/custom_button.dart';
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              ImagePath.characterBackground,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomIconButton(
                        icon: Icons.arrow_back_ios,
                        onPressed:
                            () => _controller.toggleCharacter(forward: false),
                      ),
                      CustomIconButton(
                        icon: Icons.check,
                        onPressed: _controller.confirmSelection,
                      ),
                      CustomIconButton(
                        icon: Icons.arrow_forward_ios,
                        onPressed:
                            () => _controller.toggleCharacter(forward: true),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    label: 'Alternative Outfit',
                    buttonColor: Colors.teal,
                    onTap: () {
                      _controller.toggleCharacterDress();
                    },
                  ),
                  SizedBox(height: 15),
                  Obx(
                    () => Text(
                      _controller.characterDescriptionTitle,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        color: const Color(0xFF555555),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.black),
                  const SizedBox(height: 10),
                  Obx(() {
                    final isExpanded = _controller.isExpanded.value;
                    return GestureDetector(
                      onTap: _controller.toggleDescriptionExpanded,
                      child: Column(
                        children: [
                          Text(
                            _controller.characterDescription,
                            textAlign: TextAlign.center,
                            maxLines: isExpanded ? null : 2,
                            overflow:
                                isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                            style: getTextStyle(
                              color: const Color(0xFF555555),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isExpanded ? 'Show less ▲' : 'Read more ▼',
                            style: getTextStyle(
                              color: Colors.blueAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
