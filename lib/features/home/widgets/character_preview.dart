import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/core/utils/constants/colors.dart';
import 'package:chrismiche/features/home/controller/change_character_controller.dart';
import 'package:chrismiche/features/home/widgets/change_character.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CharacterPreview extends StatelessWidget {
  const CharacterPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangeCharacterController controller = Get.put(
      ChangeCharacterController(),
    );

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        leading: Obx(
          () => Image.asset(
            controller.characterImagePath,
            height: 60,
            width: 60,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 60);
            },
          ),
        ),
        title: Text(
          "Change Character",
          style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.appPrimaryColor,
          size: 16,
        ),
        onTap: () async {
          final result = await Get.to(() => ChangeCharacter());
          if (result != null) {
            controller.selectedCharacter.value = result;
            controller.isSuperDress.value = result.contains('Alt');
          }
        },
      ),
    );
  }
}
