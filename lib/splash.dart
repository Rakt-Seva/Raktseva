import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yt/homepage.dart';
import 'package:yt/userController.dart';
import 'role_selection_bottom_sheet.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _showRoleSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return WillPopScope(
            onWillPop: ()async{
              return false;
            },
            child: RoleSelectionBottomSheet());
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Navigate to the first page after a delay
    Timer(const Duration(seconds: 5), () async{
      SharedPreferences prefs =await SharedPreferences.getInstance();
      String? userid = await prefs.getString('currentUser');

      print("dfsd$userid");
      if(userid!=null){
        UserController.instance.initAndListenToUser();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Navigate to homepage
        );
        return;
      }
      Navigator.pushReplacementNamed(context, '/firstpage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image1_1.png',
              height: 160,
              width: 185,
            ),
            const SizedBox(height: 20),
            const Text(
              'Rakta Seva',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
