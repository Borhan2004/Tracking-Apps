import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/core/services/auth_service.dart';
import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:chrismiche/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SocialLoginController extends GetxController {
  final AuthService _authService = AuthService();

  Future<void> loginWithGoogle() async {
    try {
      EasyLoading.show(status: "Signing in with Google...");
      final userCredential = await _authService.loginWithGoogle();

      if (userCredential?.user == null) {
        EasyLoading.showError("Google user not found.");
        return;
      }

      final idToken = await userCredential!.user!.getIdToken(true); // Force refresh
      if (idToken!.isEmpty) {
        EasyLoading.showError("Failed to retrieve ID token.");
        return;
      }

      await _sendTokenToBackend("google", idToken);
    } catch (e) {
      EasyLoading.showError("Google login error: $e");
      if (kDebugMode) print("Google sign-in error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> loginWithFacebook() async {
    try {
      EasyLoading.show(status: "Signing in with Facebook...");
      final userCredential = await _authService.signInWithFacebook();

      if (userCredential?.user == null) {
        EasyLoading.showError("Facebook user not found.");
        return;
      }

      final idToken = await userCredential!.user!.getIdToken(true);
      if (idToken!.isEmpty) {
        EasyLoading.showError("Failed to retrieve ID token.");
        return;
      }

      await _sendTokenToBackend("facebook", idToken);
    } catch (e) {
      EasyLoading.showError("Facebook login error: $e");
      if (kDebugMode) print("Facebook sign-in error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _sendTokenToBackend(String provider, String idToken) async {
    try {
      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/auth/social-login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "provider": provider,
          "idToken": idToken,
        }),
      );

      if (kDebugMode) print("Backend Response: ${response.statusCode} => ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final accessToken = data["data"]["accessToken"];

        if (accessToken == null || accessToken.isEmpty) {
          EasyLoading.showError("Backend token is null");
          return;
        }

        await SharedPreferencesHelper.saveTokenAndRole(accessToken);
        EasyLoading.showSuccess("Logged in successfully!");
        Get.offAll(() => BottomNavbarScreen());
      } else {
        final error = jsonDecode(response.body);
        EasyLoading.showError(error["message"] ?? "Login failed");
      }
    } catch (e) {
      EasyLoading.showError("Network error: $e");
      if (kDebugMode) print("Backend error: $e");
    }
  }
}
