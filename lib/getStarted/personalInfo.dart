import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medminder/getStarted/accountInfo.dart';

class PersonalInfo extends StatefulWidget {
  final String email;
  final String password;

  const PersonalInfo({Key? key, required this.email, required this.password});

  @override
  State<PersonalInfo> createState() => PersonalInfoState();
}

//User personal Info page
class PersonalInfoState extends State<PersonalInfo> {
  //Controllers for user input
  final formkey = GlobalKey<FormState>();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final genderController = TextEditingController();
  final DoBController = TextEditingController();
  DateTime? DoB;
  String? gender;

  Future<void> dateSelected(BuildContext) async {
    final DateTime? dateSel = await showDatePicker(context: context, 
    initialDate: DateTime.now(),
    firstDate: DateTime(1930), lastDate: DateTime.now(),);
    if (dateSel != null){
      setState(() {
        DoB = dateSel;
        DoBController.text = DateFormat('yyyy-MM-dd').format(dateSel);
      });
    }
  }

  Future<void> createAccount() async {
    if(formkey.currentState!.validate()){
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );

      await FirebaseFirestore.instance.collection('Medminder').doc(userCredential.user!.uid).set({
        'Fname': fnameController.text,
        'Lname': lnameController.text,
        'dob': DoB,
        'gender': gender,

      });

       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account Created!')));
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }

      Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => AppHome()));

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:
      Center(
        child: Form(
        key: formkey,
        
          child: Column(
            //Center Column to page
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Container for Title, 
              Container(
                height: 80, 
                width: 300, 
                child: const Text('Sign Up: \n Personal Info',
                        textAlign: TextAlign.center,
                        style:TextStyle(color: Colors.black, fontSize: 28, fontFamily: 'Poppins')
                        )
              ),
              //Used SizedBox to space out containers
              const SizedBox(height: 20.0),

              //First name Input field
              //layout is same for the rest of the input fields
              Container(
                width: 260,
                //Takes input from user, and hints on what to input
                child:TextFormField(   
                  controller: fnameController,
                  decoration: InputDecoration(
                  hintText: 'First Name',
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10), //Text positioin in field
                   border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide( color: Colors.black, width: 1.0,)),
                ),
                ),
              ),
              const SizedBox(height: 20.0),

              //Last name input field
              Container(
                width: 260,
                child:TextFormField(
                  controller: lnameController,
                  decoration: InputDecoration(
                  hintText: 'Last Name',
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                   border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide( color: Colors.black, width: 1.0,)),
                ),
                ),
              ),
              const SizedBox(height: 20.0),

              Container(
                width: 260,
                child: TextFormField(
                  controller: DoBController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    suffixIcon: Icon(Icons.calendar_today_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide( color: Colors.black, width: 1.0,)),
                ),
                
                readOnly: true,
                onTap:() => dateSelected(context),
                validator: (value){
                  if (value == null||value.isEmpty) return 'Select your date of birth';
                  return null;
                },
                ),
              ),
              const SizedBox(height: 20.0,),

              Container(
                width: 260,
                child: DropdownButtonFormField<String>(
                  value: gender,
                  //hint: Text("Gender"),
                  decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide( color: Colors.black, width: 1.0,)),
                    ),
                  items: <String>['Male', 'Female'].map((String value){
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState((){
                      gender = newValue;
                    });
                  }
                ),
              ),
              const SizedBox(height: 20.0,),

              //Custon button used
              //Finish Button
              SizedBox(
                width: 200,
                child: ElevatedButton(onPressed: createAccount,
                            child: Text('Finish', style: TextStyle(fontSize: 20, color: Color.fromRGBO(0, 0, 0, 1), ),),
                            style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(65, 199, 62, 1),
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )
                            ),
                      ),
              ),    
              const SizedBox(height: 20.0),
  
              //Back Button
              Custom.newButton('Back', 
                    const Color.fromRGBO(217, 217, 217, 1),
                    () {Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => const AccountInfo(), //Goes to accountInfo page
                            ),
                      );
                    },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}