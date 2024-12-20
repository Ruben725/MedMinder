import 'package:flutter/material.dart';
import 'package:medminder/Medication/medicationsList.dart';
import 'package:medminder/Schedule/newSchedule.dart';
import 'package:medminder/custom.dart';

class MedicationInfo extends StatelessWidget {
  final String medicationName;
  final String dosage;
  final List brandName;
  final String foodInteractions;
  final List foodsToAvoid;
  final Map consumptionMethod;
  final List sideEffects;
  final String summary;
  final List synonyms;

  const MedicationInfo({
    Key? key,
    required this.medicationName,
    required this.dosage,
    required this.brandName,
    required this.foodInteractions,
    required this.foodsToAvoid,
    required this.consumptionMethod,
    required this.sideEffects,
    required this.summary,
    required this.synonyms,
  }) : super(key: key);

  // Function to handle medication being taken
  void addMed(BuildContext context) {
    // Navigate to NewSchedule and pass the medication name
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => NewSchedule(medicationName: medicationName),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        medicationName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(color: Color(0xFF00A624), thickness: 2),
                      SizedBox(height: 16),

                      // Summary
                      Custom.buildInfoSection('Information:', summary),
                      SizedBox(height: 16),

                      // Consumption Method
                      Custom.buildMapSection(
                          'Recommended Consumption:', consumptionMethod),
                      SizedBox(height: 16),

                      // Food Interactions
                      Custom.buildInfoSection(
                          'Food Interactions:', foodInteractions),
                      SizedBox(height: 16),

                      // Foods to Avoid
                      Custom.buildListSection('Foods to Avoid:', foodsToAvoid),
                      SizedBox(height: 16),

                      // Side Effects
                      Custom.buildListSection('Side Effects:', sideEffects),
                      SizedBox(height: 16),

                      // Brand Name
                      Custom.buildListSection('Brand Name:', brandName),
                      SizedBox(height: 16),

                      // Synonyms
                      Custom.buildListSection('Synonyms:', synonyms),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Buttons Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: actionButtons(context),
            ),
          ],
        ),
      ),
    );
  }

  // creates the back and Add Schedule buttons used for medInfo page navigation
  Widget actionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Navigate directly to home page and remove all previous routes
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
            onPressed: () => addMed(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00A624).withOpacity(0.5),
              foregroundColor: Colors.black,
              side: BorderSide(color: Color(0xFF00A624)),
            ),
            child: Text('Add'),
          ),
        ),
      ],
    );
  }
}
