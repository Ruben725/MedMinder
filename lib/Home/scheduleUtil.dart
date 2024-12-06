import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScheduleUtils {
  static final List<String> frequencyOptions = [
    'Daily',
    'Weekly',
    'Selected Days',
    'As Needed'
  ];

  static final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  static final List<String> strengthUnits = ['mg', 'mcg'];

  // Time conversion method
  static String convert24HourTo12Hour(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final convertedHour = hour % 12;
    final displayHour = convertedHour == 0 ? 12 : convertedHour;

    return '${displayHour}:${minute.toString().padLeft(2, '0')} $amPm';
  }

  // Shared UI Components
  static Widget buildDivider() {
    return Container(
      width: double.infinity,
      height: 2,
      color: Color(0xFF00A624),
    );
  }

  // Frequency Dropdown Styling
  static Widget buildFrequencyDropdown({
    required String currentFrequency,
    required void Function(String?) onChanged,
    bool isExpanded = true,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        value: currentFrequency,
        isExpanded: isExpanded,
        underline: SizedBox(),
        dropdownColor: Color(0xFFD9D9D9),
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'Poppins',
        ),
        items: frequencyOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  // Days Selection Section
  static Widget buildDaysSelectionSection({
    required List<String> selectedDays,
    required void Function(String) onDayTap,
  }) {
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
        children: daysOfWeek.map((day) {
          final isSelected = selectedDays.contains(day);
          return GestureDetector(
            onTap: () => onDayTap(day),
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

  // Pill Count Section
  static Widget buildPillCountSection({
    required int numberOfPills,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
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
            onPressed: onDecrement,
          ),
          Text(
            '$numberOfPills',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Poppins',
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }

  // Strength Section
  static Widget buildStrengthSection({
    required TextEditingController strengthController,
    required String selectedStrengthUnit,
    required void Function(String?) onUnitChanged,
  }) {
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
              controller: strengthController,
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
              value: selectedStrengthUnit,
              underline: SizedBox(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins',
              ),
              items: strengthUnits.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onUnitChanged,
            ),
          ),
        ],
      ),
    );
  }

  // Time Selection Section
  static Widget buildTimesSection({
    required BuildContext context,
    required TimeOfDay? medicineTime,
    required VoidCallback onSelectTime,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onSelectTime,
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
                  medicineTime != null
                      ? medicineTime.format(context)
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
}
