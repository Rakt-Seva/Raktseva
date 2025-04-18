import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CampaignDetailPage extends StatelessWidget {
  final String campaignName;
  final String organizer;
  final String timePosted;
  final String location;
  final double latitude;
  final double longitude;

  const CampaignDetailPage({
    Key? key,
    required this.campaignName,
    required this.organizer,
    required this.timePosted,
    required this.location,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaign Details"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailTile("🎯 Campaign Name", campaignName),
            _buildDetailTile("📋 Organizer", organizer),
            _buildDetailTile("📍 Location", location),
            _buildDetailTile("⏰ Posted", timePosted, fontSize: 14, color: Colors.grey),
            const SizedBox(height: 20),

            // Google Map
            Container(
              height: 300,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              clipBehavior: Clip.hardEdge,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('campaign_location'),
                    position: LatLng(latitude, longitude),
                    infoWindow: const InfoWindow(title: "Campaign Location"),
                  ),
                },
                zoomControlsEnabled: false,
              ),
            ),

            const SizedBox(height: 30),

            // Participate / Share Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Participate"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You joined the campaign."),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text("Share"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You shared the campaign."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔧 Helper Widget for Detail Tiles
  Widget _buildDetailTile(String title, String value, {double fontSize = 16, Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          text: "$title: ",
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: color),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
