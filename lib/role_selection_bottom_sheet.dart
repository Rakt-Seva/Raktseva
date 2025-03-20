import 'package:flutter/material.dart';
import 'homepage.dart'; // Ensure this import is correct

void showRoleSelectionBottomSheet(BuildContext context) {
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

class RoleSelectionBottomSheet extends StatefulWidget {
  @override
  _RoleSelectionBottomSheetState createState() => _RoleSelectionBottomSheetState();
}

class _RoleSelectionBottomSheetState extends State<RoleSelectionBottomSheet> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Select Your Role",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _roleOption(context, "Donor", Icons.volunteer_activism),
              _roleOption(context, "Receiver", Icons.medical_services),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: selectedRole == null
                ? null
                : () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()), // Navigate to homepage
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedRole == null ? Colors.grey : Colors.red,
            ),
            child: Text("CONTINUE"),
          ),
        ],
      ),
    );
  }

  Widget _roleOption(BuildContext context, String title, IconData icon) {
    bool isSelected = selectedRole == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = title;
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.red.shade100 : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 50, color: isSelected ? Colors.red : Colors.black),
          ),
          SizedBox(height: 5),
          Text(title, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

