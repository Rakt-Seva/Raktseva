import 'package:flutter/material.dart';

class DonationRequestPage extends StatelessWidget {
  final List<Map<String, String>> donationRequests = [
    {
      "name": "Amir Hamza",
      "location": "Hertford British Hospital",
      "time": "5 Min Ago",
      "bloodType": "B+"
    },
    {
      "name": "Abdul Qader",
      "location": "Apollo Hospital",
      "time": "16 Min Ago",
      "bloodType": "B+"
    },
    {
      "name": "Irfan Hasan",
      "location": "Square Hospital",
      "time": "45 Min Ago",
      "bloodType": "B+"
    },
    {
      "name": "Ertugrul Gazi",
      "location": "Popular Hospital",
      "time": "59 Min Ago",
      "bloodType": "B+"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Donation Request",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: donationRequests.length,
          itemBuilder: (context, index) {
            final request = donationRequests[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.only(bottom: 16),
              color: Colors.grey.shade100,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Text(request["name"]!, style: TextStyle(fontSize: 18)),
                        SizedBox(height: 5),
                        Text("Location", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Text(request["location"]!, style: TextStyle(fontSize: 16)),
                        SizedBox(height: 5),
                        Text(request["time"]!, style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.bloodtype, color: Colors.red, size: 40),
                        Text(
                          request["bloodType"]!,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: Text("Donate", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
