import 'package:flutter/material.dart';
import 'package:medminder/mainApp/appHome.dart';
import 'package:medminder/mainApp/settings.dart';

class MedicationsList extends StatefulWidget {
  const MedicationsList({Key? key}) : super(key: key);

  @override
  State<MedicationsList> createState() => _MedicationsListState();
}

class _MedicationsListState extends State<MedicationsList> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _medications = [
    'Ibuprofen',
    'Lisinopril',
    'Amlodipine',
    'Benzonatate',
  ];

  void _handleSubmit(String value) {
    print('Search submitted: $value'); // This will display in the terminal
  }

  // New method to clear the search field
  void _clearSearch() {
    _searchController.clear();
  }

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
        child: Column(
          children: [
            // Non-scrollable header section
            Column(
              children: [
                // Spacer between top of page and title
                Container(
                  height: 25,
                ),

                // Title Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      const SizedBox(height: 20),
                      // Updated Search Box with clear button
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF00ABE1),
                            width: 2,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: _handleSubmit,
                          decoration: InputDecoration(
                            hintText: 'Search medications...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF00ABE1),
                            ),
                            // Added clear button
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    onPressed: _clearSearch,
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),

            // Scrollable Medications List
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ..._medications.map((med) => _buildMedicationCard(med)),
                    // Add some bottom padding for better scrolling experience
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
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
                          const Icon(Icons.medication),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MedicationsList(),
                              ),
                            );
                          },
                        ),
                        _buildNavItem(
                          'Home',
                          const Icon(Icons.home),
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
                          const Icon(Icons.person),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Settings(),
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
                          margin: const EdgeInsets.symmetric(horizontal: 10),
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
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Add listener to update UI when text changes (for showing/hiding clear button)
    _searchController.addListener(() {
      setState(() {});
    });
  }
}
