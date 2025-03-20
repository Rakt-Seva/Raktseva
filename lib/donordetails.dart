import 'package:flutter/material.dart';

class DonorDetailsPage extends StatelessWidget {
  final Map<String, String> donor; // Receive donor details

  DonorDetailsPage({required this.donor}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(donor["name"]!),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(donor["image"]!), // Dynamic image
                      ),
                      SizedBox(height: 10),
                      Text(
                        donor["name"]!,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "📍 ${donor["location"]!}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.water_drop, color: Colors.red),
                              Text(
                                "6 Times Donated",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.bloodtype, color: Colors.red),
                              Text(
                                "Blood Type - ${donor["blood"]!}",
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.call),
                            label: Text("Call Now"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.request_page),
                            label: Text("Request"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
