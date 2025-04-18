// 👇 Make sure all imports are correct and available
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yt/userController.dart';
import 'package:yt/widgets/webview_widget.dart';
import 'widgets/blooddonationslide.dart';
import 'donation_request_page.dart';
import 'profilescreen.dart';
import 'finddonor.dart';
import 'create_request_page.dart';
import 'donatepage.dart';
import 'request_detail_page.dart';
import 'campaign_page.dart';

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
        leading: const Icon(Icons.grid_view, color: Colors.red),
        actions: const [
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
        items: const [
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

  final List<Map<String, dynamic>> requestList = [
    {
      'name': 'Amir Hamza',
      'bloodGroup': 'A+',
      'timePosted': '5 Min Ago',
      'location': 'Connaught Place, Delhi',
      'latitude': 28.6139,
      'longitude': 77.2090,
    },
    {
      'name': 'John Doe',
      'bloodGroup': 'B-',
      'timePosted': '10 Min Ago',
      'location': 'Chandni Chowk, Delhi',
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
            const SizedBox(height: 20),
            BloodDonationSlides(),
            const SizedBox(height: 20),
            _buildFeatureGrid(context),
            const SizedBox(height: 20),
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
        _buildFeatureCard(Icons.campaign, "Campaign", context, CampaignPage()),
        _buildFeatureCard(Icons.local_hospital, "Order Blood", context, CreateRequestPage()),
        _buildFeatureCard(Icons.medical_services, "Assistant", context, WebViewXPage()),
        _buildFeatureCard(Icons.volunteer_activism, "Donate", context, DonatePage()),
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
          CircleAvatar(
            backgroundColor: Colors.red.shade100,
            radius: 30,
            child: Icon(icon, color: Colors.red, size: 30),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationRequestSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🆘 Urgent Blood Requests',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
        .collection('requests')
        .where("time_required", whereIn: ["1 Hour", "2 Hours"])
        .orderBy('created_at', descending: true)
        .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No donation requests available."));
              }

              final requestList = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                          bloodGroup: request['blood_type'],
                          timePosted: _formatTime(request['created_at']),
                          location: request['location'],
                          latitude: request['latitude'],
                          longitude: request['longitude'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade100,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🩸 Name: ${request['name']}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Blood Group: ${request['blood_type']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Location: ${request['city']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '⏳ Posted: ${_formatTime(request['created_at'])}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        ),
      ],
    );
  }
}

String _formatTime(Timestamp? timestamp) {
  if (timestamp == null) return "Just now";
  final now = DateTime.now();
  final created = timestamp.toDate();
  final difference = now.difference(created);

  if (difference.inMinutes < 1) return "Just now";
  if (difference.inMinutes < 60) return "${difference.inMinutes} min ago";
  if (difference.inHours < 24) return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
  return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
}