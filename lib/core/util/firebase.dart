import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:foriyana_app/core/util/toast_util.dart';
import 'package:foriyana_app/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class CFirebase {
  static FirebaseAuth? _auth;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static Future<void> init() async {
    if (!Platform.isWindows) {
      await Firebase.initializeApp(
          name: "M-Mart", options: DefaultFirebaseOptions.currentPlatform);
      _auth ??= FirebaseAuth.instance;
      GoogleSignIn.instance.initialize(
        serverClientId:
            "392948734105-78n9v97r7ffgcoqri69rfb98qrmoa6b7.apps.googleusercontent.com",
      );
      // await CFirebaseMessaging.init(); //init firebase messaging
    }
  }

  static void signOut() {
    if (_auth != null) {
      _googleSignIn.signOut();
      FirebaseAuth.instance.signOut();
    }
  }

  static Future<FSignInResponse?> signInGoogle() async {
    if (_auth != null) {
      try {
        final GoogleSignInAccount googleUser =
            await _googleSignIn.authenticate();
        AuthCredential credential;

        final GoogleSignInAuthentication googleAuth = googleUser.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.idToken,
          idToken: googleAuth.idToken,
        );
        final User? firebaseUser =
            (await _auth!.signInWithCredential(credential)).user;
        _googleSignIn.signOut();
        return FSignInResponse(
            response: googleUser,
            user: firebaseUser,
            accessToken: googleAuth.idToken);
      } catch (e) {
        String errMessage = "Error google login";
        if (e is PlatformException) {
          errMessage = e.message ?? "";
        }
        _googleSignIn.disconnect();
        ToastUtil.showToast("Info", errMessage, ToastStatus.error);
        return FSignInResponse(response: e, user: null);
      }
    }
    return FSignInResponse(response: null, user: null);
  }

  static Future<FSignInResponse?> signInApple() async {
    if (_auth != null) {
      try {
        final result = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            webAuthenticationOptions: WebAuthenticationOptions(
                clientId: "com.foriyana.foriyanaapp",
                redirectUri: Uri.parse(
                    "https://m-mart-93570.firebaseapp.com/__/auth/handler")));
        OAuthProvider oAuthProvider = OAuthProvider("apple.com");
        if (result.identityToken != null) {
          final AuthCredential credential = oAuthProvider.credential(
            idToken: result.identityToken,
            accessToken: result.authorizationCode,
          );
          final authResult = await _auth!.signInWithCredential(credential);
          return FSignInResponse(response: result, user: authResult.user);
        } else {
          return FSignInResponse(
              response: 'Apple Credential Error', user: null);
        }
      } catch (ex) {
        return null;
      }
    }
    return null;
  }
}

class FSignInResponse {
  dynamic response;
  User? user;
  String? accessToken;

  FSignInResponse({
    required this.response,
    this.user,
    this.accessToken,
  });
}
