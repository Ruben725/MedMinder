import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/getStarted/login.dart';
import 'package:medminder/mainApp/appHome.dart';

class loginInfo extends StatefulWidget {
  const loginInfo({super.key});

  @override
  State<loginInfo> createState() => _loginInfoState();
}

class _loginInfoState extends State<loginInfo> {
  //Controllers for user input
  final unameController = TextEditingController();
  final pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          //Center all containers to page
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Container for Title
            Container(
                height: 80,
                width: 250,
                child: Text('Medminder',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 172, 226, 100),
                        fontSize: 40,
                        fontFamily: 'Poppins'))),

            //Medminder Logo
            Image.asset('assets/images/MedMinderLogo.png'),
            const SizedBox(height: 80.0),

            //User name input
            Container(
              height: 32,
              width: 260,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, 1),
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                controller: unameController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            //Password input
            Container(
              height: 32,
              width: 260,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, 1),
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                controller: pwController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            //Login Button
            NewButton(
              text: 'Login',
              color: Color.fromRGBO(0, 172, 226, 100),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AppHome(), //Will take user to Homepage
                  ),
                );
              },
            ),
            SizedBox(height: 20.0),

            //Back Button
            NewButton(
              text: 'Back',
              color: Color.fromRGBO(217, 217, 217, 1),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(), //to Login page
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
