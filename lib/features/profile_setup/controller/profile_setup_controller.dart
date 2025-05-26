import 'dart:io';
import 'package:chrismiche/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSetupController extends GetxController {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var phoneNumber = ''.obs;
  // final RxString selectedGame = ''.obs;

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

  void printNumber() {
    if (kDebugMode) {
      print("The phone number is ${phoneNumber.value}");
    }
    Get.to(BottomNavbarScreen());
  }
}
