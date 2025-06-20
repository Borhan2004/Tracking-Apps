import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/core/common/widgets/custom_button.dart';
import 'package:chrismiche/features/auth/forget_password/controller/otp_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 65,
          left: 15,
          right: 15,
          bottom: 30,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Otp Verification",
                style: getTextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "A 6 digit verification pin has been sent to your email address",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              const SizedBox(height: 30),

              OtpTextField(
                numberOfFields: 6,
                fieldWidth: 50.0,
                borderRadius: BorderRadius.circular(10),
                borderColor: const Color(0xFFEDF1F3),
                focusedBorderColor: const Color(0xFFEDF1F3),
                showFieldAsBox: true,
                onSubmit: (String code) {
                  controller.otpController.value = code;
                  if (kDebugMode) {
                    print("Entered OTP is => $code");
                  }
                },
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),
              CustomButton(onTap: controller.verifyOtp, text: "Verify"),
            ],
          ),
        ),
      ),
    );
  }
}
