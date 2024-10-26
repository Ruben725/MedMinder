import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/getStarted/accountInfo.dart';

class personalInfo extends StatefulWidget {
  const personalInfo({super.key});

  @override
  State<personalInfo> createState() => _personalInfoState();
}

class _personalInfoState extends State<personalInfo> {
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final sexController = TextEditingController();

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
                  child: Center(child: Text('Account'))
                  ),
                 Container(
                  height: 35.0,
                  width: 150.0,
                 decoration: BoxDecoration(
                    color: Color.fromRGBO(197, 247, 196, 1),
                    border: Border(bottom: 
                              BorderSide(color: Color.fromRGBO(65, 199, 62, 1),
                                         width: 3))),
                  child: Center(child: Text('Personal Info'))),
            ],),
            SizedBox(height: 20.0),

            Container(
              height: 32,
              width: 260,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child:TextFormField(   
                controller: fnameController,
                decoration: const InputDecoration(
                hintText: 'First Name',
                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                 border: InputBorder.none,
               ),
              ),
            ),
            const SizedBox(height: 20.0),

            Container(
              height: 32,
              width: 260,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child:TextFormField(
                controller: lnameController,
                decoration: const InputDecoration(
                 hintText: 'Last Name',
                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                 border: InputBorder.none,
               ),
              ),
            ),
             const SizedBox(height: 20.0),
            Container(
              height: 32,
              width: 75,
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child:TextFormField(
                controller: sexController,
                decoration: const InputDecoration(
                 hintText: 'Sex',
                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                 border: InputBorder.none,
               ),
              ),
            ),
            SizedBox(height: 40.0),

            NewButton(text: 'Finish', 
                  color:Color.fromRGBO(65, 199, 62, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => accountInfo(),
                          ),
                    );
                   },
                  ),
            SizedBox(height: 20.0),

            NewButton(text: 'Back', 
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