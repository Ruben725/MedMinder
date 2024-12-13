import 'package:flutter/material.dart';
import 'package:medminder/Home/settings.dart';
import 'package:medminder/Schedule/scheduleInfo.dart';
import 'package:medminder/custom.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medminder/getStarted/loginInfo.dart';
import 'package:medminder/getStarted/userAuth.dart';
import 'package:medminder/Notification/notification.dart';
import 'package:medminder/custom.dart';
import 'package:medminder/Medication/medicationInfo.dart';
import 'package:medminder/Medication/editMedication.dart';

class AppHome extends StatefulWidget {
  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Update the type annotation for medications
  Map<String, Map<String, dynamic>> medications = {};

  final ScrollController _autocompleteScrollController = ScrollController();

 // List<String> _allMedications = []; // used to contain all user medication for display; previously for testing
  List<String> _searchResults = [];
  bool _showAutocomplete = false;
  List<String> _drugDataDocumentIds = [];
  List<String> _allBrands = [];

  @override
  void initState() {
    super.initState();
    _fetchCurrentDayMedications();
    _fetchBrandNames();
    _fetchDrugDataDocumentIds();
  }
  

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

  Future<void> _fetchCurrentDayMedications() async {
    try {
      String? userId = userAuth.getId();
      DateTime now = DateTime.now();
      String currentDay = DateFormat('EEEE').format(now);

      QuerySnapshot querySnapshot = await _firestore
          .collection('MedicationSchedule')
          .where('userId', isEqualTo: userId)
          .where('days', arrayContains: currentDay)
          .get();

      Map<String, Map<String, dynamic>> medMap = {};
      for (DocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> medData = doc.data() as Map<String, dynamic>;
        medData['id'] = doc.id;

        // Ensure time is always a string
        medData['time'] = medData['time'] ?? 'No time set';

        medMap[doc.id] = medData;
      }

      setState(() {
        medications = medMap;
      });
    } catch (error) {
      print('Error fetching medications: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load medications')),
      );
    }
  }

  List<Map<String, dynamic>> get filteredMedications {
    // First, filter by search query
    List<Map<String, dynamic>> filtered = medications.values
        .where((medication) => medication['medicationName']
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();

    // Sort the filtered medications by time
    filtered.sort((a, b) {
      // Handle cases where time might be null or an empty string
      String timeA = a['time'] ?? '12:00 AM';
      String timeB = b['time'] ?? '12:00 AM';

      // Parse time string into a comparable format
      int compareTime(String timeStr) {
        // Remove any whitespace and convert to uppercase
        timeStr = timeStr.trim().toUpperCase();

        // Split into time and AM/PM
        RegExp timePattern = RegExp(r'(\d+):?(\d*)\s*(AM|PM)?');
        Match? match = timePattern.firstMatch(timeStr);

        if (match == null) return 0;

        //  obtaining the hour, minutes, and AM/PM period; are set to 0 or AM to prevent null cases
        int hour = int.tryParse(match.group(1) ?? '0') ?? 0;
        int minute = match.group(2) != null && match.group(2)!.isNotEmpty
            ? int.tryParse(match.group(2)!) ?? 0
            : 0;
        String period = match.group(3) ?? 'AM';

        // Convert to 24-hour format for comparison
        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }

        // Create a comparable integer representation
        return hour * 60 + minute;
      }

      int timeValueA = compareTime(timeA);
      int timeValueB = compareTime(timeB);

      return timeValueA.compareTo(timeValueB);
    });

    return filtered;
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
                            builder: (context) => LoginInfo(), //Goes to login page
                          ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 30.0,
                              left: 20,
                            ),
                            child: Icon(Icons.settings, size: 45.0),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Search bar is used to filter the medication cards
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
                       /* onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },*/
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
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear,
                                      color: Color(0xFF00ABE1)),
                                  onPressed: _clearSearch,
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        onChanged: _handleSearch,
                        onSubmitted: _handleSearchSubmit,
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Scrollable medication cards section
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: filteredMedications.isEmpty
                            ? [
                                Center(
                                  child: Text(
                                    'No medications found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ]
                            : filteredMedications
                                .map((med) => Column(
                                      children: [
                                        _buildMedicationCard(med),
                                        SizedBox(height: 16),
                                      ],
                                    ))
                                .toList(),
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

  

  Widget _buildMedicationCard(Map<String, dynamic> med) {

    String name = med['medicationName'] ?? 'Unknown Medication';
    String displayTime = med['time']?.toString() ?? 'No time set';
    bool status = med['status'] ?? false;
    int numberOfPills = med['numberOfPills'] ?? 1;


    // Parse the scheduled time
    DateTime? scheduledTime;
    try {
      // Combine today's date with the scheduled time
      DateTime now = DateTime.now();
      scheduledTime = DateFormat('h:mm a').parse(displayTime);
      scheduledTime = DateTime(now.year, now.month, now.day, scheduledTime.hour,
          scheduledTime.minute);
    } catch (e) {
      print('Error parsing time: $e');
    }

    //notification
    DateTime scheduledTime2 = scheduledTime!;
    NotificationRem.scheduledNotification("It's time for your medication!", "Please take your " + name, scheduledTime2);

    // Determine border color
    Color borderColor;
    IconData statusIcon;
    if (status) {
      // If status is true (medication taken), always green
      borderColor = Color(0xFF00A624);
      statusIcon = Icons.check_circle;
    } else {
      if (scheduledTime != null) {
        if (scheduledTime.isBefore(DateTime.now())) {
          // Scheduled time has passed and status is false, show red
          borderColor = Color.fromARGB(255, 200, 29, 17);
          statusIcon = Icons.error;
        } else {
          // Scheduled time is in the future and status is false, show gray
          borderColor = Color(0xFF808080);
          statusIcon = Icons.access_time_filled;
        }
      } else {
        // Fallback to gray if time parsing fails
        borderColor = Color(0xFF808080);
        statusIcon = Icons.access_time_filled;
      }
    }

    return GestureDetector(
      onTap: () {
        // Navigate to scheduleInfo page and pass medication name
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => scheduleInfo(medicationName: name),
          ),
        );
      },
      child: Container(
        height: 80,
        decoration: ShapeDecoration(
          color: Colors.white.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: borderColor),
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
              'Pills: $numberOfPills',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 16),
            Text(
              displayTime,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 16),
            Padding(
              padding: EdgeInsets.all(20),
              child: Icon(
                statusIcon,
                color: borderColor,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchDrugDataDocumentIds() async {
    try {
      CollectionReference drugDataCollection =
          FirebaseFirestore.instance.collection('DrugData');

      QuerySnapshot querySnapshot = await drugDataCollection.get();

      setState(() {
        _drugDataDocumentIds = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (error) {
      print('Error fetching DrugData document IDs: $error');
    }
  }

  Future<void> _fetchBrandNames() async {
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
        _allBrands =
            allBrands.toSet().toList(); // Convert to Set to remove duplicates
      });
    } catch (error) {
      print('Error fetching brand names: $error');
    }
  }

  void _handleSearch(String value) {
    // allows search by drug name and by brand name
    List<String> allPossibleMedications = [
      ..._drugDataDocumentIds,
      ..._allBrands,
    ];

    setState(() {
      if (value.isEmpty) {
        _searchResults = [];
        _showAutocomplete = false;
      } else {
        _searchResults = allPossibleMedications
            .where((medication) =>
                medication.toLowerCase().contains(value.toLowerCase()))
            .toList();
        _showAutocomplete = true;
      }
    });
  }

  Future<void> _handleSearchSubmit(String query) async {
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
        bool foundBrandMatch = false;
        for (String brand in _allBrands) {
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
                  foundBrandMatch = true;
                  break;
                }
              }
            }
          }
        }

        if (!foundBrandMatch) {
          // If no document found and no brand match, show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No medication found for "$query"'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }

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

  Widget _buildSearchAutocomplete() {
    return _showAutocomplete && _searchResults.isNotEmpty
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
              controller: _autocompleteScrollController,
              child: ListView.separated(
                controller: _autocompleteScrollController,
                shrinkWrap: true,
                itemCount: _searchResults.length,
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
                      _searchResults[index],
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      _searchController.text = _searchResults[index];
                      _handleSearchSubmit(_searchResults[index]);
                      setState(() {
                        _showAutocomplete = false;
                      });
                    },
                  );
                },
              ),
            ),
          )
        : const SizedBox.shrink();
  }

}

