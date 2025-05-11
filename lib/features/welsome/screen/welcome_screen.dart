import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/core/utils/constants/colors.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/auth/login/screen/login_screen.dart';
import 'package:chrismiche/features/auth/signup/screen/sign_up_screen.dart';
import 'package:chrismiche/features/welsome/controller/welcome_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
   WelcomeScreen({super.key});

  final WelcomeController controller = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ImagePath.joggingImage, 
            ), 
            fit: BoxFit.cover
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 50
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: (){
                  Get.offAll(LoginScreen());
                },
                child: Container(
                  width: 138, 
                  height: 48,
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
                  )
                ),
              ), 
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  Get.offAll(SignUpScreen());
                },
                child: Container(
                  width: 138, 
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient:  LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.secondaryColor
                      ]
                    )
                  ), 
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: getTextStyle(
                        fontSize: 14, 
                        fontWeight: FontWeight.w500, 
                        color: Colors.white,
                      ),
                    ),
                  )
                ),
              ), 
              SizedBox(
                height: 20,
              ), 
              Text("The healthy winning cycle", 
               style: getTextStyle(
                color: Colors.white, 
                fontSize: 14, 
                fontWeight: FontWeight.w400,
               ),
              )
            ],
          ),
        ),
      ),
    );
  }
}