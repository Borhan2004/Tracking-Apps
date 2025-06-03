import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/features/auth/forget_password/screen/reset_password_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../forget_password/controller/forget_password_controller.dart';

class OtpController extends GetxController {
  final otpController = ''.obs;

  final ForgetPasswordController forgetPasswordController = Get.put(
    ForgetPasswordController(),
  );

  Future<void> verifyOtp() async {
    final otp = otpController.value.trim();
    final email = forgetPasswordController.emailController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar("Error", "OTP is required");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/auth/reset-password/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "otp": otp}),
      );

      if (kDebugMode) {
        print("Email: $email, OTP: $otp");
        print("Response: ${response.statusCode} - ${response.body}");
      }

      if (response.statusCode == 200) {
        Get.snackbar("Success", "OTP verified successfully");
        Get.to(() => ResetPasswordScreen());
      } else {
        final message = jsonDecode(response.body)['message'] ?? "Invalid OTP";
        Get.snackbar("Failed", message);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
