import 'dart:convert';

import 'package:chrismiche/core/localization/end_points.dart' show Urls;
import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:chrismiche/features/profile/model/user_model.dart'
    show UserModel;
import 'package:chrismiche/features/welcome/screen/authentication_screen.dart'
    show AuthenticationScreen;
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PersonalInfoController extends GetxController {
  var isEditing = false.obs;
  var userName = "John Doe".obs;
  var fullName = "John Doe".obs;
  var gender = "male".obs;
  var email = "xyz@gmail.com".obs;
  var phoneNumber = "+1 123 456 7890".obs;

  var userNameController = TextEditingController();
  late TextEditingController genderController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    userNameController.text = userName.value;
    genderController = TextEditingController(text: gender.value);
    emailController = TextEditingController(text: email.value);
    phoneNumberController = TextEditingController(text: phoneNumber.value);
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      userName.value = userNameController.text;
      gender.value = genderController.text;
      email.value = emailController.text;
      phoneNumber.value = phoneNumberController.text;
    }
  }

  void logout() async {
    await SharedPreferencesHelper.clearAllData();
    Get.offAll(() => AuthenticationScreen());
  }

  var userList = <UserModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      String? token = await SharedPreferencesHelper.getAccessToken();

      final response = await http.get(
        Uri.parse(
          '${Urls.baseUrl}/users',
        ), // or whatever endpoint returns that response
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        print("The response is ${response.body}");
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final userJson = data['data'];
          final user = UserModel.fromJson(userJson);

          // Assign values from user to observables
          fullName.value = user.fullName ?? "N/A";
          userName.value = user.username ?? "N/A";
          email.value = user.email ?? "N/A";
          gender.value = user.gender ?? "N/A";
          phoneNumber.value =
              user.phoneNumber ?? "N/A"; // Adjust if phone is stored elsewhere

          print("The user name is ${userName.value}");

          // Also update controllers
          userNameController.text = userName.value;
          emailController.text = email.value;
          genderController.text = gender.value;
          phoneNumberController.text = phoneNumber.value;

          // Optional: if you want to store the user for other use
          userList.value = [user]; // just keep the single user
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch user info');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      EasyLoading.show(status: "Updating profile...");
      String? token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        if (kDebugMode) {
          print("No token found");
        }
      }

      final response = await http.patch(
        Uri.parse("${Urls.baseUrl}/users"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
        },
        body: jsonEncode({
          "fullName": fullName.value,
          "phoneNumber": phoneNumber.value,
          "gender": gender.value,
          "character": "Ninja",
          "userName": userName.value,
        }),
      );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess("Profile updated successfully");
        if (kDebugMode) {
          print("The response of updating profile is ${response.body}");
        }
        fetchUsers();
      } else {
        if (kDebugMode) {
          print("Error updating profile: ${response.body}");
        }
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
      if (kDebugMode) {
        print("The exception is $e");
      }
    } finally {
      EasyLoading.dismiss();
    }
  }
}
