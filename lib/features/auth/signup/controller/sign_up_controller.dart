import 'dart:convert';

import 'package:chrismiche/core/localization/end_points.dart' show Urls;
import 'package:chrismiche/core/services/shared_preferences_helper.dart'
    show SharedPreferencesHelper;
import 'package:chrismiche/features/profile_setup/screen/personal_details_screen.dart'
    show PersonalDetailsScreen;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var isObscure = false.obs;
  void togglePasswordVisibility() {
    isObscure.value = !isObscure.value;
    update();
  }

  var isObscureConfirm = false.obs;
  void toggleConfirmPasswordVisibility() {
    isObscureConfirm.value = !isObscureConfirm.value;
    update();
  }

  Future<void> signup() async {
    try {
      var response = await http.post(
        Uri.parse(Urls.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final String accessToken = responseData['data']['accessToken'];
          await SharedPreferencesHelper.saveTokenAndRole(accessToken);
          Get.offAll(PersonalDetailsScreen());
        } else {
          if (kDebugMode) {
            print("Signup failed: ${responseData['message']}");
          }
        }
      } else {
        if (kDebugMode) {
          print("Signup HTTP error: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("The error is $e");
      }
    }
  }
}
