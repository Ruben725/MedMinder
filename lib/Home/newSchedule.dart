import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medminder/Home/medicationsList.dart';
import 'package:medminder/getStarted/userAuth.dart';

class NewSchedule extends StatefulWidget {
  final String? medicationName;

  const NewSchedule({Key? key, this.medicationName}) : super(key: key);

  @override
  _NewScheduleState createState() => _NewScheduleState();
}

class _NewScheduleState extends State<NewSchedule> {
  String _selectedFrequency = 'Daily';
  final List<String> _frequencyOptions = [
    'Daily',
    'Weekly',
    'Selected Days',
    'As Needed'
  ];

  // Days of the week selection
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

  // Changed from List to single TimeOfDay
  TimeOfDay? _medicineTime;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> _saveMedicationToFirestore(BuildContext context) async {
    try {
      // Validate required fields
      if (widget.medicationName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Medication name is required')),
        );
        return;
      }

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

      switch (_selectedFrequency) {
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

      // Convert medicine time to 24-hour format for storage
      final medicineTimeString = convert24HourTo12Hour(_medicineTime!);

      // Prepare medication data
      Map<String, dynamic> medicationData = {
        'userId': userAuth.getId(),
        'medicationName': widget.medicationName,
        'frequency': _selectedFrequency,
        'days': medicationDays,
        'numberOfPills': _numberOfPills,
        'strength': '${_strengthController.text} $_selectedStrengthUnit',
        'time': medicineTimeString,
        'status': false,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save to Firestore
      await _firestore.collection('MedicationSchedule').add(medicationData);

      // Navigate to medications list
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MedicationsList()),
        (Route<dynamic> route) => false,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medication schedule added successfully')),
      );
    } catch (e) {
      // Handle any errors
      print('Error saving medication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save medication schedule')),
      );
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
              if (_selectedFrequency == 'Selected Days') ...[
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
      ),
      bottomNavigationBar: _buildActionButtons(context),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 2,
      color: Color(0xFF00A624),
    );
  }

  Widget _buildFrequencyDropdown() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        value: _selectedFrequency,
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
            _selectedFrequency = newValue!;
            // Reset selected days when changing frequency
            _selectedDays.clear();
          });
        },
      ),
    );
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

  // Helper function to convert TimeOfDay to 12-hour format string
  String convert24HourTo12Hour(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final convertedHour = hour % 12;
    final displayHour = convertedHour == 0 ? 12 : convertedHour;

    return '${displayHour}:${minute.toString().padLeft(2, '0')} $amPm';
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
              onPressed: () => _saveMedicationToFirestore(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00A624).withOpacity(0.5),
                foregroundColor: Colors.black,
                side: BorderSide(color: Color(0xFF00A624)),
              ),
              child: Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _strengthController.dispose();
    super.dispose();
  }
}
