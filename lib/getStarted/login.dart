import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/getStarted/loginInfo.dart';
import 'package:medminder/getStarted/getStarted.dart';


class Login extends StatelessWidget {
  const Login ({super.key});

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
              height: 80, 
              width: 250, 
              child: Text('Medminder',
                    textAlign: TextAlign.center,
                    style:TextStyle(color: Color.fromRGBO(0, 172, 226, 100), fontSize: 40, fontFamily: 'Poppins')
                    )
            ),

          //Logo
           Image.asset('assets/images/MedMinderLogo.png'),

          //Used to space containers
           SizedBox(height: 40.0),

          //Login Button
           NewButton(text: 'Login', 
                  color:Color.fromRGBO(0, 172, 226, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => loginInfo(), //Will go to login Info page
                          ),
                    );
                   },
                  ),
            
            SizedBox(height: 20.0),

            //Create Account Button
            NewButton(text: 'Create Account', 
                  color:Color.fromRGBO(217, 217, 217, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => getStarted(), //will to user to account setup
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
