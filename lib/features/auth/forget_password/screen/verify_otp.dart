import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/core/common/widgets/custom_button.dart';
import 'package:chrismiche/features/auth/forget_password/controller/forget_password_controller.dart';
import 'package:chrismiche/features/auth/reset_password/screen/reset_password_screen.dart'
    show ResetPasswordScreen;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart'
    show OtpTextField;
import 'package:get/get.dart';

class VerifyOtp extends StatelessWidget {
  VerifyOtp({super.key});

  final ForgetPasswordController controller =
      Get.find<ForgetPasswordController>();

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
                "Verify OTP",
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
                "A 6 digit verification pin has sent to your email address",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            OtpTextField(
              numberOfFields: 6,
              fieldWidth: 50.0,
              borderRadius: BorderRadius.circular(10),
              borderColor: const Color(0xFFEDF1F3),
              focusedBorderColor: const Color(0xFFEDF1F3),
              showFieldAsBox: true,
              onSubmit: (String code) {
                if (kDebugMode) {
                  print("Entered OTP is => $code");
                }
              },
            ),
            SizedBox(height: 40),
            CustomButton(
              onTap: () {
                Get.offAll(ResetPasswordScreen());
              },
              text: "Verify",
            ),
          ],
        ),
      ),
    );
  }
}
