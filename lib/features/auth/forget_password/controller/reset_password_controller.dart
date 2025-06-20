import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/features/auth/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isObscure = false.obs;
  var isObscureConfirm = false.obs;

  void togglePasswordVisibility() {
    isObscure.value = !isObscure.value;
    update();
  }

  void toggleConfirmPasswordVisibility() {
    isObscureConfirm.value = !isObscureConfirm.value;
    update();
  }

  Future<void> submitReset() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"newPassword": password}),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Password reset successful");
        Get.offAll(() => LoginScreen());
      } else {
        final message = jsonDecode(response.body)['message'] ?? "Failed";
        Get.snackbar("Failed", message);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
