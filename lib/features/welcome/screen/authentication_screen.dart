import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/core/utils/constants/colors.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:chrismiche/features/welcome/screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.runBackground2),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Get.offAll(WelcomeScreen());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      'Log In',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.to(BottomNavbarScreen());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [AppColors.appPrimaryColor, Colors.tealAccent],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Use as a guest',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "The healthy winning cycle",
                style: getTextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
