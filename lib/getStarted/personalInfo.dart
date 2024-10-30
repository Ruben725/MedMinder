import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/getStarted/accountInfo.dart';

class personalInfo extends StatefulWidget {
  const personalInfo({super.key});

  @override
  State<personalInfo> createState() => _personalInfoState();
}

//User personal Info page
class _personalInfoState extends State<personalInfo> {
  //Controllers for user input
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final sexController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:
      Center(
        child: Column(
          //Center Column to page
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Container for Title, 
            Container(
              height: 65, 
              width: 280, 
              child: Text('Sign Up',
                      textAlign: TextAlign.center,
                      style:TextStyle(color: Colors.black, fontSize: 32, fontFamily: 'Poppins')
                      )
            ),
            
            //Row for Page names
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Each Container has the page name
                 Container(
                  height: 35.0,
                  width: 150.0,
                  color: Color.fromRGBO(197, 247, 196, 1),
                  child: Center(child: Text('Account'))
                  ),
                
                  //Container has the bottom border underlined (green, width 3)
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
            //Used SizedBox to space out containers
            SizedBox(height: 20.0),

            //First name Input field
            //layout is same for the rest of the input fields
            Container(
              height: 32,
              width: 260,
               //Shapes the input field
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              //Takes input from user, and hints on what to input
              child:TextFormField(   
                controller: fnameController,
                decoration: const InputDecoration(
                hintText: 'First Name',
                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10), //Text positioin in field
                 border: InputBorder.none,
               ),
              ),
            ),
            const SizedBox(height: 20.0),

            //Last name input field
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

             //Sex input field, might be best to switch to M/F option only
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

            //Custon button used
            //Finish Button
            NewButton(text: 'Finish', 
                  color:Color.fromRGBO(65, 199, 62, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => accountInfo(), //Will go to Login or Homepage
                          ),
                    );
                   },
                  ),
            SizedBox(height: 20.0),
 
            //Back Button
            NewButton(text: 'Back', 
                  color:Color.fromRGBO(217, 217, 217, 1),
                  onPressed: () {Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => accountInfo(), //Goes to accountInfo page
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