import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/getStarted/loginInfo.dart';
import 'package:medminder/getStarted/accountInfo.dart';


class Login extends StatelessWidget {
  const Login ({super.key});

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
              height: 80, 
              width: 250, 
              child: Text('Medminder',
                    textAlign: TextAlign.center,
                    style:TextStyle(color: Color.fromRGBO(0, 172, 226, 100), fontSize: 40, fontFamily: 'Poppins')
                    )
            ),

           Image.asset('assets/images/MedMinderLogo.png'),

           SizedBox(height: 40.0),

           NewButton(text: 'Login', 
                  color:Color.fromRGBO(0, 172, 226, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => loginInfo(),
                          ),
                    );
                   },
                  ),
            
            SizedBox(height: 20.0),

            NewButton(text: 'Create Account', 
                  color:Color.fromRGBO(217, 217, 217, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => accountInfo(),
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
