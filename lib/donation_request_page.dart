import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yt/userController.dart';
import 'homepage.dart'; // ✅ Updated import path
import 'request_detail_page.dart';

class DonationRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
        title: Text(
          "Donation Request",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('requests')
              .where("user_id", isEqualTo: UserController.instance.userId.value)
              .orderBy('created_at', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No donation requests available."));
            }

            final requests = snapshot.data!.docs;

            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                final data = request.data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestDetailPage(
                          name: data['name'] ?? 'Unknown',
                          bloodGroup: data['blood_type'] ?? 'N/A',
                          timePosted: _formatTime(data['created_at']),
                          location: data['city'] ?? 'Unknown',
                          latitude: data['latitude'] ?? 0.0,
                          longitude: data['longitude'] ?? 0.0,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    margin: EdgeInsets.only(bottom: 16),
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                              Text(data['name'] ?? 'Unknown', style: TextStyle(fontSize: 18)),
                              SizedBox(height: 5),
                              Text("Location", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                              Text(data['city'] ?? 'Unknown', style: TextStyle(fontSize: 16)),
                              SizedBox(height: 5),
                              Text(_formatTime(data['created_at']), style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.bloodtype, color: Colors.red, size: 40),
                              Text(
                                data['blood_type'] ?? '',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
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
}
