import 'package:chrismiche/core/common/styles/global_text_style.dart'
    show getTextStyle;
import 'package:chrismiche/core/common/widgets/custom_button.dart'
    show CustomButton;
import 'package:chrismiche/core/common/widgets/custom_textfield.dart'
    show CustomTextfield;
import 'package:chrismiche/core/utils/constants/colors.dart' show AppColors;
import 'package:chrismiche/core/utils/constants/image_path.dart' show ImagePath;
import 'package:chrismiche/features/auth/login/screen/login_screen.dart';
import 'package:chrismiche/features/auth/signup/controller/sign_up_controller.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 65, left: 15, right: 15, bottom: 30),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset(ImagePath.appLogo, height: 120, width: 120),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Create your own \nAccount",
                    style: getTextStyle(
                      color: Color(0xFF333333),
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Enter your email and password to create an account",
                    style: getTextStyle(
                      color: Color(0xFF5A5C5F),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Email",
                    style: getTextStyle(
                      color: Color(0xFF5A5C5F),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CustomTextfield(
                  hintText: "xyz@gmail.com",
                  controller: controller.emailController,
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Password",
                    style: getTextStyle(
                      color: Color(0xFF5A5C5F),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Obx(
                  () => CustomTextfield(
                    hintText: "********",
                    controller: controller.passwordController,
                    isObscure: controller.isObscure.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isObscure.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      color: Color(0xFF5A5C5F),
                      onPressed: () {
                        controller.togglePasswordVisibility();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Confirm Password",
                    style: getTextStyle(
                      color: Color(0xFF5A5C5F),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Obx(
                  () => CustomTextfield(
                    hintText: "********",
                    controller: controller.confirmPasswordController,
                    isObscure: controller.isObscureConfirm.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isObscureConfirm.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      color: Color(0xFF5A5C5F),
                      onPressed: () {
                        controller.toggleConfirmPasswordVisibility();
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20),

                CustomButton(
                  onTap: () {
                    // Get.offAll(() => PersonalDetailsScreen());
                    controller.signup();
                  },
                  text: "Sign Up",
                ),

                SizedBox(height: 32),

                RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: getTextStyle(
                      color: Color(0xFF5A5C5F),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: "Log in",
                        style: getTextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Get.offAll(LoginScreen());
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
