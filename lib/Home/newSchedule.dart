import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medminder/Home/medicationsList.dart';
import 'package:medminder/getStarted/userAuth.dart';
import 'package:medminder/custom.dart';
import 'scheduleUtil.dart';

class NewSchedule extends StatefulWidget {
  final String? medicationName;

  const NewSchedule({Key? key, this.medicationName}) : super(key: key);

  @override
  newScheduleState createState() => newScheduleState();
}

class newScheduleState extends State<NewSchedule> {
  String selectedFrequency = 'Daily';

  // Days of the week selection
  final List<String> daysOfWeek = ScheduleUtils.daysOfWeek;
  List<String> selectedDays = [];

  int numberOfPills = 1;
  final TextEditingController strengthController = TextEditingController();
  String selectedStrengthUnit = 'mg';

  // Changed from List to single TimeOfDay
  TimeOfDay? medicineTime;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _incrementPills() {
    setState(() {
      numberOfPills++;
    });
  }

  void _decrementPills() {
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

  Future<void> saveMedicationToFirestore(BuildContext context) async {
    try {
      // Validate required fields
      if (widget.medicationName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Medication name is required')),
        );
        return;
      }

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

      switch (selectedFrequency) {
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

      // Convert medicine time to 24-hour format for storage
      final medicineTimeString =
          ScheduleUtils.convert24HourTo12Hour(medicineTime!);

      // Prepare medication data
      Map<String, dynamic> medicationData = {
        'userId': userAuth.getId(),
        'medicationName': widget.medicationName,
        'frequency': selectedFrequency,
        'days': medicationDays,
        'numberOfPills': numberOfPills,
        'strength': '${strengthController.text} $selectedStrengthUnit',
        'time': medicineTimeString,
        'status': false,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save to Firestore
      await _firestore.collection('MedicationSchedule').add(medicationData);

      showPopup(
        context: context,
        icon: Icons.check_circle,
        message: 'Schedule Created Successfully!',
      );
    } catch (e) {
      // Handle any errors
      print('Error saving medication: $e');
      showPopup(
          context: context,
          icon: Icons.cancel,
          message: 'Failed to save medication schedule',
          iconColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Center(
                child: Text(
                  'Medication\nSchedule',
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
                currentFrequency: selectedFrequency,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFrequency = newValue!;
                    selectedDays.clear();
                  });
                },
              ),

              // Conditionally show days selection
              if (selectedFrequency == 'Selected Days') ...[
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
                onIncrement: _incrementPills,
                onDecrement: _decrementPills,
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
      ),
      bottomNavigationBar: _buildActionButtons(context),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
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
              child: Text('Back'),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => saveMedicationToFirestore(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00A624).withOpacity(0.5),
                foregroundColor: Colors.black,
                side: BorderSide(color: Color(0xFF00A624)),
              ),
              child: Text('Create'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    strengthController.dispose();
    super.dispose();
  }
}
