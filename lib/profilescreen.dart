import 'package:flutter/material.dart';
import 'eligibilitycheck.dart'; // Make sure this is correctly imported

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String eligibilityStatus = "No"; // Default status

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
    }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            SizedBox(height: 10),
            Text("Tanvi Kathole", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("📍 Thane, India", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),

            // Blood Type, Donated, Requested Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard("A+", "Blood Type"),
                _buildInfoCard("05", "Donated"),
                _buildInfoCard("02", "Requested"),
              ],
            ),

            SizedBox(height: 20),

            // Profile Option for eligibility status
            _buildProfileOption(
              title: "Eligible to donate: $eligibilityStatus",
              icon: Icons.check_circle,
              onTap: _navigateToEligibilityCheck, // On tap navigate to eligibility check page
            ),
            _buildProfileOption(title: "Get help", icon: Icons.help_outline),
            _buildProfileOption(title: "Sign out", icon: Icons.logout, color: Colors.red),
          ],
        ),
      ),
    );
  }

  // Method to build info card for Blood Type, Donated, Requested
  Widget _buildInfoCard(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Method to build profile options like eligibility check, help, sign out
  Widget _buildProfileOption({required String title, required IconData icon, VoidCallback? onTap, Color color = Colors.black}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
    );
  }
}
