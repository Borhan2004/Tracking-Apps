import 'package:chrismiche/core/utils/constants/colors.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/profile/controller/change_character_controller.dart';
import 'package:chrismiche/features/profile/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CharacterContainer extends StatelessWidget {
  CharacterContainer({super.key});

  final ChangeCharacterController controller = Get.put(
    ChangeCharacterController(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() {
                final isSelected = controller.selectedGame.value == "girl";
                return GestureDetector(
                  onTap: () => controller.toggleGameSelection("girl"),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.secondaryColor
                              : Color.fromARGB(255, 210, 221, 241),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Image.asset(
                          ImagePath.gitlCharacter,
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              Obx(() {
                final isSelected = controller.selectedGame.value == "boy";
                return GestureDetector(
                  onTap: () => controller.toggleGameSelection("boy"),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.secondaryColor
                              : Color.fromARGB(255, 210, 221, 241),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Image.asset(
                          ImagePath.boyCharacter,
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: 20),
          CustomButton(
            label: 'Change',
            buttonColor: Colors.blueAccent,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
