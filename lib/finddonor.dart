import 'package:flutter/material.dart';
import 'donordetails.dart'; // Import DonorDetailsPage

class FindDonorsScreen extends StatefulWidget {
  @override
  _FindDonorsScreenState createState() => _FindDonorsScreenState();
}

class _FindDonorsScreenState extends State<FindDonorsScreen> {
  String? selectedBloodType;
  String? selectedLocation;

  final List<Map<String, String>> donors = [
    {"name": "Tanvi Kathole", "location": "Maharashtra", "blood": "A+", "image": "assets/yasin.jpg"},
    {"name": "Shivam Borse", "location": "Delhi", "blood": "AB+", "image": "assets/sami.jpg"},
    {"name": "Bhushan Garmode", "location": "Assam", "blood": "B-", "image": "assets/rahim.jpg"},
    {"name": "Sahil Naorde", "location": "Kashmir", "blood": "O+", "image": "assets/rumana.jpg"},
    {"name": "Prarthana Bhalerao", "location": "Kerala", "blood": "A+", "image": "assets/jubayer.jpg"},
  ];

  List<Map<String, String>> get filteredDonors {
    return donors.where((donor) {
      bool matchesBlood = selectedBloodType == null || donor["blood"] == selectedBloodType;
      bool matchesLocation = selectedLocation == null || donor["location"] == selectedLocation;
      return matchesBlood && matchesLocation;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Find Donors", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar & Filter Button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        hintText: "Search donors...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.filter_list, color: Colors.red, size: 30),
                    onPressed: () {
                      _showFilterDialog();
                    },
                  ),
                ],
              ),
              SizedBox(height: 15),

              // Donor List
              Expanded(
                child: ListView.builder(
                  itemCount: filteredDonors.length,
                  itemBuilder: (context, index) {
                    return _buildDonorCard(context, filteredDonors[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Donor Card
  Widget _buildDonorCard(BuildContext context, Map<String, String> donor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(donor["image"]!),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donor["name"]!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.red),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          donor["location"]!,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                donor["blood"]!,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DonorDetailsPage(donor: donor),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Show Filter Dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Filter Donors"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Blood Type"),
                value: selectedBloodType,
                items: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() => selectedBloodType = value),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Location"),
                value: selectedLocation,
                items: ["Maharashtra", "Delhi", "Assam", "Kashmir", "Kerala"]
                    .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                    .toList(),
                onChanged: (value) => setState(() => selectedLocation = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedBloodType = null;
                  selectedLocation = null;
                });
                Navigator.pop(context);
              },
              child: Text("Clear"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Apply"),
            ),
          ],
        );
      },
    );
  }
}
