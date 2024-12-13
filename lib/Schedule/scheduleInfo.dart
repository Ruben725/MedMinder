import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medminder/Home/home.dart';
import 'package:medminder/getStarted/userAuth.dart';
import 'package:medminder/custom.dart';

class scheduleInfo extends StatefulWidget {
  final String medicationName;

  scheduleInfo({Key? key, required this.medicationName}) : super(key: key);

  @override
  scheduleInfoState createState() => scheduleInfoState();
}

class scheduleInfoState extends State<scheduleInfo> {
  DocumentSnapshot? currentScheduleDocument;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getCurrentSchedule();
  }

  void getCurrentSchedule() async {
    try {
      // Get the current user's ID
      String? userId = userAuth.getId();

      // Query to find the specific medication schedule document
      QuerySnapshot querySnapshot = await firestore
          .collection('MedicationSchedule')
          .where('userId', isEqualTo: userId)
          .where('medicationName', isEqualTo: widget.medicationName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first matching document
        DocumentSnapshot scheduleDoc = querySnapshot.docs.first;

        setState(() {
          currentScheduleDocument = scheduleDoc;
        });
      } else {
        setState(() {
          currentScheduleDocument = null;
        });
        showPopup(
            context: context,
            icon: Icons.cancel,
            message: 'No medication schedule\nwas found',
            iconColor: Colors.red);
      }
    } catch (error) {
      print('Error fetching medication schedule: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load medication schedule')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.medicationName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 14),
                      Divider(color: Color(0xFF00A624), thickness: 2),
                      SizedBox(height: 18),
                      if (currentScheduleDocument != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Custom.buildInfoSection('Dosage:',
                                currentScheduleDocument?['strength'] ?? 'N/A'),
                            SizedBox(height: 18),
                            Custom.buildInfoSection('Time:',
                                currentScheduleDocument?['time'] ?? 'N/A'),
                            SizedBox(height: 18),
                            Custom.buildInfoSection(
                                'Number of Pills:',
                                currentScheduleDocument?['numberOfPills']
                                        ?.toString() ??
                                    'N/A'),
                            SizedBox(height: 18),
                            Custom.buildInfoSection('Frequency:',
                                currentScheduleDocument?['frequency'] ?? 'N/A'),
                            SizedBox(height: 18),
                            if (currentScheduleDocument?['frequency'] ==
                                'Selected Days')
                              buildDaysDisplay(
                                  currentScheduleDocument?['days'] as List? ??
                                      []),
                          ],
                        )
                      else
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Buttons Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildActionButtons(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDaysDisplay(List<dynamic> selectedDaysInput) {
    // Convert dynamic list to List<String>
    final List<String> selectedDays = selectedDaysInput.cast<String>();

    // Sort days to ensure they are displayed in order from Monday to Sunday
    final daysOrder = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    selectedDays
        .sort((a, b) => daysOrder.indexOf(a).compareTo(daysOrder.indexOf(b)));

    // Create rows of days, max 3 per row
    List<List<String>> dayRows = [];
    for (int i = 0; i < selectedDays.length; i += 3) {
      dayRows.add(selectedDays.skip(i).take(3).toList());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Days:',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        ...dayRows.map((row) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: row
                    .map((day) => Expanded(
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ))
                    .toList(),
              ),
            )),
      ],
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Navigate directly to home page and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AppHome()),
                (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(color: Color(0xFF00A624)),
            ),
            child: Text('Back'),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => handleMedicationTaken(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00A624).withOpacity(0.5),
              foregroundColor: Colors.black,
              side: BorderSide(color: Color(0xFF00A624)),
            ),
            child: Text('Taken'),
          ),
        ),
      ],
    );
  }

  void handleMedicationTaken(BuildContext context) async {
    try {
      // Check if we have a current schedule document
      if (currentScheduleDocument != null) {
        // Get the document reference
        DocumentReference docRef = currentScheduleDocument!.reference;

        // Update the document to mark medication as taken
        await docRef.update({
          'status': true,
          'lastTakenTimestamp': FieldValue.serverTimestamp(),
        });

        // Show confirmation popup
        showPopup(
          context: context,
          icon: Icons.check_circle,
          message: '${widget.medicationName} medication\nhas been taken',
        );
      } else {
        // If no document found, show an error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No medication schedule found')),
        );
      }
    } catch (error) {
      print('Error marking medication as taken: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark medication as taken')),
      );
    }
  }
}

// showPopup specifically for scheduleInfo page; made to redirect to home page instead of medicationsList
void showPopup({
  required BuildContext context,
  required IconData icon,
  required String message,
  Color iconColor = const Color(0xFF00A624), // Default green color
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AppHome()),
          (Route<dynamic> route) => false,
        );
      });

      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 200,
              ),
              SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}