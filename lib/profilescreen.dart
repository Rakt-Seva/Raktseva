import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt/userController.dart';
import 'eligibilitycheck.dart';
import 'donationhistory.dart';
import 'rewards_page.dart';
import 'login.dart';
import 'homepage.dart';
import 'edit_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = "Loading...";
  String _address = "Loading...";
  String _blg = "-";
  String eligibilityStatus = "No";
  int rewardPoints = 500;
  List<Map<String, dynamic>> donationHistory = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs =await SharedPreferences.getInstance();
      String? uid = await prefs.getString('currentUser');
      UserController.instance.initAndListenToUser();
      print(uid);
      if (uid == null) return;


      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      print(data);
      print("ihbpfjastmne");
      if (data != null) {
        setState(() {
          _name = data['name'] ?? 'No name';
          _address = data['address'] ?? 'No address';
          _blg = data['blood_group'] ?? '-';
        });
      }
    } catch (e) {
      print("⚠️ Error loading user data: $e");
      _showMessage("Failed to load user data.");
    }
  }

  void _navigateToEligibilityCheck() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EligibilityCheckPage()),
    );

    if (result != null && result is bool) {
      setState(() {
        eligibilityStatus = result ? "Yes" : "No";
      });

      if (result) {
        _addDonation("25 March 2025", "Donated $_blg blood at XYZ Hospital");
      }
    }
  }

  void _addDonation(String date, String details) {
    setState(() {
      donationHistory.add({'date': date, 'details': details});
      rewardPoints += 100;
    });
    _showMessage("Donation recorded! You earned 100 points 🎉");
  }

  void _addRewardPoints(int points) {
    setState(() {
      rewardPoints += points;
    });
    _showMessage("You earned $points points! 🎉");
  }

  void _redeemPoints() {
    if (rewardPoints >= 200) {
      setState(() {
        rewardPoints -= 200;
      });
      _showMessage("200 points redeemed successfully! ✅");
    } else {
      _showMessage("Not enough points to redeem! ❗️");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  void _navigateToDonationHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonationHistoryPage(donationHistory: donationHistory),
      ),
    );
  }

  void _navigateToRewardsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RewardsPage()),
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    );
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: Text("Profile", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: _navigateToEditProfile,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
              ()=> CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(UserController.instance.userPhoto.value),
                  // backgroundImage: AssetImage('assets/profile.jpg'),
                ),
              ),
              SizedBox(height: 10),
              Text(_name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text("📍 $_address", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoCard(_blg, "Blood Type"),
                  _buildInfoCard("${donationHistory.length}", "Donated"),
                  _buildInfoCard("02", "Requested"),
                ],
              ),
              SizedBox(height: 20),
              Obx(
                ()=> _buildProfileOption(
                  title: "Eligible to donate: ${UserController.instance.eligibilityStatus.value?"Yes":"No"}",
                  icon: Icons.check_circle,
                  onTap: _navigateToEligibilityCheck,
                ),
              ),
              _buildProfileOption(
                title: "Reward Points: $rewardPoints",
                icon: Icons.star,
                onTap: _navigateToRewardsPage,
              ),
              _buildProfileOption(
                title: "Donation History",
                icon: Icons.history,
                onTap: _navigateToDonationHistory,
              ),
              _buildProfileOption(title: "Get help", icon: Icons.help_outline),
              _buildProfileOption(
                title: "Sign out",
                icon: Icons.logout,
                color: Colors.red,
                onTap: _signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildProfileOption({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
    );
  }
}
