import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/core/utils/constants/colors.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart' show ImagePath;
import 'package:chrismiche/features/home/widgets/change_character.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CharacterPreview extends StatelessWidget {
  const CharacterPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Image.asset(ImagePath.gitlCharacter, height: 60, width: 60),
        title: Text(
          "Change Character",
          style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.appPrimaryColor,
          size: 16,
        ),
        onTap: () {
          Get.to(() => ChangeCharacter());
        },
      ),
    );
  }
}
