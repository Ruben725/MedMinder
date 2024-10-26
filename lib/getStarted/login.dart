import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';
//import 'package:medminder/getStarted/AccountInfo.dart';


class Login extends StatelessWidget {
  const Login ({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Stack(children: [
        Container(
          height: 800,
          width: 400,
          color: Color.fromRGBO(255, 255, 255, 1)
        ),
        NewButton(text: 'Login', 
                  color:Color.fromRGBO(0, 172, 226, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                    );
                   },
                  ),],),
      ],
    );
  }
}
