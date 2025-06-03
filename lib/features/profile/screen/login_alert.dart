import 'package:chrismiche/core/services/auth_service.dart';
import 'package:chrismiche/core/utils/constants/image_path.dart';
import 'package:chrismiche/features/auth/login/screen/login_screen.dart';
import 'package:chrismiche/features/profile/widget/login_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginAlert extends StatelessWidget {
  LoginAlert({super.key});
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Image.asset(ImagePath.appBarLogo, height: 50),
        elevation: 2,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color.fromARGB(230, 255, 253, 253),
      body: Container(
        padding: EdgeInsets.only(top: 112, left: 15, right: 15),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Join or Sign In',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 32,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Enjoy the best experience with us',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            LoginButton(
              title: 'Continue with Google',
              icon: 'assets/icons/google.png',
              onPressed: () async{
                await _auth.loginWithGoogle();
              },
            ),
            LoginButton(
              title: 'Continue with Facebook',
              icon: 'assets/icons/facebook.png',
              onPressed: () async{
                await _auth.signInWithFacebook();
              },
            ),
            LoginButton(
              title: 'Continue with Email',
              icon: 'assets/icons/email.png',
              onPressed: () {
                Get.to(() => LoginScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
