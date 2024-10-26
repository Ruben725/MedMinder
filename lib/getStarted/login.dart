import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';
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
           Image.asset('assets/images/MedMinderLogo.png'),

           SizedBox(height: 40.0),

           NewButton(text: 'Login', 
                  color:Color.fromRGBO(0, 172, 226, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
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
