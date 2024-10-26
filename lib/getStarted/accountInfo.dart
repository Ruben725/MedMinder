import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/getStarted/login.dart';

class accountInfo extends StatefulWidget {
  const accountInfo({super.key});

  @override
  State<accountInfo> createState() => _accountInfoState();
}

class _accountInfoState extends State<accountInfo> {
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
                  color: Color.fromRGBO(197, 247, 196, 1),
                  child: Center(child: Text('Account'))),
                 Container(
                  height: 35.0,
                  width: 150.0,
                  color: Color.fromRGBO(197, 247, 196, 1),
                  child: Center(child: Text('Personal Info'))),
            ],),
            SizedBox(height: 20.0),


            NewButton(text: 'Next', 
                  color:Color.fromRGBO(65, 199, 62, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
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