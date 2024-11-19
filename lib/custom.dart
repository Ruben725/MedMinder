import 'package:flutter/material.dart';
import 'package:medminder/Home/medicationsList.dart';
import 'package:medminder/Home/profile.dart';
import 'package:medminder/Home/home.dart';
import 'package:medminder/getStarted/userAuth.dart';

//Button layout, takes in text, color background, and
//where you want to navigate to.


class Custom{


  static Widget newButton(String text, Color color,  VoidCallback onPressed){

    return SizedBox(
      width: 200,
      child: ElevatedButton(
      onPressed: onPressed, 
      child: Text(text, style: TextStyle(fontSize: 20, color: Color.fromRGBO(0, 0, 0, 1), ),),
                       style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                         )
                        )),
    );
  }

  static Widget buildNavItem(String label, Widget icon, VoidCallback onPressed){
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 25,
            child: icon,
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  static Widget bottomNav(BuildContext context){
   return Container(
              
              height: 70,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 82, 195, 244),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Navigation items positioned at the top
                  Positioned(
                    top: 15,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildNavItem(
                          'Medications',
                          Icon(Icons.medication),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicationsList(),
                              ),
                            );
                          },
                        ),
                        buildNavItem(
                          'Home',
                          Icon(Icons.home),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppHome(),
                              ),
                            );
                          },
                        ),
                        buildNavItem(
                          'Profile',
                          Icon(Icons.person),
                          () {Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => profile(userId: userAuth.getId(),),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Bottom indicators positioned at the bottom
                  /*
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: 100,
                          height: 5,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: ShapeDecoration(
                            color: Color(0xFFB8BFC8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            );
  }
}




class buildNavItem extends StatelessWidget{
  final String label;
  final Icon icon;
  final VoidCallback onPressed;

  const buildNavItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 25,
            child: icon,
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

