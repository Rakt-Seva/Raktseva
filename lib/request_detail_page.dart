import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestDetailPage extends StatelessWidget {
  final String name;
  final String bloodGroup;
  final String timePosted;
  final double latitude;
  final double longitude;

  RequestDetailPage({
    required this.name,
    required this.bloodGroup,
    required this.timePosted,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Details"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🩸 Name: $name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("🩸 Blood Group: $bloodGroup", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("⏰ Posted: $timePosted", style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 20),
            Container(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('request_location'),
                    position: LatLng(latitude, longitude),
                    infoWindow: InfoWindow(title: "Request Location"),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
