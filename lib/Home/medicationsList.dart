import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medminder/Home/medicationInfo.dart';
import 'package:medminder/Home/editMedication.dart';

class MedicationsList extends StatefulWidget {
  const MedicationsList({Key? key}) : super(key: key);

  @override
  _MedicationsListState createState() => _MedicationsListState();
}

class _MedicationsListState extends State<MedicationsList> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allMedications = [
    'Ibuprofen',
    'Lisinopril',
    'Amlodipine',
    'Benzonatate'
  ];

  void _handleSearchSubmit(String query) async {
    try {
      CollectionReference drugDataCollection =
          FirebaseFirestore.instance.collection('DrugData');

      // reformat the input to only the first character being capitalized to match the document id of
      String capitalizedQuery = query.substring(0, 1).toUpperCase() +
          query.substring(1).toLowerCase();

      QuerySnapshot querySnapshot = await drugDataCollection
          .where(FieldPath.documentId, isEqualTo: capitalizedQuery)
          .get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          // Navigate to MedicationInfo with the drug data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedicationInfo(
                medicationName: data['drug_name'] ?? capitalizedQuery,
                dosage: data['dosage'] ?? 'Not specified',
                brandName: data['brand_name'] ?? 'N/A',
                foodInteractions:
                    data['food_interaction'] ?? 'No known interactions',
                foodsToAvoid: data['foods_to_avoid'] ?? [],
                consumptionMethod: data['recommended_consumption_method'] ?? {},
                sideEffects: data['side_effects'] ?? [],
                summary: data['summary'] ?? 'No summary available',
                synonyms: data['synonym'] ?? [],
              ),
            ),
          );
          return; // Exit after finding the first matching document
        }
      }

      // If no document found, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No medication found for "$capitalizedQuery"'),
          duration: Duration(seconds: 2),
        ),
      );

      _searchController.clear();
    } catch (error) {
      print('Error retrieving data from Firestore: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error searching for medication'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildMedicationCard(String medicationName) {
    return GestureDetector(
        onTap: () {
          // Navigate to EditMedication page when card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditMedication(
                medicationName: medicationName, // Pass the medication name
              ),
            ),
          );
        },
        child: Container(
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
        ));
  }

  Widget _buildSearchBar() {
    return Padding(
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
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(Icons.search, color: Color(0xFF00ABE1)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          onSubmitted: _handleSearchSubmit,
          textInputAction: TextInputAction.search,
        ),
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
                      ],
                    ),
                  ),

                  // Search Bar
                  _buildSearchBar(),

                  // Medications List
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 16),
                      children: _allMedications
                          .map((medication) => _buildMedicationCard(medication))
                          .toList(),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
