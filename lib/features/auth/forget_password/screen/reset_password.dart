import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/core/common/widgets/custom_button.dart';
import 'package:chrismiche/core/common/widgets/custom_textfield.dart';
import 'package:chrismiche/features/auth/forget_password/controller/forget_password_controller.dart';
import 'package:chrismiche/features/auth/forget_password/controller/reset_password_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final ForgetPasswordController controller = Get.find<ForgetPasswordController>();
  final ResetPasswordController resetPasswordController = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 65, left: 15, right: 15, bottom: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Reset Password", style: getTextStyle(color: Color(0xFF333333), fontSize: 24, fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              Text("A 6 digit verification pin has sent to your email address", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 20)),
              SizedBox(height: 20),

              OtpTextField(
                numberOfFields: 6,
                fieldWidth: 40.0,
                borderRadius: BorderRadius.circular(10),
                borderColor: const Color(0xFFEDF1F3),
                focusedBorderColor: const Color(0xFFEDF1F3),
                showFieldAsBox: true,
                onSubmit: (String code) {
                  resetPasswordController.otpController.value = code;
                  if (kDebugMode) {
                    print("Entered OTP is => $code");
                  }
                },
              ),

              SizedBox(height: 30),
              Text("Set a new password to your account", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 20)),
              SizedBox(height: 20),

              Align(alignment: Alignment.bottomLeft, child: Text("Password", style: getTextStyle(color: Color(0xFF5A5C5F), fontSize: 14, fontWeight: FontWeight.w400))),
              SizedBox(height: 10),
              Obx(() => CustomTextfield(
                    hintText: "********",
                    controller: resetPasswordController.passwordController,
                    isObscure: resetPasswordController.isObscure.value,
                    suffixIcon: IconButton(
                      icon: Icon(resetPasswordController.isObscure.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: resetPasswordController.togglePasswordVisibility,
                    ),
                  )),
              SizedBox(height: 20),

              Align(alignment: Alignment.bottomLeft, child: Text("Confirm Password", style: getTextStyle(color: Color(0xFF5A5C5F), fontSize: 14, fontWeight: FontWeight.w400))),
              SizedBox(height: 10),
              Obx(() => CustomTextfield(
                    hintText: "********",
                    controller: resetPasswordController.confirmPasswordController,
                    isObscure: resetPasswordController.isObscureConfirm.value,
                    suffixIcon: IconButton(
                      icon: Icon(resetPasswordController.isObscureConfirm.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: resetPasswordController.toggleConfirmPasswordVisibility,
                    ),
                  )),

              SizedBox(height: 40),
              CustomButton(
                onTap: () {
                  final email = controller.emailController.text.trim();
                  resetPasswordController.submitReset(email);
                },
                text: "Change Password",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
