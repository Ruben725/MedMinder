import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medminder/Medication/medicationInfo.dart';
import 'package:medminder/Medication/editMedication.dart';
import 'package:medminder/getStarted/userAuth.dart';

class MedicationsList extends StatefulWidget {
  const MedicationsList({Key? key}) : super(key: key);

  @override
  _MedicationsListState createState() => _MedicationsListState();
}

class _MedicationsListState extends State<MedicationsList> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ScrollController autocompleteController = ScrollController();

  List<String> allMeds =
      []; // used to contain all user medication for display; previously for testing
  List<String> searchResults = [];
  bool autocomplete = false;
  List<String> drugData = [];
  List<String> allBrands = [];

  @override
  void initState() {
    super.initState();
    getDrugData();
    getUserMeds(); // New method to fetch user's medications
  }

  Future<void> getUserMeds() async {
    try {
      // Get the current user's ID
      String? userId = userAuth.getId();
      if (userId == null) {
        print('No user logged in');
        return;
      }

      // Reference to the MedicationSchedule collection
      CollectionReference medicationSchedules =
          FirebaseFirestore.instance.collection('MedicationSchedule');

      // Query medications for the current user
      QuerySnapshot querySnapshot = await medicationSchedules
          .where('userId', isEqualTo: userId)
          .get();

      // Extract unique medication names
      Set<String> userMeds = querySnapshot.docs
          .map((doc) => doc['medicationName'] as String)
          .toSet(); // Using Set to remove duplicates

      setState(() {
        allMeds = userMeds.toList();
      });
    } catch (error) {
      print('Error obtaining user medications: $error');

      // Show a snackbar to inform the user about the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading medications'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> getDrugData() async {
    try {
      CollectionReference drugDataCollection =
          FirebaseFirestore.instance.collection('DrugData');

      QuerySnapshot querySnapshot = await drugDataCollection.get();

      List<String> allBrands = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          dynamic brandNames = data['brand_name'];
          if (brandNames is String && brandNames.isNotEmpty) {
            allBrands.add(brandNames);
          } else if (brandNames is List<dynamic> && brandNames.isNotEmpty) {
            allBrands.addAll(brandNames.map((brand) => brand.toString()));
          }
        }
      }

      setState(() {
        drugData = querySnapshot.docs.map((doc) => doc.id).toList();
        allBrands =
          allBrands.toSet().toList(); // Convert to Set to remove duplicates
      });
    } catch (error) {
      print('Error obtaining DrugData: $error');
    }
  }

  void drugSearch(String value) {
    // allows search by drug name and by brand name
    List<String> allMeds = [
      ...drugData,
      ...allBrands,
    ];

    setState(() {
      if (value.isEmpty) {
        searchResults = [];
        autocomplete = false;
      } else {
        searchResults = allMeds
            .where((medication) =>
                medication.toLowerCase().contains(value.toLowerCase()))
            .toList();
        autocomplete = true;
      }
    });
  }

  Future<void> searchSelect(String query) async {
    try {
      CollectionReference drugDataCollection =
          FirebaseFirestore.instance.collection('DrugData');

      // Reformat the input to only the first character being capitalized to match the document id
      String capitalizedQuery = query.substring(0, 1).toUpperCase() +
          query.substring(1).toLowerCase();

      // First, check if the query matches a document ID
      QuerySnapshot querySnapshot = await drugDataCollection
          .where(FieldPath.documentId, isEqualTo: capitalizedQuery)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
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
                  consumptionMethod:
                      data['recommended_consumption_method'] ?? {},
                  sideEffects: data['side_effects'] ?? [],
                  summary: data['summary'] ?? 'No summary available',
                  synonyms: data['synonym'] ?? [],
                ),
              ),
            );
            return; // Exit after finding the first matching document
          }
        }
      } else {
        // If no document found, check if the query matches a brand name
        bool brandMatch = false;
        for (String brand in allBrands) {
          if (brand.toLowerCase() == query.toLowerCase()) {
            // Navigate to MedicationInfo with the brand name
            QuerySnapshot brandSnapshot = await drugDataCollection
                .where('brand_name', arrayContains: brand)
                .get();

            if (brandSnapshot.docs.isNotEmpty) {
              for (var doc in brandSnapshot.docs) {
                Map<String, dynamic>? data =
                    doc.data() as Map<String, dynamic>?;
                if (data != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicationInfo(
                        medicationName: data['drug_name'] ?? brand,
                        dosage: data['dosage'] ?? 'Not specified',
                        brandName: data['brand_name'] ?? 'N/A',
                        foodInteractions:
                            data['food_interaction'] ?? 'No known interactions',
                        foodsToAvoid: data['foods_to_avoid'] ?? [],
                        consumptionMethod:
                            data['recommended_consumption_method'] ?? {},
                        sideEffects: data['side_effects'] ?? [],
                        summary: data['summary'] ?? 'No summary available',
                        synonyms: data['synonym'] ?? [],
                      ),
                    ),
                  );
                  brandMatch = true;
                  break;
                }
              }
            }
          }
        }

        if (!brandMatch) {
          // If no document found and no brand match, show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No medication found for "$query"'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }

      searchController.clear();
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

  Widget searchAutocomplete() {
    return autocomplete && searchResults.isNotEmpty
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: BoxConstraints(
              maxHeight: 200,
            ),
            child: RawScrollbar(
              thumbColor: Colors.grey.withOpacity(0.5),
              radius: const Radius.circular(20),
              thickness: 4,
              controller: autocompleteController,
              child: ListView.separated(
                controller: autocompleteController,
                shrinkWrap: true,
                itemCount: searchResults.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    title: Text(
                      searchResults[index],
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      searchController.text = searchResults[index];
                      searchSelect(searchResults[index]);
                      setState(() {
                        autocomplete = false;
                      });
                    },
                  );
                },
              ),
            ),
          )
        : const SizedBox.shrink();
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
                        controller: searchController,
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
                        onChanged: drugSearch,
                        onSubmitted: searchSelect,
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                  ),

                  // Autocomplete Suggestions
                  searchAutocomplete(),

                  // Medications List
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 16),
                      children: allMeds
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
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    autocompleteController.dispose();
    super.dispose();
  }
}