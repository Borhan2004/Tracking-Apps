// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final _auth = FirebaseAuth.instance;

//   Future<UserCredential?> loginWithGoogle() async {
//     try {
//       final googleUser = await GoogleSignIn().signIn();
//       final googleAuth = await googleUser?.authentication;
//       final cred = GoogleAuthProvider.credential(
//         idToken: googleAuth?.idToken,
//         accessToken: googleAuth?.accessToken,
//       );

//       return await _auth.signInWithCredential(cred);
//     } catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//     return null;
//   }

//   Future<UserCredential> signInWithFacebook() async {
//     try {
//       final LoginResult loginResult = await FacebookAuth.instance.login();

//     final OAuthCredential facebookAuthCredential =
//         FacebookAuthProvider.credential('${loginResult.accessToken?.tokenString}');

//     return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//     } catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//     throw FirebaseAuthException(
//       code: 'ERROR_FACEBOOK_LOGIN_FAILED',
//       message: 'Facebook sign-in failed and no UserCredential was returned.',
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (kDebugMode) print("Google sign-in error: $e");
      return null;
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

        return await _auth.signInWithCredential(facebookAuthCredential);
      } else {
        if (kDebugMode) print("Facebook login failed: ${loginResult.message}");
        return null;
      }
    } catch (e) {
      if (kDebugMode) print("Facebook sign-in error: $e");
      return null;
    }
  }
}
