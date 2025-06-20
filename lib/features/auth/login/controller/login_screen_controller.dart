import 'dart:convert';

import 'package:chrismiche/core/localization/end_points.dart' show Urls;
import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:chrismiche/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TextEditingController;
import 'package:flutter_easyloading/flutter_easyloading.dart' show EasyLoading;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginScreenController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var isObscure = false.obs;
  void togglePasswordVisibility() {
    isObscure.value = !isObscure.value;
    update();
  }

  Future<void> login() async {
    try {
      EasyLoading.show(status: "Loading...");
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess("User Logged in Successfully");
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String accessToken = responseData["data"]["accessToken"];
        await SharedPreferencesHelper.saveTokenAndRole(accessToken);
        Get.offAll(() => BottomNavbarScreen());
      } else {
        EasyLoading.showError("Failed to login");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
      if (kDebugMode) {
        print("The error is $e");
      }
    } finally {
      EasyLoading.dismiss();
    }
  }
}
