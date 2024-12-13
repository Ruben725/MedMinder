import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/getStarted/login.dart';
import 'package:medminder/getStarted/accountInfo.dart';

class GetStarted extends StatelessWidget {
  const GetStarted ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            
            //Title Container
            const SizedBox(height: 25),
            const Text('Medminder',
                    textAlign: TextAlign.center,
                    style:TextStyle(color: Color.fromRGBO(0, 172, 226, 100), 
                                    fontSize: 40, 
                                    fontFamily: 'Poppins')
                    ),
                   
            const SizedBox(height: 30),
            Image.asset('assets/images/MedMinderLogo.png'),
            const SizedBox(height: 30),

            //App Description 
            Container(
            height: 275,
            width: 350,
            child: const Text('Introducing MedMinder, a new tool to stay infromed and organized with your medications.\n Designed to simplify your routine, MedeMinder ensures you\'re always up-to-date with your prescriptions, making medications management easier than ever. ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 20)
                  ),
            ),

            //Get Started Button
           Custom.newButton('Next', 
                  const Color.fromRGBO(0, 172, 226, 1),
                  () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => const AccountInfo(), //Goes to login page
                          ),
                    );
                   },
                  ),

            Custom.newButton('Back',
             const Color.fromRGBO(217, 217, 217, 1), 
             () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => const Login(), //Goes to login page
                          ),
                    );
                   },)
            ],
          ),
          
        ),
      );
  }
}