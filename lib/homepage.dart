import 'package:flutter/material.dart';
import 'package:yt/gemini_chat_screen.dart';
import 'widgets/blooddonationslide.dart'; // ✅ Ensure this is correctly imported
//import 'search_filter_page.dart';
import 'donation_request_page.dart';
import 'profilescreen.dart';
import 'finddonor.dart';
import 'create_request_page.dart';
import 'campaignPage.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;
  final Function(int)? onTabChange;

  HomePage({Key? key, this.initialIndex = 0, this.onTabChange}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    HomeScreen(),
    //SearchFilterPage(),
    DonationRequestPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Icon(Icons.grid_view, color: Colors.red),
        actions: [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (widget.onTabChange != null) {
            widget.onTabChange!(index);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          //BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.stacked_line_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: _pages[_currentIndex],
    );
  }
}

// ------------------- Home Screen -------------------
class HomeScreen extends StatelessWidget {
  final Function(int)? onTabChange;

  HomeScreen({this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            BloodDonationSlides(), // ✅ FIXED: Corrected to `BloodDonationSlides()`
            SizedBox(height: 20),
            _buildFeatureGrid(context),
            SizedBox(height: 20),
            _buildDonationRequestSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: [
        _buildFeatureCard(Icons.search, "Find Donors", context, FindDonorsScreen()),
        _buildFeatureCard(Icons.volunteer_activism, "Donate", context, null),
        _buildFeatureCard(Icons.local_hospital, "Order Blood", context, CreateRequestPage()),
        _buildFeatureCard(Icons.medical_services, "Assistant", context, GeminiChatScreen()),
        _buildFeatureCard(Icons.campaign, "Campaigns", context,CampaignPage()),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, BuildContext context, Widget? page) {
    return GestureDetector(
      onTap: () {
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(backgroundColor: Colors.red.shade100, radius: 30, child: Icon(icon, color: Colors.red, size: 30)),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDonationRequestSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🆘 Urgent Blood Requests', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            if (onTabChange != null) {
              onTabChange!(2);
            }
          },
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey.shade100),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🩸 Name:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Amir Hamza', style: TextStyle(fontSize: 18)),
                Text('Blood Group : A+', style: TextStyle(fontSize: 18)),
                SizedBox(height: 5),
                Text('🏥 Location:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Hertford British Hospital', style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                Text('⏳ Posted:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('5 Min Ago', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

