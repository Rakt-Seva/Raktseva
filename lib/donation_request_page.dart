import 'package:flutter/material.dart';
import 'request_detail_page.dart';

class DonationRequestPage extends StatelessWidget {
  final List<Map<String, dynamic>> donationRequests = [
    {
      "name": "Amir Hamza",
      "location": "Hertford British Hospital",
      "time": "5 Min Ago",
      "bloodType": "B+",
      "latitude": 48.8584,
      "longitude": 2.2945,
    },
    {
      "name": "Abdul Qader",
      "location": "Apollo Hospital",
      "time": "16 Min Ago",
      "bloodType": "B+",
      "latitude": 28.5623,
      "longitude": 77.2906,
    },
    {
      "name": "Irfan Hasan",
      "location": "Square Hospital",
      "time": "45 Min Ago",
      "bloodType": "B+",
      "latitude": 23.7510,
      "longitude": 90.3845,
    },
    {
      "name": "Ertugrul Gazi",
      "location": "Popular Hospital",
      "time": "59 Min Ago",
      "bloodType": "B+",
      "latitude": 41.0082,
      "longitude": 28.9784,
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
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestDetailPage(
                      name: request["name"],
                      bloodGroup: request["bloodType"],
                      timePosted: request["time"],
                      location: request["location"], // ✅ Included
                      latitude: request["latitude"],
                      longitude: request["longitude"],
                    ),
                  ),
                );
              },
              child: Card(
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
                          Text(request["name"], style: TextStyle(fontSize: 18)),
                          SizedBox(height: 5),
                          Text("Location", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                          Text(request["location"], style: TextStyle(fontSize: 16)),
                          SizedBox(height: 5),
                          Text(request["time"], style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.bloodtype, color: Colors.red, size: 40),
                          Text(
                            request["bloodType"],
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
