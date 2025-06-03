import 'package:chrismiche/features/auth/forget_password/screen/reset_password_screen.dart';
import 'package:chrismiche/features/splash_screen/screen/splash_screen.dart'
    show SplashScreen;
import 'package:get/get.dart';

class AppRoute {
  static String splashScreen = '/splashScreen';
  static String forgetPasswordScreen = '/forgetPasswordScreen';
  static String signupScreen = '/signupScreen';
  static String signinScreen = '/signinScreen';
  static String bottomNavbarScreen = '/bottomNavbarScreen';

  static String getSplashScreen() => splashScreen;
  static String getForgetPasswordScreen() => forgetPasswordScreen;
  static String getsignupScreen() => signupScreen;
  static String getsigninScreen() => signinScreen;
  static String getbottomNavbarScreen() => bottomNavbarScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => ResetPasswordScreen()),
  ];
}
