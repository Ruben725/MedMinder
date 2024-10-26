import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/getStarted/login.dart';
import 'package:medminder/getStarted/personalInfo.dart';

class accountInfo extends StatefulWidget {
  const accountInfo({super.key});

  @override
  State<accountInfo> createState() => _accountInfoState();
}

class _accountInfoState extends State<accountInfo> {
  final unameController = TextEditingController();
  final emailController = TextEditingController();
  final cemailController = TextEditingController();
  final pwController = TextEditingController();
  final cpwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:
      Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 65, 
              width: 280, 
              child: Text('Sign Up',
                      textAlign: TextAlign.center,
                      style:TextStyle(color: Colors.black, fontSize: 32, fontFamily: 'Poppins')
                      )
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Container(
                  height: 35.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(197, 247, 196, 1),
                    border: Border(bottom: 
                              BorderSide(color: Color.fromRGBO(65, 199, 62, 1),
                                         width: 3))),
                  child: Center(child: Text('Account'))
                  ),
                 Container(
                  height: 35.0,
                  width: 150.0,
                  color: Color.fromRGBO(197, 247, 196, 1),
                  child: Center(child: Text('Personal Info'))),
            ],),
            SizedBox(height: 20.0),

            Container(
              height: 32,
              width: 260,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child:TextFormField(   
                controller: unameController,
                decoration: const InputDecoration(
                hintText: 'Username',
                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                 border: InputBorder.none,
               ),
              ),
            ),
            SizedBox(height: 20.0),

            Container(
              height: 32,
              width: 260,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child:TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                 hintText: 'Email',
                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                 border: InputBorder.none,
               ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 32,
              width: 260,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child:TextFormField(
                controller: cemailController,
                decoration: const InputDecoration(
                 hintText: 'Confirm Email',
                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                 border: InputBorder.none,
               ),
              ),
            ),
            SizedBox(height: 20.0,),

            Container(
              height: 32,
              width: 260,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child:TextFormField(
                controller: pwController,
                decoration: const InputDecoration(
                 hintText: 'Password',  
                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                 border: InputBorder.none,               ),
              ),
            ),
            SizedBox(height: 20.0),

            Container(
              height: 32,
              width: 260,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child:TextFormField(
                controller: cpwController,
                decoration: const InputDecoration(
                 hintText: 'Confirm Password',
                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                 border: InputBorder.none,
               ),
              ),
            ),
            SizedBox(height: 40.0),

            NewButton(text: 'Next', 
                  color:Color.fromRGBO(65, 199, 62, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => personalInfo(),
                          ),
                    );
                   },
                  ),
            SizedBox(height: 20.0),

            NewButton(text: 'Back', 
                  color:Color.fromRGBO(217, 217, 217, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
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