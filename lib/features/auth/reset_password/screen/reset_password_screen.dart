import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/core/common/widgets/custom_button.dart';
import 'package:chrismiche/core/common/widgets/custom_textfield.dart'
    show CustomTextfield;
import 'package:chrismiche/features/auth/login/screen/login_screen.dart';
import 'package:chrismiche/features/auth/reset_password/controller/reset_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ResetPasswordController controller = Get.put(ResetPasswordController());

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
                "Reset Password",
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
                "Set a new password to your account",
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 40),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Password",
                style: getTextStyle(
                  color: Color(0xFF5A5C5F),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 10),
            Obx(
              () => CustomTextfield(
                hintText: "********",
                controller: controller.passwordController,
                isObscure: controller.isObscure.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isObscure.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  color: Color(0xFF5A5C5F),
                  onPressed: () {
                    controller.togglePasswordVisibility();
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Confirm Password",
                style: getTextStyle(
                  color: Color(0xFF5A5C5F),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 10),
            Obx(
              () => CustomTextfield(
                hintText: "********",
                controller: controller.confirmPasswordController,
                isObscure: controller.isObscureConfirm.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isObscureConfirm.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  color: Color(0xFF5A5C5F),
                  onPressed: () {
                    controller.toggleConfirmPasswordVisibility();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ), 
            CustomButton(onTap: (){
              Get.offAll(LoginScreen()); 
            }, text: "Change Password"),
          ],
        ),
      ),
    );
  }
}
