import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/profile/widget/custom_button.dart';
import 'package:chrismiche/features/profile/widget/personal_info.dart';
import 'package:flutter/material.dart';

class ProfilePageContainer extends StatelessWidget {
  const ProfilePageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(ImagePath.appLogo, height: 50, width: 50),
            ),
            SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Profile ',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '(Admin)',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(84),
              child: Image.asset(
                ImagePath.userPerson,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            PersonalInfo(),
            CustomButton(label: 'Log Out', buttonColor: Color(0xFFFF394F)),
            CustomButton(
              label: 'Delete My Account',
              buttonColor: Color(0xFF5A5C5F),
            ),
          ],
        ),
      ),
    );
  }
}
