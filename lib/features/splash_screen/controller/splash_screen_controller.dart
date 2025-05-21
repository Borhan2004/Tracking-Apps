import 'dart:async';

import 'package:chrismiche/features/welcome/screen/authentication_screen.dart';

import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  void checkIsLogin() async {
    Timer(const Duration(seconds: 3), () async {
      Get.offAll(() => AuthenticationScreen());
    });
  }

  @override
  void onInit() {
    super.onInit();
    checkIsLogin();
  }
}
