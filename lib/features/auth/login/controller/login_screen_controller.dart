import 'package:flutter/material.dart' show TextEditingController;
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var isObscure = false.obs;
  void togglePasswordVisibility() {
    isObscure.value = !isObscure.value;
    update();
  }
}
