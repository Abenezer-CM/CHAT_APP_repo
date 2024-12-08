import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchatapp/providers/userprovider.dart';
import 'package:globalchatapp/screens/dashboard_screen.dart';
import 'package:globalchatapp/screens/login_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (user == null) {
        openLogin();
      } else {
        openDashboard();
      }
    });

    // TODO: implement initState
    super.initState();
  }

  void openLogin() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
  }

  void openDashboard() {
    Provider.of<Userprovider>(context, listen: false).getUserDetails();

    // removes the back button but only of one layer of screens for multiple underling screens use pushandremoveuntill
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const DashboardScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            height: 130,
            width: 130,
            child: Image.asset("assets/images/logo.png")),
      ),
    );
  }
}
