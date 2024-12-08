import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:globalchatapp/firebase_options.dart';
import 'package:globalchatapp/providers/userprovider.dart';
import 'package:globalchatapp/screens/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => Userprovider(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            fontFamily: "poppins"),
        home: const SplashScreen());
  }
}
