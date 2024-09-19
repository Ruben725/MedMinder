import 'package:flutter/material.dart';

void main() {
  runApp(const MedMinder());
}

class MedMinder extends StatelessWidget {
  const MedMinder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        appBar: AppBar(
          title: Text ("Home Test")
        ),
      ),
    );
  }
}