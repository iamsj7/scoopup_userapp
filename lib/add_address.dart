import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  late GoogleMapController _mapController;
  LatLng _selectedLocation =
      LatLng(23.589611, 58.542055); // Default location (Muscat)
  Set<Marker> _markers = {}; // Set to store markers
  TextEditingController _addressController = TextEditingController();
  TextEditingController _apartmentController = TextEditingController();
  TextEditingController _intercomController = TextEditingController();
  TextEditingController _floorController = TextEditingController();
  TextEditingController _entryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Address'),
         backgroundColor: Color(0xFFCE4141),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Selected Location:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                  'Latitude: ${_selectedLocation.latitude.toStringAsFixed(5)}'),
              Text(
                  'Longitude: ${_selectedLocation.longitude.toStringAsFixed(5)}'),
              SizedBox(height: 16),
              _buildInputField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on,
              ),
              _buildInputField(
                controller: _apartmentController,
                label: 'Apartment',
                icon: Icons.apartment,
              ),
              _buildInputField(
                controller: _intercomController,
                label: 'Intercom',
                icon: Icons.call,
              ),
              _buildInputField(
                controller: _floorController,
                label: 'Floor',
                icon: Icons.layers,
              ),
              _buildInputField(
                controller: _entryController,
                label: 'Entry',
                icon: Icons.exit_to_app,
              ),
              SizedBox(height: 16),
              Text(
                'Map:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Hint: Tap on the map to place a marker at the exact location.',
                style: TextStyle(
                  color: Colors.grey, // Use a suitable text color
                ),
              ),
              Container(
                height: 400,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 12,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  onTap: (LatLng location) {
                    setState(() {
                      _selectedLocation = location;
                      _markers.clear();
                      _markers.add(
                        Marker(
                          markerId: MarkerId(_selectedLocation.toString()),
                          position: _selectedLocation,
                        ),
                      );
                    });
                  },
                  markers: _markers,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveAddress();
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red, // Use your branding color here
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red), // Label text color
          icon: Icon(icon, color: Colors.red), // Icon color
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Function to save the address
  // Function to save the address
  Future<void> saveAddress() async {
    final String address = _addressController.text;
    final double lat = _selectedLocation.latitude;
    final double lng = _selectedLocation.longitude;
    final String apartment = _apartmentController.text;
    final String intercom =
        _intercomController.text.isEmpty ? "001" : _intercomController.text;
    final String floor =
        _floorController.text.isEmpty ? "001" : _floorController.text;
    final String entry =
        _entryController.text.isEmpty ? "001" : _entryController.text;

    if (address.isEmpty || apartment.isEmpty || floor.isEmpty) {
      // Handle empty required fields (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Address, Apartment, and Floor are required fields.'),
        ),
      );
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? apiToken = prefs.getString('authToken');

    if (apiToken == null) {
      // Handle not having an API token (e.g., show an error message)
      return;
    }

    // Prepare the address data
    final Map<String, dynamic> addressData = {
      "address": address,
      "lat": lat,
      "lng": lng,
      "apartment": apartment,
      "intercom": intercom,
      "floor": floor,
      "entry": entry,
    };

    final String apiUrl =
        'https://menu.scoopup.app/api/v2/client/addresses?api_token=$apiToken';

    // Send the POST request to save the address
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(addressData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == true) {
        final int id = data['id'];
        final String message = data['message'];

        // Show a SnackBar with the success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Address added with ID $id: $message'),
          ),
        );

        // Navigate back to the previous screen after a short delay
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context, true);
        });
      } else {
        // Handle API response when address couldn't be added (e.g., show an error message)
      }
    } else {
      // Handle API request error (e.g., show an error message)
    }
  }
}
