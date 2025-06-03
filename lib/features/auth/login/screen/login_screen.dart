import 'package:chrismiche/core/services/auth_service.dart';
import 'package:chrismiche/core/common/styles/global_text_style.dart';
import 'package:chrismiche/core/common/widgets/custom_button.dart';
import 'package:chrismiche/core/common/widgets/custom_textfield.dart';
import 'package:chrismiche/core/utils/constants/colors.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart' show ImagePath;
import 'package:chrismiche/features/auth/forget_password/screen/forget_password_screen.dart';
import 'package:chrismiche/features/auth/login/controller/login_screen_controller.dart';
import 'package:chrismiche/features/auth/login/widget/signin_method.dart';
import 'package:chrismiche/features/auth/signup/screen/sign_up_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _auth = AuthService();

  final LoginScreenController controller = Get.put(LoginScreenController());

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
                    "Sign in to your \nAccount",
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
                    "Enter your email and password to log in",
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
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      Get.to(ForgetPasswordScreen());
                    },
                    child: Text(
                      "Forgot Password?",
                      style: getTextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                CustomButton(onTap: controller.login, text: "Log In"),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: Divider(color: Color(0xFFEDF1F3))),
                    SizedBox(width: 5),
                    Text(
                      "Or",
                      style: getTextStyle(
                        color: Color(0xFF5A5C5F),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(child: Divider(color: Color(0xFFEDF1F3))),
                  ],
                ),
                SizedBox(height: 40),
                Signinmethod(
                  color: Colors.transparent,
                  textColor: Color(0xFF050505),
                  onTap: () async {
                    await _auth.loginWithGoogle();
                  },
                  text: "Continue with Google",
                  image: ImagePath.signInWithGoogle,
                ),
                SizedBox(height: 20),
                Signinmethod(
                  color: Colors.transparent,
                  textColor: Color(0xFF050505),
                  onTap: () async {
                    await _auth.signInWithFacebook();
                  },
                  text: "Continue with Facebook",
                  image: ImagePath.signInWithFacebook,
                ),
                SizedBox(height: 32),

                RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: getTextStyle(
                      color: Color(0xFF5A5C5F),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: getTextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Get.offAll(SignUpScreen());
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
