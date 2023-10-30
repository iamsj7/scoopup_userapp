import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'add_address.dart'; // Import the AddAddressScreen

class MyAddressScreen extends StatefulWidget {
  @override
  _MyAddressScreenState createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  List<Map<String, dynamic>> addresses = [];
  String? authToken;
  final String baseUrl =
      'https://menu.scoopup.app'; // Replace with your API base URL

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');

    if (authToken == null || !mounted) {
      return;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v2/client/addresses?api_token=$authToken'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (!mounted) {
      return;
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == true) {
        final List<Map<String, dynamic>> fetchedAddresses =
            List<Map<String, dynamic>>.from(data['data']);
        if (mounted) {
          setState(() {
            addresses = fetchedAddresses;
          });
        }
      }
    }
  }

  Future<void> _refreshAddresses() async {
    await _loadAddresses();
  }

  Future<void> _deleteAddress(String addressId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? apiToken = prefs.getString('authToken');

    if (apiToken == null || !mounted) {
      return;
    }

    final String apiUrl =
        '$baseUrl/api/v2/client/addresses/delete?api_token=$apiToken';

    final Map<String, dynamic> requestData = {
      "id": addressId,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == true) {
        // Address was deleted successfully, you can handle this here.
        _refreshAddresses(); // Refresh the list of addresses
      } else {
        // Handle the case where the API indicates a failure.
      }
    } else {
      // Handle API request error (e.g., show an error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Color(0xFFCE4141)),
          title: Padding(
            padding: const EdgeInsets.only(left:90),
            child: const Text(
              'Address',
              style: TextStyle(
                color: Color(0xFFCE4141),
                fontSize: 26,
                fontFamily: "Nunito Sans",
                fontWeight: FontWeight.w600,
                
              ),
            ),
          ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAddresses,
        child: addresses.isEmpty
            ? Center(
                child:
                    Text("You don't have any address, please add a new one."),
              )
            : ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  final lat = double.parse(address['lat']);
                  final lng = double.parse(address['lng']);

                  return Dismissible(
                    key: Key(address['id'].toString()),
                    onDismissed: (direction) {
                      _deleteAddress(address['id'].toString());
                    },
                    background: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Address: ${address['address']}'),
                              subtitle:
                                  Text('Apartment: ${address['apartment']}'),
                            ),
                            Container(
                              height:
                                  200, // Set the desired height for the map view
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(lat, lng),
                                  zoom: 15.0, // Set the initial zoom level
                                ),
                                markers: {
                                  Marker(
                                    markerId: MarkerId('address_$index'),
                                    position: LatLng(lat, lng),
                                    infoWindow: InfoWindow(
                                      title: 'Address: ${address['address']}',
                                    ),
                                  ),
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAddressScreen(),
            ),
          );

          if (result != null && result is bool && result) {
            // Address was saved in AddAddressScreen, refresh addresses
            _refreshAddresses();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
