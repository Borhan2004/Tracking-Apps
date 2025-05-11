import 'package:chrismiche/core/utils/constants/image_path.dart' show ImagePath;
import 'package:chrismiche/features/splash_screen/controller/splash_screen_controller.dart' show SplashScreenController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});

  final SplashScreenController controller = Get.put(SplashScreenController()); 

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 50
        ),
        child: Center(
          child: Image.asset(ImagePath.appLogo, 
          height: height * 0.8,
          width: width * 0.8,
          ),
        ),
      ),
    );
  }
}