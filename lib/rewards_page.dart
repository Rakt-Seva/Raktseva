import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardsPage extends StatefulWidget {
  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int rewardPoints = 500;
  List<Map<String, dynamic>> donationHistory = [];

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Fetch user points and donation history
  Future<void> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          rewardPoints = userDoc['points'] ?? 0;
          donationHistory = List<Map<String, dynamic>>.from(
              userDoc['donationHistory'] ?? []);
        });
      }
    }
  }

  // Redeem points logic
  void _redeemPoints() async {
    if (rewardPoints >= 100) {
      setState(() {
        rewardPoints -= 100;
      });

      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({'points': rewardPoints});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ 100 points redeemed successfully! 🎉')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❗️ Not enough points to redeem 😔')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reward System'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reward Points Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Points',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          '$rewardPoints',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _redeemPoints,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.redAccent,
                      ),
                      child: Text('Redeem'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Donation History Section
            Text(
              'Donation History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            donationHistory.isEmpty
                ? Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No donations yet! Start donating to earn points. ❤️',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: donationHistory.length,
              itemBuilder: (context, index) {
                var donation = donationHistory[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.bloodtype, color: Colors.red),
                    title: Text('Donation #${index + 1}'),
                    subtitle: Text(
                        'Points Earned: ${donation['points']} on ${donation['date']}'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
