import 'package:chrismiche/core/utils/constants/colors.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/profile/controller/personal_info_controller.dart' show PersonalInfoController;
import 'package:chrismiche/features/profile/widget/custom_button.dart';
import 'package:chrismiche/features/profile/widget/personal_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProfilePageContainer extends StatelessWidget {
   ProfilePageContainer({super.key});

  final PersonalInfoController controller = Get.find<PersonalInfoController>(); 

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(84),
              child: Image.asset(
                ImagePath.userPerson,
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
            ),
            PersonalInfo(),
            SizedBox(height: 10),
            CustomButton(
              label: 'Log Out',
              buttonColor: AppColors.appPrimaryColor,
              onTap: () {
                controller.logout();
              },
            ),
            CustomButton(
              label: 'Delete My Account',
              buttonColor: Color(0xFF5A5C5F),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
