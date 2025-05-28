import 'dart:convert';
import 'dart:io';
import 'package:chrismiche/core/localization/end_points.dart' show Urls;
import 'package:chrismiche/core/services/shared_preferences_helper.dart' show SharedPreferencesHelper;
import 'package:chrismiche/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileSetupController extends GetxController {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var phoneNumber = ''.obs;

  final Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      selectedImage.value = File(result.files.single.path!);
    }
  }

  var selectedGender = RxnString(); // Nullable Rx String
  final List<String> genderOptions = ['Male', 'Female'];

  void setGender(String value) {
    selectedGender.value = value;
  }


  var userName = ''.obs;

  void updateUserNameFromFullName() {
    final fullName = nameController.text.trim();
    if (fullName.isNotEmpty) {
      userName.value = fullName.split(' ').first.toLowerCase();
    }
  }



  void printNumber() {
    if (kDebugMode) {
      print("The phone number is ${phoneNumber.value}");
    }
    Get.to(BottomNavbarScreen());
  }

  
  Future <void> updateProfile() async{
    try{
      String? token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        print("No token found"); 
      }

      final response = await http.patch(
        Uri.parse("${Urls.baseUrl}/users"), 
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', 
        },  
        body: jsonEncode({
         "fullName": nameController.text,
         "phoneNumber": phoneNumber.value,
         "gender": selectedGender.value, 
         "character": "Ninja", 
         "userName": userName.value,
        })
      ); 

      if(response.statusCode == 200){
        Get.offAll(() => BottomNavbarScreen());
      } 
      else{
        print("Error updating profile: ${response.statusCode}");
      }
    } catch (e){
      print("The exception is $e"); 
    }
  }


}
