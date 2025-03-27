import 'package:flutter/material.dart';
import 'package:yt/gemini_chat_screen.dart';
import 'widgets/blooddonationslide.dart'; // ✅ Ensure this is correctly imported
import 'donation_request_page.dart';
import 'profilescreen.dart';
import 'finddonor.dart';
import 'create_request_page.dart';
import 'campaignPage.dart';
import 'request_detail_page.dart'; // ✅ New import for details

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

  // Sample data for requests
  final List<Map<String, dynamic>> requestList = [
    {
      'name': 'Amir Hamza',
      'bloodGroup': 'A+',
      'timePosted': '5 Min Ago',
      'latitude': 28.6139,
      'longitude': 77.2090,
    },
    {
      'name': 'John Doe',
      'bloodGroup': 'B-',
      'timePosted': '10 Min Ago',
      'latitude': 28.7041,
      'longitude': 77.1025,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            BloodDonationSlides(), // ✅ Corrected to `BloodDonationSlides()`
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
        _buildFeatureCard(Icons.campaign, "Campaigns", context, CampaignPage()),
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
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: requestList.length,
          itemBuilder: (context, index) {
            final request = requestList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestDetailPage(
                      name: request['name'],
                      bloodGroup: request['bloodGroup'],
                      timePosted: request['timePosted'],
                      latitude: request['latitude'],
                      longitude: request['longitude'],
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade100,
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🩸 Name: ${request['name']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Blood Group : ${request['bloodGroup']}', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 5),
                    Text('⏳ Posted: ${request['timePosted']}', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
