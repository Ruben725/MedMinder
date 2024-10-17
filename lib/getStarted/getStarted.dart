import 'package:flutter/material.dart';

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
            Container(
            height: 200, 
            width: 250, 
            child: Text('Medminder',
                    textAlign: TextAlign.center,
                    style:TextStyle(color: Color.fromRGBO(0, 172, 226, 100), fontSize: 40, fontFamily: 'Poppins')
                    )
            ),
            Container(
            height: 300,
            width: 280,
            child: Text('Introducing the MedMinder a new informative experience to keep you updated on your medication. Helping have an easier experience on staying up to date with all your medication ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 20)
                  ),
            ),
            ElevatedButton(onPressed: () {print("Button Pressed");}, 
                          child: 
                          Text('Get Started',
                                 style: TextStyle(fontSize: 20, 
                                                 color: Color.fromRGBO(0, 0, 0, 100))
                                  ),
                          style: ElevatedButton.styleFrom( 
                            backgroundColor: Color.fromRGBO(0, 172, 226, 100),
                          ),
                          ),
          ]
        ),
      ),
    );
  }
}