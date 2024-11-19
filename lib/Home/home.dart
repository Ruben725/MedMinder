import 'package:flutter/material.dart';
import 'package:medminder/Home/medicationsList.dart';
import 'package:medminder/Home/settings.dart';
import 'package:medminder/custom.dart';
import 'package:intl/intl.dart';

class AppHome extends StatefulWidget {
  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> medications = [
    {'name': 'Ibuprofen', 'time': '11:00 AM'},
    {'name': 'Lisinopril', 'time': '12:30 PM'},
    {'name': 'Amlodipine', 'time': '4:30 PM'},
    {'name': 'Benzonatate', 'time': '7:00 PM'},
  ];

  /*
  // Function to handle search submission
  void _handleSearchSubmit(String value) {
    print('Search submitted: $value'); // This will print to terminal/console
    _searchController.clear(); // Optional: clear the search field after submit
  }*/

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
  }

  List<Map<String, String>> get filteredMedications {
    if (_searchQuery.isEmpty) {
      return medications;
    }
    return medications
        .where((medication) => medication['name']!
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            DateTime now = DateTime.now();
            String formattedDate =
                DateFormat('EEEEEEEEE, \nMMM d, yyyy').format(now);
            return Container(
              height: constraints.maxHeight,
              child: Column(
                children: [
                  // Date section (non-scrollable)
                  Padding(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 80),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Settings()),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 30.0, left: 20,),
                            child: Icon(Icons.settings, size: 45.0),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Updated Search bar with submit functionality
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
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon:
                              Icon(Icons.search, color: Color(0xFF00ABE1)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
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
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // Bottom navigation
                 Custom.bottomNav(context),
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