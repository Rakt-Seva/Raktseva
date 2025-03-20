import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'passwordreset.dart';
import 'registration.dart';
import 'role_selection_bottom_sheet.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/image1_1.png',
              height: 160,
              width: 185,
            ),
            SizedBox(height: 20),
            Text(
              'Rakta Seva',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 30),
            // Email Input Field
            TextField(
              controller: _email,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 15),
            // Password Input Field
            TextField(
              controller: _pass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Enter your password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20),
            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async{
                  GlobalKey key = GlobalKey();
                  showDialog(
                      useRootNavigator: false,
                      context: context, builder: (context){
                    return Dialog(
                      key: key,
                      child: Row(
                        children: [
                          CircularProgressIndicator(),
                          Text("please wait"),
                        ],
                      ),
                    );
                  });
                  var data = await FirebaseFirestore.instance.collection("users").where("email_id", isEqualTo: _email.text).where("password", isEqualTo: _pass.text).get();
                  Navigator.of(key.currentContext??context).pop();
                  print(data.docs.length);
                  if(data.docs.length==0){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("invalid email or password")));
                  }else{
                    print("login successful");

                  _showRoleSelectionBottomSheet(context);
                  }
    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Forgot Password Button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordResetPage()),
                );
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(height: 10),
            // Register Link
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text(
                "Don't have an account? Register",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to Show Role Selection as a Bottom Sheet
  void _showRoleSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return RoleSelectionBottomSheet();
      },
    );
  }
}
