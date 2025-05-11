import 'dart:async';

import 'package:chrismiche/features/welsome/screen/welcome_screen.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  void checkIsLogin() async {
    Timer(const Duration(seconds: 3), () async {
      // String? token = await SharedPreferencesHelper.getAccessToken();

      // String? userType = await SharedPreferencesHelper.getSelectedRole();

      // if (token != null) {
        
      //   if(userType == "SUBSCRIBER"){
      //      Get.offAll(() => SubscriberBottomNavbarView());
      //   }
      //   else{
      //     Get.offAll(() => UserBottomNavbarView()); 
      //   }

       
      // } else {
      //   Get.offAll(() => RoleSelectScreen());
      // }
      Get.offAll(() => WelcomeScreen());

    });
  }

  @override
  void onInit() {
    super.onInit();
    checkIsLogin();
  }
}