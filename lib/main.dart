import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medminder/Home/home.dart';
import 'package:medminder/Notification/notification.dart';
import 'package:medminder/Notification/notiTest.dart';
import 'package:medminder/splashscreen.dart';
//import 'package:medminder/getStarted/getStarted.dart';
import 'package:timezone/data/latest.dart' as tz;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await notificationRem.init();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  runApp(const MedMinder());
}

class MedMinder extends StatelessWidget {
  const MedMinder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Removes Demo Banner
      theme: ThemeData(scaffoldBackgroundColor: Colors.white,), // Makes every page Scaffold background white
      home: notiTest(), //Starts app at getStarted page... For now
    );
  }
}