import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';

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
                  // Spacer between top of page and title
                  Container(
                    height: 25,
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
                  Custom.bottomNav(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}