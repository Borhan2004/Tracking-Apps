import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}