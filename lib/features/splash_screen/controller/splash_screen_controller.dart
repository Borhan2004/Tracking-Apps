import 'dart:async';

import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:chrismiche/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:chrismiche/features/welcome/screen/authentication_screen.dart';

import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  void checkIsLogin() async {
    Timer(const Duration(seconds: 3), () async {
      String? token = await SharedPreferencesHelper.getAccessToken(); 
      if(token != null) {
        Get.offAll(() => BottomNavbarScreen()); 
      }
      else{ 
        Get.offAll(() => AuthenticationScreen());
      }
      
    });
  }

  @override
  void onInit() {
    super.onInit();
    checkIsLogin();
  }
}
