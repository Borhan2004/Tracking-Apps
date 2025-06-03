import 'dart:convert';

import 'package:chrismiche/core/localization/end_points.dart' show Urls;
import 'package:chrismiche/core/services/shared_preferences_helper.dart'
    show SharedPreferencesHelper;
import 'package:chrismiche/features/profile_setup/screen/personal_details_screen.dart'
    show PersonalDetailsScreen;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    EasyLoading.show(status: 'Sending...');
    try {
      var response = await http.post(
        Uri.parse(Urls.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final String accessToken = responseData['data']['accessToken'];
          await SharedPreferencesHelper.saveTokenAndRole(accessToken);
          EasyLoading.showSuccess('Sign up successful.');
          Get.offAll(PersonalDetailsScreen());
        } else {
          if (kDebugMode) {
            EasyLoading.showError('Signup failed...');

            print("Signup failed: ${responseData['message']}");
          }
        }
      } else {
        if (kDebugMode) {
          EasyLoading.showError('Signup HTTP error...');

          print("Signup HTTP error: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        EasyLoading.showError("The error is $e");
        print("The error is $e");
      }
    } finally {
      EasyLoading.dismiss();
    }
  }
}
