import 'package:flutter/material.dart';
//import 'package:medminder/splashscreen.dart';
import 'package:medminder/getStarted/getStarted.dart';


void main() {
  runApp(const MedMinder());
}

class MedMinder extends StatelessWidget {
  const MedMinder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Removes Demo Banner
      theme: ThemeData(scaffoldBackgroundColor: Colors.white,), // Makes every page Scaffold background white
      home: getStarted(), //Starts app at getStarted page... For now
    );
  }
}