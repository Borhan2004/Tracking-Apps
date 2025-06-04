import 'dart:convert';
import 'package:chrismiche/core/localization/end_points.dart';
import 'package:chrismiche/core/services/auth_service.dart';
import 'package:chrismiche/core/services/shared_preferences_helper.dart';
import 'package:chrismiche/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

      final idToken = await userCredential!.user!.getIdToken(true);
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

      final userCredential = await _authService.loginWithFacebook();

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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        EasyLoading.showError(
          "This email is already associated with another sign-in method. Please try signing in with Google.",
        );
      } else {
        EasyLoading.showError("Firebase auth error: ${e.message}");
      }
      if (kDebugMode) print("Firebase auth exception: $e");
    } catch (e) {
      EasyLoading.showError("Facebook login error: $e");
      if (kDebugMode) print("Facebook login error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }
  Future<void> _sendTokenToBackend(String provider, String idToken) async {
  try {
    EasyLoading.show(status: "Verifying with backend...");

    final response = await http.post(
      Uri.parse("${Urls.baseUrl}/auth/social-login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"provider": provider, "idToken": idToken}),
    );

    if (kDebugMode) {
      print("Backend Response: ${response.statusCode}");
      print("Body: ${response.body}");
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final accessToken = data["data"]?["accessToken"];

      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.showError("Backend token is null or empty");
        return;
      }

      await SharedPreferencesHelper.saveTokenAndRole(accessToken);
      EasyLoading.showSuccess("Logged in successfully!");
      
      if (kDebugMode) print("Navigating to BottomNavbarScreen");
      Get.offAll(() => BottomNavbarScreen());
    } else {
      try {
        final error = jsonDecode(response.body);
        final message = error["message"] ?? "Unknown error occurred.";
        EasyLoading.showError("$message");
        if (kDebugMode) print("Backend error: $message");
      } catch (_) {
        EasyLoading.showError("Unexpected backend error.");
        if (kDebugMode) print("Could not parse backend error: ${response.body}");
      }
    }
  } catch (e) {
    EasyLoading.showError("Network error: $e");
    if (kDebugMode) print("Exception: $e");
  } finally {
    EasyLoading.dismiss();
  }
}

}
