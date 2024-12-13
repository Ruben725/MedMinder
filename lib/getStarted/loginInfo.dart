import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/Home/home.dart';
import 'package:medminder/getStarted/login.dart';
import 'package:medminder/getStarted/userAuth.dart';

class LoginInfo extends StatefulWidget {
  const LoginInfo({super.key});

  @override
  State<LoginInfo> createState() => LoginInfoState();
}

class LoginInfoState extends State<LoginInfo> {
  //Controllers for user inputd
  final auth = userAuth();
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  //deletes the use of controllers
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    pwController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:
      Center(
        child: Column(
          //Center all containers to page
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Container for Title
            Container(
              height: 80, 
              width: 250, 
              child: const Text('Medminder',
                    textAlign: TextAlign.center,
                    style:TextStyle(color: Color.fromRGBO(0, 172, 226, 100), fontSize: 40, fontFamily: 'Poppins')
                    )
            ),

            //Medminder Logo
            Image.asset('assets/images/MedMinderLogo.png'),
            const SizedBox(height: 80.0),

            //User name input
            Container(
              height: 32,
              width: 260,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(217, 217, 217, 1),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child:TextFormField(   
                controller: emailController,
                decoration: const InputDecoration(
                hintText: 'Username',
                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                color: const Color.fromRGBO(217, 217, 217, 1),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child:TextFormField(
                controller: pwController,
                decoration: const InputDecoration(
                 hintText: 'Password',
                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                 border: InputBorder.none,
               ),
              ),
            ),
             const SizedBox(height: 20.0),

            //Login Button
            Custom.newButton('Login', 
                  const Color.fromRGBO(0, 172, 226, 100),
                   loginUser, /*() {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => loginInfo(), //Will take user to Homepage
                          ),
                    );
                   },*/
                  ),
            const SizedBox(height: 20.0),

            //Back Button
            Custom.newButton('Back', 
                  const Color.fromRGBO(217, 217, 217, 1),
                  () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),  //to Login page 
                          ),
                    );
                   },
                  ),
           ],
        ),
      ),
    );
  }

  loginUser() async{
      
      final user = await auth.userLogin(emailController.text, pwController.text);
      if (user != null){
       print("Logged In");
       Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => AppHome()));
      }
    }
}