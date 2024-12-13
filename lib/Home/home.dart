import 'package:flutter/material.dart';
import 'package:medminder/Home/settings.dart';
import 'package:medminder/Schedule/scheduleInfo.dart';
import 'package:medminder/custom.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medminder/getStarted/userAuth.dart';

class AppHome extends StatefulWidget {
  @override
  AppHomeState createState() => AppHomeState();
}

class AppHomeState extends State<AppHome> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Update the type annotation for medications
  Map<String, Map<String, dynamic>> medications = {};

  @override
  void initState() {
    super.initState();
    getCurrentDayMedications();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void clearSearch() {
    setState(() {
      searchController.clear();
      searchQuery = '';
    });
  }

  Future<void> getCurrentDayMedications() async {
    try {
      String? userId = userAuth.getId();
      DateTime now = DateTime.now();
      String currentDay = DateFormat('EEEE').format(now);

      QuerySnapshot querySnapshot = await firestore
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
            .contains(searchQuery.toLowerCase()))
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
                                  builder: (context) => UserSettings()),
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
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
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
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear,
                                      color: Color(0xFF00ABE1)),
                                  onPressed: clearSearch,
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
                                        buildMedicationCard(med),
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

  Widget buildMedicationCard(Map<String, dynamic> med) {
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
          borderColor = Color(0xFFF44336);
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
}
