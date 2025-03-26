import 'package:flutter/material.dart';
import 'eligibilitycheck.dart'; // Make sure this is correctly imported
import 'donationhistory.dart'; // Import donation history page
import 'rewards_page.dart'; // Import rewards page

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String eligibilityStatus = "No"; // Default status
  int rewardPoints = 500; // Initial reward points
  List<Map<String, String>> donationHistory = []; // Track donation history

  void _navigateToEligibilityCheck() async {
    // Navigate to the EligibilityCheckPage and await the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EligibilityCheckPage()),
    );

    // Check if the result is not null and is of type bool
    if (result != null && result is bool) {
      setState(() {
        eligibilityStatus = result ? "Yes" : "No"; // Update eligibility status
      });

      // If eligible and user donates, add 100 points and update history
      if (result) {
        _addDonation("25 March 2025", "Donated A+ blood at XYZ Hospital");
      }
    }
  }

  // Method to add donation and update points
  void _addDonation(String date, String details) {
    setState(() {
      donationHistory.add({'date': date, 'details': details});
      rewardPoints += 100; // Add 100 points for each donation
    });
    _showMessage("Donation recorded! You earned 100 points 🎉");
  }

  // Method to add reward points directly
  void _addRewardPoints(int points) {
    setState(() {
      rewardPoints += points;
    });
    _showMessage("You earned $points points! 🎉");
  }

  // Method to redeem points
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

  // Show a confirmation message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Navigate to donation history page
  void _navigateToDonationHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DonationHistoryPage(donationHistory: donationHistory),
      ),
    );
  }

  // Navigate to rewards page
  void _navigateToRewardsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RewardsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text("Profile", style: TextStyle(color: Colors.black)),
        actions: [
          Icon(Icons.edit, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              SizedBox(height: 10),
              Text("Tanvi Kathole",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text("📍 Thane, India", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 20),

              // Blood Type, Donated, Requested Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoCard("A+", "Blood Type"),
                  _buildInfoCard("${donationHistory.length}", "Donated"),
                  _buildInfoCard("02", "Requested"),
                ],
              ),
              SizedBox(height: 20),

              // Profile Option for eligibility status and rewards
              _buildProfileOption(
                title: "Eligible to donate: $eligibilityStatus",
                icon: Icons.check_circle,
                onTap: _navigateToEligibilityCheck,
              ),
              _buildProfileOption(
                title: "Reward Points",
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
                  title: "Sign out", icon: Icons.logout, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build info card for Blood Type, Donated, Requested
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

  // Method to build profile options like eligibility check, rewards, and help
  Widget _buildProfileOption(
      {required String title,
        required IconData icon,
        VoidCallback? onTap,
        Color color = Colors.black}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
    );
  }
}
