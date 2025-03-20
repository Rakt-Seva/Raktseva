import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart'; // Correct import for Google Places API

class CampaignPage extends StatefulWidget {
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  GoogleMapController? mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  final String _apiKey = "AIzaSyBTUjMdjy1N-Naqhcent6wqLrWHeTu4lYg"; // 🔴 Replace with your API Key
  late GoogleMapsPlaces _places;

  @override
  void initState() {
    super.initState();
    _places = GoogleMapsPlaces(apiKey: _apiKey); // Initialize Places API
    _getCurrentLocation();
  }

  // Fetch and track real-time location
  void _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = position;
        _updateMap(position);
        _fetchNearbyHospitalsAndBloodBanks(position); // Update to fetch both
      });
    });
  }

  // Move camera to current location
  void _updateMap(Position position) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        14.0,
      ),
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("current_location"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: "Your Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  // Fetch nearby hospitals and blood banks using Google Places API
  void _fetchNearbyHospitalsAndBloodBanks(Position position) async {
    final location = Location(lat: position.latitude, lng: position.longitude); // Correct usage with named parameters

    try {
      // Search for nearby hospitals
      PlacesSearchResponse hospitalResponse = await _places.searchNearbyWithRadius(
        location,
        5000, // Search radius (in meters)
        type: "hospital", // Look for hospitals
      );

      // Search for nearby blood banks (add "blood bank" as a keyword)
      PlacesSearchResponse bloodBankResponse = await _places.searchNearbyWithRadius(
        location,
        5000, // Search radius (in meters)
        keyword: "blood bank", // Use a keyword to search for blood banks
      );

      setState(() {
        _markers.removeWhere((m) => m.markerId.value != "current_location"); // Keep only user marker

        // Add hospital markers
        for (var place in hospitalResponse.results) {
          _markers.add(
            Marker(
              markerId: MarkerId("hospital_${place.name}"),
              position: LatLng(place.geometry!.location.lat, place.geometry!.location.lng),
              infoWindow: InfoWindow(
                title: place.name,
                snippet: place.vicinity,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), // Red for hospitals
            ),
          );
        }

        // Add blood bank markers
        for (var place in bloodBankResponse.results) {
          _markers.add(
            Marker(
              markerId: MarkerId("blood_bank_${place.name}"),
              position: LatLng(place.geometry!.location.lat, place.geometry!.location.lng),
              infoWindow: InfoWindow(
                title: place.name,
                snippet: place.vicinity,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Green for blood banks
            ),
          );
        }
      });
    } catch (e) {
      print("Error fetching places: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nearby Blood Donation Campaigns"),
        backgroundColor: Colors.redAccent,
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 14.0,
        ),
        markers: _markers,
        onMapCreated: (controller) => mapController = controller,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
