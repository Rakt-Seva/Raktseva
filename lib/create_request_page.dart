import 'package:flutter/material.dart';


class CreateRequestPage extends StatefulWidget {
  @override
  _CreateRequestPageState createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String? selectedBloodType; // Stores selected blood type
  final List<String> bloodTypes = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Create A Request", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // City Input
            _buildInputField(Icons.location_on, "City", cityController),

            SizedBox(height: 10),

            // Hospital Input
            _buildInputField(Icons.local_hospital, "Hospital", hospitalController),

            SizedBox(height: 10),

            // Blood Type Dropdown
            _buildDropdown(),

            SizedBox(height: 10),

            // Mobile Input
            _buildInputField(Icons.phone, "Mobile", mobileController, keyboardType: TextInputType.phone),

            SizedBox(height: 10),

            // Add a Note Input
            _buildInputField(Icons.note, "Add a note", noteController, maxLines: 3),

            SizedBox(height: 20),

            // Request Button
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
              ),
              child: Text("Request", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // Blood Type Dropdown Widget
  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedBloodType,
          hint: Row(
            children: [
              Icon(Icons.bloodtype, color: Colors.red),
              SizedBox(width: 10),
              Text("Select Blood Type"),
            ],
          ),
          isExpanded: true,
          items: bloodTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedBloodType = value;
            });
          },
        ),
      ),
    );
  }

  // Input Field Widget
  Widget _buildInputField(IconData icon, String hint, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.red),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Show Confirmation Dialog
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text("Request Submitted"),
          content: Text("Your blood donation request has been submitted successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
