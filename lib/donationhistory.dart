import 'package:flutter/material.dart';

class DonationHistoryPage extends StatelessWidget {
  final List<Map<String, String>> donationHistory;

  DonationHistoryPage({required this.donationHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donation History"),
        backgroundColor: Colors.red,
      ),
      body: donationHistory.isEmpty
          ? Center(
        child: Text(
          "No donations yet!",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: donationHistory.length,
        itemBuilder: (context, index) {
          final history = donationHistory[index];
          return ListTile(
            leading: Icon(Icons.bloodtype, color: Colors.red),
            title: Text(
              history['date'] ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              history['details'] ?? '',
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
