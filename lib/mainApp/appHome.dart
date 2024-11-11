import 'package:flutter/material.dart';
import 'package:medminder/mainApp/medicationsList.dart';

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight,
              child: Column(
                children: [
                  // Top status bar area
                  Container(
                    height: 42,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 54, height: 18),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Container(
                                width: 18,
                                height: 18,
                                child: FlutterLogo(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Date section (non-scrollable)
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0, right: 16, top: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tuesday',
                          style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'July 10, 2024',
                          style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search bar (non-scrollable)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 40,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 2, color: Color(0xFF00ABE1)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Scrollable medication cards section
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildMedicationCard('Ibuprofen', '11:00 AM'),
                          SizedBox(height: 16),
                          _buildMedicationCard('Lisinopril', '12:30 PM'),
                          SizedBox(height: 16),
                          _buildMedicationCard('Amlodipine', '4:30 PM'),
                          SizedBox(height: 16),
                          _buildMedicationCard('Benzonatate', '7:00 PM'),
                          // Add extra padding at the bottom
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

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
                                FlutterLogo(),
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
                                FlutterLogo(),
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
                                FlutterLogo(),
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(),
                                    ),
                                  );
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildMedicationCard(String name, String time) {
    return Container(
      height: 80,
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Color(0xFF00A624)),
          borderRadius: BorderRadius.circular(15),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 14),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Spacer(),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 16),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: OvalBorder(
                  side: BorderSide(width: 2, color: Color(0xFF00A624)),
                ),
              ),
            ),
          ),
        ],
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

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('Profile Page Content PlaceHolder'),
      ),
    );
  }
}
