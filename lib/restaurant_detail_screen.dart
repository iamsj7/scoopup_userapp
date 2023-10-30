import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantDetailScreen extends StatefulWidget {
  final int restoId;

  RestaurantDetailScreen({required this.restoId});

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  Map<String, dynamic> restaurantData = {};
  final String baseUrl = 'https://menu.scoopup.app';

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetails(widget.restoId);
  }

  Future<void> fetchRestaurantDetails(int restoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v2/client/vendor/$restoId/hours'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('data')) {
        setState(() {
          restaurantData = data['data']['restorant'] ?? {};
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
                  elevation: 0.0,
                   iconTheme: const IconThemeData(color: Color(0xFFCE4141)),

        title: Text(restaurantData['name'] ?? 'Restaurant Details',style: TextStyle(color:Color(0xFFCE4141)),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      '$baseUrl' + (restaurantData['coverm'] ?? '')),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              

                child: Card(
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'About ${restaurantData['name'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          restaurantData['description'] ?? 'N/A',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        title: Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Address: ${restaurantData['address'] ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              'Latitude: ${restaurantData['lat'] ?? 'N/A'}, Longitude: ${restaurantData['lng'] ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        title: Text(
                          'Contact Information',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.phone, color: Colors.red, size: 24.0),
                                SizedBox(width: 8.0),
                                Text(
                                  'Phone: ${restaurantData['phone'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.phone, color: Colors.green, size: 24.0),
                                SizedBox(width: 8.0),
                                Text(
                                  'WhatsApp: ${restaurantData['whatsapp_phone'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        title: Text(
                          'Order Information',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Minimum Order Value: ${restaurantData['minimum'] ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              'Can Pickup: ${restaurantData['can_pickup'] == 1 ? 'Yes' : 'No'}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              'Can Deliver: ${restaurantData['can_deliver'] == 1 ? 'Yes' : 'No'}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              'Can Dine In: ${restaurantData['can_dinein'] == 1 ? 'Yes' : 'No'}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ]  ),
          
        ),
      );
    
  }
}
