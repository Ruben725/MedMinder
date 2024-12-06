import 'package:flutter/material.dart';
import 'package:medminder/getStarted/loginInfo.dart';
import 'package:medminder/getStarted/userAuth.dart';
import 'package:medminder/custom.dart';

class UserSettings extends StatelessWidget {
  UserSettings({Key? key}) : super(key: key);
  final auth = userAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                // Top section with title
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
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
                Spacer(),

                Custom.newButton('Sign Out', Color.fromRGBO(188, 49, 51, 1),
                    () async {
                  await userAuth.signout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => loginInfo()));
                }),
                SizedBox(
                  height: 10,
                ),
              ],
            )),

            // Bottom navigation
            Custom.bottomNav(context),
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

  Widget _buildNavItem(String label, Icon icon, VoidCallback onPressed) {
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
