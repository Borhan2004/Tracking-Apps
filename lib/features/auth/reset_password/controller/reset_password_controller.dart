import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
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
}