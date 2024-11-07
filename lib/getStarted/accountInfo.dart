import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/getStarted/login.dart';
import 'package:medminder/getStarted/userAuth.dart';
import 'package:medminder/getStarted/personalInfo.dart';

class accountInfo extends StatefulWidget {
  const accountInfo({super.key});

  @override
  State<accountInfo> createState() => _accountInfoState();
}

class _accountInfoState extends State<accountInfo> {
  final auth = userAuth();
  final formkey = GlobalKey<FormState>();

  final unameController = TextEditingController();
  final emailController = TextEditingController();
  final cemailController = TextEditingController();
  final pwController = TextEditingController();
  final cpwController = TextEditingController();

  String? validateEmail(String? email) {
    if (emailController.text != cemailController.text){
      return "Email does not match";
    }
    return null;
  }

  String? validatePW(String? pw){
    if (pwController.text != cpwController.text){
      return "Password does not match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:
      Center(
        child: Column(
          //Centers all containers to page
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Title Container
            Container(
              height: 65, 
              width: 280, 
              child: Text('Sign Up',
                      textAlign: TextAlign.center,
                      style:TextStyle(color: Colors.black, fontSize: 32, fontFamily: 'Poppins')
                      )
            ),

            //Row for Page names
            Row(
              //Centers Container to page
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Each container for page names
                 Container(
                  height: 35.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(197, 247, 196, 1),
                    border: Border(bottom: 
                              BorderSide(color: Color.fromRGBO(65, 199, 62, 1), //Underlines Container, color green
                                         width: 3))), //Width of 3
                  child: Center(child: Text('Account'))
                  ),
                 Container(
                  height: 35.0,
                  width: 150.0,
                  color: Color.fromRGBO(197, 247, 196, 1),
                  child: Center(child: Text('Personal Info'))),
            ],),
            //Used SizedBox to space out containers
            SizedBox(height: 20.0),

            //Username Input Container
            //Same Laytou used for each input container
            Container(
              height: 32,
              width: 260,
              //Shapes the input field
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child:TextFormField(   
                controller: unameController,
                decoration: const InputDecoration(
                hintText: 'Username', //Hint text of container
                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10), //Text position
                 border: InputBorder.none, // No undreline border
               ),
              ),
            ),
            //Used SizedBox for spacing on containers
            SizedBox(height: 20.0),

            //Email Input Field
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
               validator: (email) => email!.isEmpty ? "Enter Email" : null,
              ),
            ),
            SizedBox(height: 20.0),

            //Confirm email input container
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
               validator: validateEmail,
              ),
            ),
            SizedBox(height: 20.0,),

            //Password Input Field
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
                 validator: (pw) => pw!.isEmpty ? "Enter Email" : null,
              ),
            ),
            SizedBox(height: 20.0),

            //Confirm Password Input Field
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
               validator: validatePW,
              ),
            ),
            SizedBox(height: 40.0),

            //Next Button
          ElevatedButton(
          onPressed: _signup/* () {
               if (formkey.currentState!.validate()){
                 Navigator.push(context,
                 MaterialPageRoute(builder: (context) => _signup(),),);
               }
          }*/, 
          child: Text("Next", style: TextStyle(fontSize: 20, color: Color.fromRGBO(0, 0, 0, 1), ),),
                       style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(65, 199, 62, 1),
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                         )
                        )),
            SizedBox(height: 20.0),

            //Back Button
            NewButton(text: 'Back', 
                  color:Color.fromRGBO(217, 217, 217, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => Login(),  //Goes to Login Page
                          ),
                    );
                   },
                  ),
           ],
        ),
      ),
    );
  }

      _signup() async{
      final user = await auth.createUserA(emailController.text, pwController.text);
      if (user != null){
        print("User created");
        goToPersonal(context);
      }
    }

    goToPersonal(BuildContext context) => Navigator.push(context, 
                MaterialPageRoute(builder: (context) => const personalInfo()),
                );
}