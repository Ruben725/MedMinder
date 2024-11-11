import 'package:flutter/material.dart';
import 'package:medminder/mainApp/appHome.dart';

class MedicationsList extends StatelessWidget {
  const MedicationsList({Key? key}) : super(key: key);

  Widget _buildMedicationCard(String medicationName) {
    return Container(
      width: double.infinity,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 2,
            color: Color(0xFF00A624),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Center(
        child: Text(
          medicationName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
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
                  // App Bar
                  Container(
                    height: 42,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 54, height: 18),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                width: 18,
                                height: 18,
                                child: const FlutterLogo(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Title Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const Text(
                          'Medications',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 38,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 2,
                          color: const Color(0xFF00A624),
                        ),
                      ],
                    ),
                  ),

                  // Medications List
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 16),
                      children: [
                        _buildMedicationCard('Ibuprofen'),
                        _buildMedicationCard('Lisinopril'),
                        _buildMedicationCard('Amlodipine'),
                        _buildMedicationCard('Benzonatate'),
                      ],
                    ),
                  ),

                  // Bottom Navigation (matching AppHome)
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Navigation items
                        Positioned(
                          top: 8,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildNavItem(
                                'Medications',
                                const FlutterLogo(),
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MedicationsList(),
                                    ),
                                  );
                                },
                              ),
                              _buildNavItem(
                                'Home',
                                const FlutterLogo(),
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
                                const FlutterLogo(),
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

                        // Bottom indicators
                        Positioned(
                          bottom: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) => Container(
                                width: 100,
                                height: 5,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFB8BFC8),
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
}
