import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'campaign_detail_page.dart';

class CampaignPage extends StatefulWidget {
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  String? selectedState = 'All';
  String? selectedCity = 'All';

  Map<String, dynamic> statesAndCities = {};
  List<String> states = ['All'];
  List<String> cities = ['All'];

  List<Map<String, String>> campaigns = [
    {
      'name': 'Delhi Blood Donation Drive',
      'location': 'New Delhi',
      'startDate': 'March 30, 2025',
      'endDate': 'April 1, 2025',
      'organizer': 'Delhi Blood Bank',
      'timePosted': '2025-03-15',
      'latitude': '28.6139',
      'longitude': '77.2090',
    },
    {
      'name': 'Mumbai Blood Camp',
      'location': 'Mumbai',
      'startDate': 'April 5, 2025',
      'endDate': 'April 7, 2025',
      'organizer': 'Mumbai Health Organization',
      'timePosted': '2025-03-20',
      'latitude': '19.0760',
      'longitude': '72.8777',
    },
    {
      'name': 'Bangalore Awareness Program',
      'location': 'Bangalore',
      'startDate': 'April 10, 2025',
      'endDate': 'April 11, 2025',
      'organizer': 'Bangalore Red Cross',
      'timePosted': '2025-03-25',
      'latitude': '12.9716',
      'longitude': '77.5946',
    },
    {
      'name': 'Kolkata Blood Donation',
      'location': 'Kolkata',
      'startDate': 'April 12, 2025',
      'endDate': 'April 13, 2025',
      'organizer': 'Kolkata Blood Center',
      'timePosted': '2025-03-28',
      'latitude': '22.5726',
      'longitude': '88.3639',
    },
    {
      'name': 'Chennai Health Camp',
      'location': 'Chennai',
      'startDate': 'April 15, 2025',
      'endDate': 'April 16, 2025',
      'organizer': 'Chennai Health Organization',
      'timePosted': '2025-03-30',
      'latitude': '13.0827',
      'longitude': '80.2707',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final String response = await rootBundle.loadString('assets/st_ct.json');
    final Map<String, dynamic> data = json.decode(response);
    setState(() {
      statesAndCities = data;
      states += data.keys.toList();
    });
  }

  void _updateCities(String state) {
    if (state == 'All') {
      setState(() {
        cities = ['All'];
        selectedCity = 'All';
      });
    } else {
      var selectedStateData = statesAndCities.entries
          .map((e) => {e.key: e.value})
          .firstWhere((item) => item.keys.first == state, orElse: () => {});
      if (selectedStateData.isNotEmpty) {
        setState(() {
          cities = ['All', ...List<String>.from(selectedStateData.values.first)];
          selectedCity = 'All';
        });
      } else {
        setState(() {
          cities = ['All'];
          selectedCity = 'All';
        });
      }
    }
  }

  List<Map<String, String>> _filterCampaigns() {
    return campaigns.where((campaign) {
      bool stateMatch = selectedState == 'All' || campaign['location'] == selectedState;
      bool cityMatch = selectedCity == 'All' || campaign['location'] == selectedCity;
      return stateMatch && cityMatch;
    }).toList();
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          contentPadding: const EdgeInsets.all(16.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter Campaigns',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedState,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      border: OutlineInputBorder(),
                    ),
                    items: states.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setModalState(() {
                        selectedState = newValue;
                        _updateCities(newValue!);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCity,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    items: cities.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setModalState(() {
                        selectedCity = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedState = 'All';
                            selectedCity = 'All';
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Clear', style: TextStyle(color: Colors.red)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red), // Changed 'primary' to 'backgroundColor'
                        child: const Text('Apply'),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredCampaigns = _filterCampaigns();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaigns in India'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: filteredCampaigns.isEmpty
          ? const Center(child: Text('No campaigns found.'))
          : ListView.builder(
        itemCount: filteredCampaigns.length,
        itemBuilder: (context, index) {
          final campaign = filteredCampaigns[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: const Icon(Icons.event, color: Colors.red), // Changed to red
              title: Text(
                campaign['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${campaign['location']} | ${campaign['startDate']} to ${campaign['endDate']}',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CampaignDetailPage(
                      campaignName: campaign['name']!,
                      organizer: campaign['organizer']!,
                      timePosted: campaign['timePosted']!,
                      location: campaign['location']!,
                      latitude: double.parse(campaign['latitude']!),
                      longitude: double.parse(campaign['longitude']!),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
