import 'package:chrismiche/core/localization/end_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screen/reset_password.dart';

class ForgetPasswordController extends GetxController {
  var emailController = TextEditingController();

  Future<void> sendVerificationEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Email field cannot be empty");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/auth/forgot-password/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      if (kDebugMode) {
        print("Status: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("Body: ${response.body}");
      }
      if (response.statusCode == 200) {
        Get.offAll(ResetPassword());
      } else {
        Get.snackbar("Failed", "Failed to send verification email");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
