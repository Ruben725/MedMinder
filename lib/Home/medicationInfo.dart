import 'package:flutter/material.dart';
import 'package:medminder/Home/medicationsList.dart'; // Import the home page

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
  void _handleMedicationAdd(BuildContext context) {
    // Add your logic for marking medication as taken
    // For example, you might want to:
    // - Update a database or local storage
    // - Log the medication intake
    // - Check if the medication schedule is followed

    // Navigate to home page and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MedicationsList()),
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
                      _buildInfoSection('Information:', summary),
                      SizedBox(height: 16),

                      // Consumption Method
                      _buildMapSection(
                          'Recommended Consumption:', consumptionMethod),
                      SizedBox(height: 16),

                      // Food Interactions
                      _buildInfoSection('Food Interactions:', foodInteractions),
                      SizedBox(height: 16),

                      // Foods to Avoid
                      _buildListSection('Foods to Avoid:', foodsToAvoid),
                      SizedBox(height: 16),

                      // Dosage
                      _buildInfoRow('Dosage:', dosage),
                      SizedBox(height: 16),

                      // Side Effects
                      _buildListSection('Side Effects:', sideEffects),
                      SizedBox(height: 16),

                      // Brand Name
                      _buildListSection('Brand Name:', brandName),
                      SizedBox(height: 16),

                      // Synonyms
                      _buildListSection('Synonyms:', synonyms),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Buttons Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildActionButtons(context),
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
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, String content) {
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
        Text(
          content,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildListSection(String title, List items) {
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
        items.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items
                    .map((item) => Text(
                          '• $item',
                          style: TextStyle(
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
        items.isNotEmpty
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
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
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
            onPressed: () => _handleMedicationAdd(context),
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
