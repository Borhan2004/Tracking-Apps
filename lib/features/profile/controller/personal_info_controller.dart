import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:chrismiche/features/welcome/screen/authentication_screen.dart' show AuthenticationScreen;
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PersonalInfoController extends GetxController {
  var isEditing = false.obs;
  var userName = "John Doe".obs; 
  var gender = "Male".obs; 
  var email = "xyz@gmail.com".obs; 
  var phoneNumber = "+1 123 456 7890".obs; 

  late TextEditingController userNameController;
  late TextEditingController genderController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;

  @override
  void onInit() {
    super.onInit();
    userNameController = TextEditingController(text: userName.value);
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
}
