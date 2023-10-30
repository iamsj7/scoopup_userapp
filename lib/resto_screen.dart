import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoopup_userapp/city_screen.dart';
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
    var size, height, width;

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
     size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar:  AppBar(
         leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
           Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 CityScreen()));
          },
        ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Color(0xFFCE4141)),
          title: Row(
            children: [
              SizedBox(width: width/4.5),
              const Text(
                'Resturant',
                style: TextStyle(
                  color: Color(0xFFCE4141),
                  fontSize: 24,
                  fontFamily: "Nunito Sans",
                  fontWeight: FontWeight.w600,
                  
                ),
              ),
            ],
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
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15),
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
                       
                      
                            Container(
                              child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                             Padding(
                               padding: const EdgeInsets.only(left:10.0),
                               child: Container(
                                width: width / 1.5,
                                 child: Text(
                                                      
                                      restaurant['name'] ?? 'N/A',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                               ),
                             ),
                          IconButton(
                          
                            icon: Icon(Icons.info, color: Colors.white),
                            onPressed: () => _onInfoIconTap(restaurant['id']),
                          ),
                        ],
                      ),
                              padding:
                                  const EdgeInsets.fromLTRB(12, 12, 12, 12),
                              height: 80,
                              width: 380,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                  gradient: LinearGradient(
                                      colors: [Colors.black, Colors.black12],
                                     end: Alignment.bottomCenter,
                                      begin: Alignment.topCenter)),
                            ),
                      
                    
                     
                    ],
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
