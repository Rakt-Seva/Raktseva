import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'profilescreen.dart';

class EligibilityCheckPage extends StatefulWidget {
  @override
  _EligibilityCheckPageState createState() => _EligibilityCheckPageState();
}

class _EligibilityCheckPageState extends State<EligibilityCheckPage> {
  bool? alcohol;
  bool? tattoo;
  bool? illness;

  @override
  void initState() {
    super.initState();
    _loadEligibility(); // Load previously stored eligibility
  }

  // Load stored values from shared preferences
  Future<void> _loadEligibility() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      alcohol = prefs.getBool("alcohol") ?? false;
      tattoo = prefs.getBool("tattoo") ?? false;
      illness = prefs.getBool("illness") ?? false;
    });
  }

  // Save the selected answers
  Future<void> _saveEligibility() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("alcohol", alcohol ?? false);
    await prefs.setBool("tattoo", tattoo ?? false);
    await prefs.setBool("illness", illness ?? false);
  }

  void checkEligibility() {
    if (alcohol == null || tattoo == null || illness == null) {
      _showResultDialog("Incomplete", "Please answer all questions before proceeding.", false);
      return;
    }

    bool isEligible = !(alcohol! || tattoo! || illness!);
    _saveEligibility(); // Save responses

    _showResultDialog(
      isEligible ? "Eligible" : "Not Eligible",
      isEligible ? "You are eligible to donate blood. Thank you for your support!"
          : "You are not eligible to donate blood at this moment.",
      isEligible,
    );
  }

  void _showResultDialog(String title, String message, bool isEligible) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(color: isEligible ? Colors.green : Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pushReplacement( // Navigate to ProfileScreen
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Eligibility Check")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestion("Did you consume alcohol in the last 24 hours?", alcohol, (value) => setState(() => alcohol = value)),
            _buildQuestion("Did you have a tattoo recently?", tattoo, (value) => setState(() => tattoo = value)),
            _buildQuestion("Are you suffering from chronic illnesses?", illness, (value) => setState(() => illness = value)),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: checkEligibility,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                ),
                child: Text("Check Eligibility", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(String question, bool? value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => onChanged(true));
                    _saveEligibility();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: value == true ? Colors.red : Colors.grey[300],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text("Yes", style: TextStyle(color: value == true ? Colors.white : Colors.black)),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => onChanged(false));
                    _saveEligibility();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: value == false ? Colors.green : Colors.grey[300],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text("No", style: TextStyle(color: value == false ? Colors.white : Colors.black)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
