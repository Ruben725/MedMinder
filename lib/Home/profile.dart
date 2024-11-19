import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/Home/settings.dart';
import 'package:medminder/getStarted/userAuth.dart';

class profile extends StatefulWidget {  
  final String? userId;
  const profile({required this.userId});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User2>(
        future: User2.fetchUser(widget.userId), 
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else if (snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }else if (!snapshot.hasData){
            return Center(child: Text('User not found'),);
          }else{
            final user = snapshot.data!;
            return Padding(padding: const EdgeInsets.only(top: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.amber,
                  ),
                
                SizedBox(height: 10),
                
                Text('Name: ${user.fname} ${user.lname}', style: TextStyle(fontFamily: 'Poppins', fontSize: 20,)),
                Text('Gender: ${user.gender}', style: TextStyle(fontFamily: 'Poppins', fontSize: 20,)),
                //Text('Date: ${user.dob}', style: TextStyle(fontFamily: 'Poppins', fontSize: 20,)),
                //Text('Allergies: ${user.allergies}', style: TextStyle(fontFamily: 'Poppins', fontSize: 20,)),

                Spacer(),
                Custom.bottomNav(context),
              ],
            ),
            );
      
          }
        })
        /*Center(
          child: Column(
            children: [
              Expanded(child:
              Column(children: [
                        Custom.newButton("Back", Colors.blueGrey, () {Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Settings(),
                              ),
                            ); }
                        ),


                      ],
                    )

          ),
              Custom.bottomNav(context),
                        
              ],

          ),),*/
    );
  }

  int calculateAge(DateTime bDate){
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - bDate.year;

    if (currentDate.month < bDate.month || 
        (currentDate.month == bDate.month && 
        currentDate.day < bDate.day)){
          age --;
        }
    return age;
  }
}