import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/core/common/widgets/custom_button.dart';
import 'package:chrismiche/core/common/widgets/custom_textfield.dart';
import 'package:chrismiche/features/auth/forget_password/controller/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final ForgetPasswordController controller = Get.put(
    ForgetPasswordController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 65, left: 15, right: 15, bottom: 30),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Forget Password",
                textAlign: TextAlign.center,
                style: getTextStyle(
                  color: Color(0xFF333333),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                "A 6 digit verification pin will be sent to your email address",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Enter your email address",
                style: getTextStyle(
                  color: Color(0xFF5A5C5F),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 10),
            CustomTextfield(
              hintText: "xyz@gmail.com",
              controller: controller.emailController,
            ),
            SizedBox(height: 40),
            CustomButton(
              onTap: () {
                controller.sendVerificationEmail();
              },
              text: "Next",
            ),
          ],
        ),
      ),
    );
  }
}
