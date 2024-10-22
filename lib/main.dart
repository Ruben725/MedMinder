import 'package:flutter/material.dart';
import 'package:medminder/splashscreen.dart';
import 'package:medminder/getStarted/getStarted.dart';


void main() {
  runApp(const MedMinder());
}

class MedMinder extends StatelessWidget {
  const MedMinder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: getStarted(),
    );
  }
}