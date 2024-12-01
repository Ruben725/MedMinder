import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> _selectTime(BuildContext context, {int? index}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: index != null ? _medicineTimes[index] : TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (index != null) {
          _medicineTimes[index] = picked;
        } else {
          _medicineTimes.add(picked);
        }
      });
    }
  }

  void _removeTime(int index) {
    setState(() {
      _medicineTimes.removeAt(index);
    });
  }

  List<TimeOfDay> _medicineTimes = [];

  Widget _buildTimesSection() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.add, color: Color(0xFF4681F4)),
              onPressed: () => _selectTime(context),
            ),
            Text(
              'Add Time',
              style: TextStyle(
                color: Color(0xFF4681F4),
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Column(
          children: List.generate(_medicineTimes.length, (index) {
            return Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.red),
                  onPressed: () => _removeTime(index),
                ),
                Text(
                  _medicineTimes[index].format(context),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _selectTime(context, index: index),
                ),
              ],
            );
          }),
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
              onPressed: () {
                // Determine days to take medication based on frequency
                List<String> medicationDays = [];

                switch (_selectedFrequency) {
                  case 'Daily':
                    // If Daily, use all days of the week
                    medicationDays = _daysOfWeek;
                    break;

                  case 'Weekly':
                    // If Weekly, use the current day of the week
                    final now = DateTime.now();
                    final currentDay = _daysOfWeek[now.weekday - 1];
                    medicationDays = [currentDay];
                    break;

                  case 'Selected Days':
                    // Use already selected days
                    medicationDays = _selectedDays;
                    break;

                  case 'As Needed':
                    // No specific days for 'As Needed'
                    medicationDays = [];
                    break;
                }

                //print the id of the user, test for sending data to firebase
                print('User ID: ${userAuth.getId()}');

                // Print medication name if it was passed
                if (widget.medicationName != null) {
                  print('Medication: ${widget.medicationName}');
                }

                // Print all selected information
                print('Frequency: $_selectedFrequency');

                // Print medication days
                print('Medication Days: ${medicationDays.join(', ')}');

                print('Number of Pills: $_numberOfPills');
                print(
                    'Medicine Strength: ${_strengthController.text} $_selectedStrengthUnit');

                // Print medicine times
                print('Medicine Times:');
                for (var time in _medicineTimes) {
                  print('- ${time.format(context)}');
                }

                // Navigate to medications list
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MedicationsList()),
                  (Route<dynamic> route) => false,
                );
              },
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
