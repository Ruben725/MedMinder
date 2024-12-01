import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medminder/Home/home.dart';
import 'package:medminder/splashscreen.dart';
//import 'package:medminder/getStarted/getStarted.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MedMinder());
}

class MedMinder extends StatelessWidget {
  const MedMinder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Removes Demo Banner
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ), // Makes every page Scaffold background white
      home: SplashScreen(), //Starts app at getStarted page... For now
    );
  }
}
