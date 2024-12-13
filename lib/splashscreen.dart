import "package:flutter/material.dart";
import "package:medminder/getStarted/login.dart";
import 'dart:async';
//import "package:medminder/assets/images/MedMinderLogo.png";

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/MedMinderLogo.png'),
      ),
    );
  }
}
