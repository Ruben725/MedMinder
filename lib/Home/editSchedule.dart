import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medminder/Home/medicationsList.dart';
import 'package:medminder/getStarted/userAuth.dart';
import 'package:medminder/custom.dart';

class EditSchedule extends StatefulWidget {
  final String medicationName;

  const EditSchedule({Key? key, required this.medicationName})
      : super(key: key);

  @override
  _EditScheduleState createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
  // Variables to hold current schedule data
  String _currentFrequency = 'Daily';
  final List<String> _frequencyOptions = [
    'Daily',
    'Weekly',
    'Selected Days',
    'As Needed'
  ];

  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  List<String> _selectedDays = [];

  int _numberOfPills = 1;
  final TextEditingController _strengthController = TextEditingController();
  final List<String> _strengthUnits = ['mg', 'mcg'];
  String _selectedStrengthUnit = 'mg';
  TimeOfDay? _medicineTime;
  DocumentSnapshot? _currentScheduleDocument;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchCurrentSchedule();
  }

  void _fetchCurrentSchedule() async {
    try {
      // Get the current user's ID
      String? userId = userAuth.getId();

      // Query to find the specific medication schedule document
      QuerySnapshot querySnapshot = await _firestore
          .collection('MedicationSchedule')
          .where('userId', isEqualTo: userId)
          .where('medicationName', isEqualTo: widget.medicationName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first matching document
        DocumentSnapshot scheduleDoc = querySnapshot.docs.first;

        setState(() {
          _currentScheduleDocument = scheduleDoc;

          // Populate fields from Firestore data
          _currentFrequency = scheduleDoc['frequency'] ?? 'Daily';
          _numberOfPills = scheduleDoc['numberOfPills'] ?? 1;

          // Parse strength
          String strengthWithUnit = scheduleDoc['strength'] ?? '1 mg';
          List<String> strengthParts = strengthWithUnit.split(' ');
          _strengthController.text = strengthParts[0];
          _selectedStrengthUnit = strengthParts[1];

          // Parse time
          TimeOfDay parsedTime = _parseTimeString(scheduleDoc['time']);
          _medicineTime = parsedTime;

          // Populate selected days
          _selectedDays = List<String>.from(scheduleDoc['days'] ?? []);
        });
      } else {
        setState(() {
          _currentScheduleDocument = null;
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

  TimeOfDay _parseTimeString(String timeString) {
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

  Future<void> _updateMedicationSchedule() async {
    try {
      // Validate required fields
      if (_medicineTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a time')),
        );
        return;
      }

      if (_strengthController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter medication strength')),
        );
        return;
      }

      // Determine days to take medication based on frequency
      List<String> medicationDays = [];
      switch (_currentFrequency) {
        case 'Daily':
          medicationDays = _daysOfWeek;
          break;
        case 'Weekly':
          final now = DateTime.now();
          final currentDay = _daysOfWeek[now.weekday - 1];
          medicationDays = [currentDay];
          break;
        case 'Selected Days':
          medicationDays = _selectedDays;
          break;
        case 'As Needed':
          medicationDays = [];
          break;
      }

      // Convert medicine time to 12-hour format
      final medicineTimeString = _convert24HourTo12Hour(_medicineTime!);

      // Prepare updated medication data
      Map<String, dynamic> updatedData = {
        'frequency': _currentFrequency,
        'days': medicationDays,
        'numberOfPills': _numberOfPills,
        'strength': '${_strengthController.text} $_selectedStrengthUnit',
        'time': medicineTimeString,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update the document
      if (_currentScheduleDocument != null) {
        await _currentScheduleDocument!.reference.update(updatedData);

        // Inside _updateMedicationSchedule method
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

  // Helper function to convert TimeOfDay to 12-hour format string
  String _convert24HourTo12Hour(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final convertedHour = hour % 12;
    final displayHour = convertedHour == 0 ? 12 : convertedHour;

    return '${displayHour}:${minute.toString().padLeft(2, '0')} $amPm';
  }

  // Most of the widget building methods can be similar to those in NewSchedule
  // I'll include a few key methods here, but you can copy most from NewSchedule

  Widget _buildFrequencyDropdown() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        value: _currentFrequency,
        isExpanded: true,
        underline: SizedBox(),
        dropdownColor: Color(0xFFD9D9D9),
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'Poppins',
        ),
        items: _frequencyOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _currentFrequency = newValue!;
            // Reset selected days when changing frequency
            _selectedDays.clear();
          });
        },
      ),
    );
  }

  Widget _buildDaysSelectionSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _daysOfWeek.map((day) {
          final isSelected = _selectedDays.contains(day);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedDays.remove(day);
                } else {
                  _selectedDays.add(day);
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF00A624) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF00A624)),
              ),
              child: Text(
                day,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 2,
      color: Color(0xFF00A624),
    );
  }

  Widget _buildStrengthSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _strengthController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              decoration: InputDecoration(
                hintText: 'Enter Strength',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedStrengthUnit,
              underline: SizedBox(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins',
              ),
              items: _strengthUnits.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStrengthUnit = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _incrementPills() {
    setState(() {
      _numberOfPills++;
    });
  }

  void _decrementPills() {
    setState(() {
      if (_numberOfPills > 1) {
        _numberOfPills--;
      }
    });
  }

  Widget _buildPillCountSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.remove, color: Colors.black),
            onPressed: _decrementPills,
          ),
          Text(
            '$_numberOfPills',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Poppins',
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: _incrementPills,
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _medicineTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _medicineTime = picked;
      });
    }
  }

  Widget _buildTimesSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _medicineTime != null
                      ? _medicineTime!.format(context)
                      : 'Select Time',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
                Icon(Icons.access_time, color: Color(0xFF4681F4)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _currentScheduleDocument != null
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
                    // Add similar sections for Frequency, Number of Pills, etc.
                    // from NewSchedule, implementing each with similar logic
                    // Include conditional sections like in NewSchedule
                    _buildDivider(),
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
                    _buildFrequencyDropdown(),

                    // Conditionally show days selection
                    if (_currentFrequency == 'Selected Days') ...[
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
                      _buildDaysSelectionSection(),
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
                    _buildPillCountSection(),
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
                    _buildStrengthSection(),
                    SizedBox(height: 20),
                    Text(
                      'Times',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildTimesSection(),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
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
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _updateMedicationSchedule,
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
    _strengthController.dispose();
    super.dispose();
  }
}
