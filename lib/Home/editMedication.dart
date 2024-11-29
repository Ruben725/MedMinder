import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medminder/Home/medicationsList.dart'; // For navigation

class EditMedication extends StatefulWidget {
  final String medicationName;

  const EditMedication({Key? key, required this.medicationName})
      : super(key: key);

  @override
  _EditMedicationState createState() => _EditMedicationState();
}

class _EditMedicationState extends State<EditMedication> {
  Map<String, dynamic>? _medicationData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedicationDetails();
  }

  void _fetchMedicationDetails() async {
    try {
      CollectionReference drugDataCollection =
          FirebaseFirestore.instance.collection('DrugData');

      // Capitalize the first letter to match Firestore document ID
      String capitalizedName =
          widget.medicationName.substring(0, 1).toUpperCase() +
              widget.medicationName.substring(1).toLowerCase();

      DocumentSnapshot documentSnapshot =
          await drugDataCollection.doc(capitalizedName).get();

      if (documentSnapshot.exists) {
        setState(() {
          _medicationData = documentSnapshot.data() as Map<String, dynamic>?;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Medication details not found');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error retrieving medication details');
      print('Error retrieving medication details: $error');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Optionally navigate back to medications list
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MedicationsList()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _removeMedication() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Medication'),
          content: Text('Are you sure you want to remove this medication?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Remove'),
              onPressed: () {
                // Add remove functionality here
                // For example, remove from Firestore or local storage
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MedicationsList()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content
          Positioned.fill(
            bottom: 70, // Account for bottom nav bar height
            top: 40,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildMedicationDetails(),
          ),

          // Sticky Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Custom.bottomNav(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationDetails() {
    if (_medicationData == null) {
      return Center(
        child: Text(
          'No medication details available',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                widget.medicationName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Color(0xFF00A624),
              thickness: 2,
            ),
            const SizedBox(height: 16),
            // Summary
            _buildInfoSection('Information:',
                _medicationData?['summary'] ?? 'No summary available'),
            SizedBox(height: 16),

            // Consumption Method
            _buildMapSection('Recommended Consumption:',
                _medicationData?['recommended_consumption_method'] ?? {}),
            SizedBox(height: 16),

            // Food Interactions
            _buildInfoSection(
                'Food Interactions:',
                _medicationData?['food_interaction'] ??
                    'No known interactions'),
            SizedBox(height: 16),

            // Foods to Avoid
            _buildListSection(
                'Foods to Avoid:', _medicationData?['foods_to_avoid'] ?? []),
            SizedBox(height: 16),

            // Dosage
            _buildInfoRow(
                'Dosage:', _medicationData?['dosage'] ?? 'Not specified'),
            SizedBox(height: 16),

            // Side Effects
            _buildListSection(
                'Side Effects:', _medicationData?['side_effects'] ?? []),
            SizedBox(height: 16),

            // Brand Name
            _buildListSection(
                'Brand Name:', _medicationData?['brand_name'] ?? []),
            SizedBox(height: 16),

            // Synonyms
            _buildListSection('Synonyms:', _medicationData?['synonym'] ?? []),

            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  _buildActionButton('Edit', Colors.grey, () {
                    // Add edit functionality
                    // You might want to navigate to an edit form
                  }),
                  const SizedBox(height: 16),
                  _buildActionButton('Remove', Colors.red, _removeMedication),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection(String title, Map items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: items.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items.entries
                      .map((entry) => Text(
                            '• ${entry.key.replaceAll('_', ' ')}: ${entry.value}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ))
                      .toList(),
                )
              : Text(
                  'No consumption method details available',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.italic,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildListSection(String label, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: items.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items
                      .map((item) => Text(
                            '• $item',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ))
                      .toList(),
                )
              : Text(
                  'No items listed',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.italic,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: color, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(200, 40),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}