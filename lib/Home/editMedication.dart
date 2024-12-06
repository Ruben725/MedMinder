import 'package:flutter/material.dart';
import 'package:medminder/custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medminder/Home/medicationsList.dart'; // For navigation
import 'package:medminder/getStarted/userAuth.dart'; // for userid pull for remove and edit buttons
import 'package:medminder/Home/editSchedule.dart'; // For navigation

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
          title: Text(
            'Remove Medication',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Poppins',
            ),
          ),
          content: Text(
            'Are you sure you want to remove this medication?',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Remove',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                try {
                  String? userId = userAuth.getId();

                  CollectionReference medicationSchedule = FirebaseFirestore
                      .instance
                      .collection('MedicationSchedule');

                  QuerySnapshot querySnapshot = await medicationSchedule
                      .where('userId', isEqualTo: userId)
                      .where('medicationName', isEqualTo: widget.medicationName)
                      .get();

                  for (var doc in querySnapshot.docs) {
                    await doc.reference.delete();
                  }

                  showPopup(
                      context: context,
                      icon: Icons.check_circle,
                      message: 'Medication Removed Successfully!');
                } catch (error) {
                  print('Error removing medication: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to remove medication')),
                  );
                }
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
            Custom.buildInfoSection('Information:',
                _medicationData?['summary'] ?? 'No summary available'),
            SizedBox(height: 16),
            Custom.buildMapSection('Recommended Consumption:',
                _medicationData?['recommended_consumption_method'] ?? {}),
            SizedBox(height: 16),
            Custom.buildInfoSection(
                'Food Interactions:',
                _medicationData?['food_interaction'] ??
                    'No known interactions'),
            SizedBox(height: 16),
            Custom.buildListSection(
                'Foods to Avoid:', _medicationData?['foods_to_avoid'] ?? []),
            SizedBox(height: 16),
            Custom.buildListSection(
                'Side Effects:', _medicationData?['side_effects'] ?? []),
            SizedBox(height: 16),
            Custom.buildListSection(
                'Brand Name:', _medicationData?['brand_name'] ?? []),
            SizedBox(height: 16),
            Custom.buildListSection(
                'Synonyms:', _medicationData?['synonym'] ?? []),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  _buildActionButton('Edit', Colors.grey, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditSchedule(
                                medicationName: widget.medicationName)));
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
