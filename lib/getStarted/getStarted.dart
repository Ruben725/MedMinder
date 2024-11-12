import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/getStarted/accountInfo.dart';
import 'package:medminder/getStarted/login.dart';

class getStarted extends StatelessWidget {
  const getStarted ({super.key});

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
            Container(
            height: 100, 
            width: 250, 
            child: Text('Medminder',
                    textAlign: TextAlign.center,
                    style:TextStyle(color: Color.fromRGBO(0, 172, 226, 100), fontSize: 40, fontFamily: 'Poppins')
                    )
            ),

            Image.asset('assets/images/MedMinderLogo.png'),
            SizedBox(height: 30),

            //App Description 
            Container(
            height: 250,
            width: 280,
            child: Text('Introducing the MedMinder a new informative experience to keep you updated on your medication. Helping have an easier experience on staying up to date with all your medication ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 20)
                  ),
            ),

            //Get Started Button
           NewButton(text: 'Next', 
                  color:Color.fromRGBO(0, 172, 226, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => accountInfo(), //Goes to login page
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