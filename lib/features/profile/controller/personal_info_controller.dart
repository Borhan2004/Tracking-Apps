import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PersonalInfoController extends GetxController {
  var isEditing = false.obs;
  var userName = "John Doe".obs; 
  var gender = "Male".obs; 
  var height = "6.1ft".obs; 
  var weight = "65kg".obs; 

  late TextEditingController userNameController;
  late TextEditingController genderController;
  late TextEditingController heightController;
  late TextEditingController weightController;

  @override
  void onInit() {
    super.onInit();
    userNameController = TextEditingController(text: userName.value);
    genderController = TextEditingController(text: gender.value);
    heightController = TextEditingController(text: height.value);
    weightController = TextEditingController(text: weight.value);
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      userName.value = userNameController.text;
      gender.value = genderController.text;
      height.value = heightController.text;
      weight.value = weightController.text;
    }
  }
}
