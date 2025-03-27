import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CampaignPage extends StatefulWidget {
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  String? selectedState = 'All';
  String? selectedCity = 'All';

  List<Map<String, dynamic>> statesAndCities = [];
  List<String> states = ['All'];
  List<String> cities = ['All'];

  List<Map<String, String>> campaigns = [
    {'name': 'Delhi Blood Donation Drive', 'location': 'New Delhi', 'date': 'March 30, 2025'},
    {'name': 'Mumbai Blood Camp', 'location': 'Mumbai', 'date': 'April 5, 2025'},
    {'name': 'Bangalore Awareness Program', 'location': 'Bangalore', 'date': 'April 10, 2025'},
    {'name': 'Kolkata Blood Donation', 'location': 'Kolkata', 'date': 'April 12, 2025'},
    {'name': 'Chennai Health Camp', 'location': 'Chennai', 'date': 'April 15, 2025'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLocations(); // Load state-city data
  }

  Future<void> _loadLocations() async {
    try {
      final String response = await rootBundle.loadString('assets/st_ct.json');
      final List<dynamic> data = json.decode(response);

      List<String> fetchedStates = data.map<String>((item) => item['state'] as String).toList();

      setState(() {
        statesAndCities = List<Map<String, dynamic>>.from(data);
        states.addAll(fetchedStates);
      });
    } catch (e) {
      print('Error loading locations: $e');
    }
  }

  void _updateCities(String state) {
    if (state == 'All') {
      setState(() {
        cities = ['All'];
        selectedCity = 'All';
      });
    } else {
      var selectedStateData = statesAndCities.firstWhere(
            (item) => item['state'] == state,
        orElse: () => {},
      );
      if (selectedStateData.isNotEmpty) {
        setState(() {
          cities = ['All', ...List<String>.from(selectedStateData['cities'])];
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
      bool stateMatch =
          selectedState == 'All' || campaign['location'] == selectedState;
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
                    'Filter Donors',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // State Dropdown
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
                  // City Dropdown
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
                      // Clear Button
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
                      // Apply Button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: const Text('Apply'),
                      ),
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
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: filteredCampaigns.isEmpty
          ? const Center(child: Text('No campaigns found.'))
          : ListView.builder(
        itemCount: filteredCampaigns.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: const Icon(Icons.event, color: Colors.red),
              title: Text(
                filteredCampaigns[index]['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${filteredCampaigns[index]['location']} | ${filteredCampaigns[index]['date']}',
              ),
            ),
          );
        },
      ),
    );
  }
}
