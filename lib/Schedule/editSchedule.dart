import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medminder/Medication/medicationsList.dart';
import 'package:medminder/getStarted/userAuth.dart';
import 'package:medminder/custom.dart';
import 'scheduleUtil.dart';

class EditSchedule extends StatefulWidget {
  final String medicationName;

  const EditSchedule({Key? key, required this.medicationName})
      : super(key: key);

  @override
  EditScheduleState createState() => EditScheduleState();
}

class EditScheduleState extends State<EditSchedule> {
  // Variables to hold current schedule data
  String currentFrequency = 'Daily';

  final List<String> daysOfWeek = ScheduleUtils.daysOfWeek;
  List<String> selectedDays = [];

  int numberOfPills = 1;
  final TextEditingController strengthController = TextEditingController();
  String selectedStrengthUnit = 'mg';
  TimeOfDay? medicineTime;
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

          // Populate fields using Firestore data
          currentFrequency = scheduleDoc['frequency'] ?? 'Daily';
          numberOfPills = scheduleDoc['numberOfPills'] ?? 1;

          String strengthWithUnit = scheduleDoc['strength'] ?? '1 mg';
          List<String> strengthParts = strengthWithUnit.split(' ');
          strengthController.text = strengthParts[0];
          selectedStrengthUnit = strengthParts[1];

          TimeOfDay parsedTime = parseTimeString(scheduleDoc['time']);
          medicineTime = parsedTime;

          selectedDays = List<String>.from(scheduleDoc['days'] ?? []);
        });
      } else {
        setState(() {
          currentScheduleDocument = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No medication schedule found')),
        );
      }
    } catch (error) {
      print('Error fetching medication schedule: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load medication schedule')),
      );
    }
  }

  TimeOfDay parseTimeString(String timeString) {
    // Expects time in format like "10:30 AM"
    List<String> timeParts = timeString.split(' ');
    List<String> hourMinute = timeParts[0].split(':');

    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);

    // Adjust hour for PM
    if (timeParts[1] == 'PM' && hour != 12) {
      hour += 12;
    }
    // Adjust hour for 12 AM
    if (timeParts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> updateMedicationSchedule() async {
    try {
      // Validate required fields
      if (medicineTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a time')),
        );
        return;
      }

      if (strengthController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter medication strength')),
        );
        return;
      }

      // Determine days to take medication based on frequency
      List<String> medicationDays = [];
      switch (currentFrequency) {
        case 'Daily':
          medicationDays = daysOfWeek;
          break;
        case 'Weekly':
          final now = DateTime.now();
          final currentDay = daysOfWeek[now.weekday - 1];
          medicationDays = [currentDay];
          break;
        case 'Selected Days':
          medicationDays = selectedDays;
          break;
        case 'As Needed':
          medicationDays = [];
          break;
      }

      // Convert medicine time to 12-hour format
      final medicineTimeString =
          ScheduleUtils.convert24HourTo12Hour(medicineTime!);

      // Prepare updated medication data
      Map<String, dynamic> updatedData = {
        'frequency': currentFrequency,
        'days': medicationDays,
        'numberOfPills': numberOfPills,
        'strength': '${strengthController.text} $selectedStrengthUnit',
        'time': medicineTimeString,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update the document
      if (currentScheduleDocument != null) {
        await currentScheduleDocument!.reference.update(updatedData);

        // Show confirmation of successful update
        showPopup(
          context: context,
          icon: Icons.check_circle,
          message: 'Schedule Updated Successfully!',
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No medication schedule found to update')),
        );
      }
    } catch (e) {
      print('Error updating medication schedule: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update medication schedule')),
      );
      showPopup(
          context: context,
          icon: Icons.cancel,
          message: 'Failed to update medication schedule',
          iconColor: Colors.red);
    }
  }

  void incrementPills() {
    setState(() {
      numberOfPills++;
    });
  }

  void decrementPills() {
    setState(() {
      if (numberOfPills > 1) {
        numberOfPills--;
      }
    });
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: medicineTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        medicineTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: currentScheduleDocument != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Center(
                      child: Text(
                        'Edit Schedule',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    ScheduleUtils.buildDivider(),
                    SizedBox(height: 20),
                    Text(
                      'Frequency',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    ScheduleUtils.buildFrequencyDropdown(
                      currentFrequency: currentFrequency,
                      onChanged: (String? newValue) {
                        setState(() {
                          currentFrequency = newValue!;
                          selectedDays.clear();
                        });
                      },
                    ),

                    // Conditionally show days selection
                    if (currentFrequency == 'Selected Days') ...[
                      SizedBox(height: 20),
                      Text(
                        'Select Days',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10),
                      ScheduleUtils.buildDaysSelectionSection(
                        selectedDays: selectedDays,
                        onDayTap: (day) {
                          setState(() {
                            if (selectedDays.contains(day)) {
                              // If day is already selected, remove it
                              selectedDays.remove(day);
                            } else {
                              // If day is not selected, add it
                              selectedDays.add(day);
                            }
                          });
                        },
                      ),
                    ],

                    SizedBox(height: 20),
                    Text(
                      'Number of Pills',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    ScheduleUtils.buildPillCountSection(
                      numberOfPills: numberOfPills,
                      onIncrement: incrementPills,
                      onDecrement: decrementPills,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Medicine Strength',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    ScheduleUtils.buildStrengthSection(
                      strengthController: strengthController,
                      selectedStrengthUnit: selectedStrengthUnit,
                      onUnitChanged: (String? newUnit) {
                        setState(() {
                          if (newUnit != null) {
                            selectedStrengthUnit = newUnit;
                          }
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Time',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    ScheduleUtils.buildTimesSection(
                      context: context,
                      medicineTime: medicineTime,
                      onSelectTime: () => selectTime(context),
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: buildActionButtons(context),
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MedicationsList()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: BorderSide(color: Color(0xFF00A624)),
              ),
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: updateMedicationSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00A624).withOpacity(0.5),
                foregroundColor: Colors.black,
                side: BorderSide(color: Color(0xFF00A624)),
              ),
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    strengthController.dispose();
    super.dispose();
  }
}
