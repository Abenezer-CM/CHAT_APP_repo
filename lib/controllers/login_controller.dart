import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchatapp/screens/splash_screen.dart';

class LoginController {
  static Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // removes all the screens before it and cant get back
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const SplashScreen();
      }), (route) {
        return false;
      });

      print("Account sucessfully Created");
    } catch (e) {
      SnackBar msgSnackBar = SnackBar(
          backgroundColor: Colors.redAccent,
          content: Center(
            child: Text((e.toString() ==
                    "[firebase_auth/email-already-in-use] The email address is already in use by another account.")
                ? "The Email Address is Already in Use!"
                : e.toString()),
          ));
      ScaffoldMessenger.of(context).showSnackBar(msgSnackBar);
      print(e);
    }
  }
}
