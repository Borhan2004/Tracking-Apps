import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/features/auth/forget_password/screen/reset_password_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';

class ForgetPasswordController extends GetxController {
  var emailController = TextEditingController();

  Future<void> sendVerificationEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      EasyLoading.showError("Email field cannot be empty");
      return;
    }

    EasyLoading.show(status: 'Sending...');

    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/auth/forgot-password/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (kDebugMode) {
        print("Status: ${response.statusCode}");
        print("Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        EasyLoading.showSuccess("Verification email sent");
        await Future.delayed(Duration(seconds: 1));
        EasyLoading.dismiss();
        Get.offAll(ResetPasswordScreen());
      } else {
        EasyLoading.showError("Failed to send verification email");
      }
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    }
  }
}
