import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:scoopup_userapp/restaurant_detail_screen.dart';
import 'package:scoopup_userapp/menu_screen.dart';

class RestaurantScreen extends StatefulWidget {
  final int cityId;

  RestaurantScreen({required this.cityId});

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  List<Map<String, dynamic>> restaurants = [];
  final String baseUrl = 'https://menu.scoopup.app';

  @override
  void initState() {
    super.initState();
    fetchRestaurants(widget.cityId);
  }

  Future<void> fetchRestaurants(int cityId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v2/client/vendor/list/$cityId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('data')) {
        setState(() {
          restaurants = List<Map<String, dynamic>>.from(data['data']);
        });
      }
    }
  }

  void _onRestaurantCardTap(int restoId) {
    final restaurant = restaurants.firstWhere(
      (r) => r['id'] == restoId,
      orElse: () => <String, dynamic>{},
    );

    if (restaurant.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuScreen(restoId: restoId),
        ),
      );
    } else {
      // Handle the case where the restaurant data is not found.
    }
  }

  void _onInfoIconTap(int restoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantDetailScreen(restoId: restoId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (BuildContext context, int index) {
          final restaurant = restaurants[index];
          return GestureDetector(
            onTap: () => _onRestaurantCardTap(restaurant['id']),
            child: Card(
              margin: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        child: Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                '$baseUrl' + (restaurant['coverm'] ?? ''),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.info, color: Colors.white),
                        onPressed: () => _onInfoIconTap(restaurant['id']),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            '$baseUrl' + (restaurant['logom'] ?? ''),
                            width: 50.0,
                            height: 50.0,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurant['name'] ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
