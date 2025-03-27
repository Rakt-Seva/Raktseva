import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CreateRequestPage extends StatefulWidget {
  @override
  _CreateRequestPageState createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String? selectedState;
  String? selectedCity;
  String? selectedBloodType;
  String? selectedTime;

  List<String> states = [];
  List<String> cities = [];
  final List<String> bloodTypes = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];
  final List<String> timeOptions = ["1 Hour", "2 Hours", "6 Hours", "12 Hours", "1 Day"];
  Map<String, dynamic> stateCityData = {};

  @override
  void initState() {
    super.initState();
    loadStateCityData(); // Load JSON when the page initializes
  }

  // Load State and City Data from JSON
  Future<void> loadStateCityData() async {
    String data = await rootBundle.loadString('assets/st_ct.json.json');
    final jsonResult = json.decode(data);
    setState(() {
      stateCityData = jsonResult;
      states = stateCityData.keys.toList();
    });
  }

  // Update City List when State is Selected
  void updateCities(String? state) {
    if (state != null && stateCityData.containsKey(state)) {
      setState(() {
        cities = List<String>.from(stateCityData[state]);
        selectedCity = null; // Reset city when state changes
      });
    } else {
      setState(() {
        cities = [];
        selectedCity = null;
      });
    }
  }

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
            // State Dropdown
            _buildDropdown("Select State", selectedState, states, Icons.map, (value) {
              setState(() {
                selectedState = value;
                updateCities(value); // Load cities when state changes
              });
            }),

            SizedBox(height: 10),

            // City Dropdown
            _buildDropdown("Select City", selectedCity, cities, Icons.location_city, (value) {
              setState(() {
                selectedCity = value;
              });
            }),

            SizedBox(height: 10),

            // Blood Type Dropdown
            _buildDropdown("Select Blood Type", selectedBloodType, bloodTypes, Icons.bloodtype, (value) {
              setState(() {
                selectedBloodType = value;
              });
            }),

            SizedBox(height: 10),

            // Mobile Input
            _buildInputField(Icons.phone, "Mobile", mobileController, keyboardType: TextInputType.phone),

            SizedBox(height: 10),

            // Time Needed Dropdown
            _buildDropdown("Time Required", selectedTime, timeOptions, Icons.access_time, (value) {
              setState(() {
                selectedTime = value;
              });
            }),

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

  // Dropdown Widget
  Widget _buildDropdown(String hint, String? selectedValue, List<String> items, IconData icon, Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Row(
            children: [
              Icon(icon, color: Colors.red),
              SizedBox(width: 10),
              Text(hint),
            ],
          ),
          isExpanded: true,
          items: items.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: onChanged,
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
