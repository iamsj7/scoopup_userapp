import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuScreen extends StatefulWidget {
  final int restoId;

  MenuScreen({required this.restoId});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems(widget.restoId);
  }

  Future<void> fetchMenuItems(int restoId) async {
    final response = await http.get(
      Uri.parse('https://menu.scoopup.app/api/v2/client/vendor/$restoId/items'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('data')) {
        final List<dynamic> categoriesData = data['data'];

        // Process categories and items
        List<Map<String, dynamic>> flattenedMenuItems = [];
        for (var categoryData in categoriesData) {
          if (categoryData is List<dynamic>) {
            // Extract category information
            if (categoryData.isNotEmpty) {
              final category = categoryData[0];
              if (category is Map<String, dynamic>) {
                flattenedMenuItems.add({
                  'isCategory': true,
                  'categoryName': category['category_name'],
                });
              }
            }

            // Process items within the category
            for (var itemData in categoryData) {
              if (itemData is Map<String, dynamic>) {
                flattenedMenuItems.add(itemData);
              }
            }
          }
        }

        setState(() {
          menuItems = flattenedMenuItems;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (BuildContext context, int index) {
          final menuItem = menuItems[index];
          if (menuItem['isCategory'] == true) {
            // Display category heading
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                menuItem['categoryName'],
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            // Display menu item
            final imageUrl = 'https://menu.scoopup.app' + menuItem['logom'];

            return Card(
              margin: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: <Widget>[
                    Image.network(
                      imageUrl,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            menuItem['name'],
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            menuItem['description'],
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            '\OMR ${menuItem['price']}',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
