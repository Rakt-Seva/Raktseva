import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  final TextEditingController _name = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _pass = TextEditingController();

  final TextEditingController _mobno = TextEditingController();

  final TextEditingController _blg = TextEditingController();

  final TextEditingController _address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40), // To adjust for safe area
            // Logo
            Image.asset(
              'assets/image1_1.png',
              height: 150,
              width: 165,
            ),
            SizedBox(height: 20),
            Text(
              'Rakta Seva',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 30),
            // Name Field
            TextField(
              controller: _name,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Email Field
            TextField(
              controller: _email,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Password Field
            TextField(
              controller: _pass,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Phone Number Field
            TextField(
              controller: _mobno,
              decoration: InputDecoration(
                hintText: 'Enter your 10 digit phone no.',
                prefixIcon: Icon(Icons.phone, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Blood Group Field
            TextField(
              controller: _blg,
              decoration: InputDecoration(
                hintText: 'Enter your blood type',
                prefixIcon: Icon(Icons.bloodtype, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Location Field
            TextField(
              controller: _address,
              decoration: InputDecoration(
                hintText: 'Enter address',
                prefixIcon: Icon(Icons.location_on, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async{
                  // Add register logic here
                  var db  = FirebaseFirestore.instance;
                  String? fcmToken = await FirebaseMessaging.instance.getToken();
                  Map<String, dynamic> data = {
                    "user_id":DateTime.now().millisecondsSinceEpoch.toString(),
                    "name": _name.text,
                    "email_id":_email.text,
                    "password": _pass.text,
                    "mobile_number":_mobno.text,
                    "blood_group":_blg.text,
                    "address":_address.text,
                    "eligibility_status":false,
                    "reward_points":500,
                    "fcm_token":fcmToken,
                  };
                  print(data);
                   await db.collection("users").doc(data["user_id"]).set(data);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'REGISTER',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Already have an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    // Navigate to Login Page
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
