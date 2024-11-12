import 'package:flutter/material.dart';
import 'package:medminder/mainApp/medicationsList.dart';
import 'package:medminder/mainApp/appHome.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top section with title
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Settings options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingOption('Account'),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: const Color(0xFF00ABE1),
                  ),
                  const SizedBox(height: 20),
                  _buildSettingOption('Privacy'),
                  const SizedBox(height: 20),
                  _buildSettingOption('Settings'),
                ],
              ),
            ),

            // Spacer to push navigation to bottom
            const Spacer(),

            // Bottom navigation
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
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
                    top: 8,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(
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
                        _buildNavItem(
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
                        _buildNavItem(
                          'Profile',
                          Icon(Icons.person),
                          () {
                            // Already on Settings page
                          },
                        ),
                      ],
                    ),
                  ),

                  // Bottom indicators positioned at the bottom
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildNavItem(String label, Widget icon, VoidCallback onPressed) {
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
