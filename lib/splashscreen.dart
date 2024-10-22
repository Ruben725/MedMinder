import "package:flutter/material.dart";
//import "package:medminder/assets/images/MedMinderLogo.png";

class SplashScreen extends StatefulWidget{
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{
  @override
  Widget build(BuildContext context){
    // ignore: prefer_const_constructors
    return Scaffold(
      body: Center(
        child:Image.asset('assets/images/MedMinderLogo.png'),
      ),
    );
  }
}