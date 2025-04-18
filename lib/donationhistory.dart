import 'package:flutter/material.dart';

class DonationHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> donationHistory;

  DonationHistoryPage({required this.donationHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donation History"),
        backgroundColor: Colors.red,
      ),
      body: donationHistory.isEmpty
          ? Center(child: Text("No donation history available."))
          : ListView.builder(
        itemCount: donationHistory.length,
        itemBuilder: (context, index) {
          final donation = donationHistory[index];
          return ListTile(
            leading: Icon(Icons.bloodtype, color: Colors.red),
            title: Text(donation['details'] ?? "No details"),
            subtitle: Text(donation['date'] ?? "No date"),
          );
        },
      ),
    );
  }
}
