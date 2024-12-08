import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:globalchatapp/screens/splash_screen.dart';

class SignupController {
  static Future<void> creatAccount(
      {required String email,
      required String password,
      required String name,
      required String country,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      var userid = FirebaseAuth.instance.currentUser!.uid;
      var db = FirebaseFirestore.instance;

      Map<String, dynamic> data = {
        "name": name,
        "country": country,
        "email": email
      };

      try {
        await db.collection("users").doc(userid.toString()).set(data);
      } on Exception {
        print("Error writing data into the database!!");
      }

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
