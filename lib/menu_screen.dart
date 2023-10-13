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
  List<String> categories = [];
  Map<String, List<Map<String, dynamic>>> categoryMenuItems = {};

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

        List<Map<String, dynamic>> flattenedMenuItems = [];
        List<String> categoryNames = [];
        Map<String, List<Map<String, dynamic>>> categoryItemsMap = {};

        for (var categoryData in categoriesData) {
          if (categoryData is List<dynamic>) {
            if (categoryData.isNotEmpty) {
              final category = categoryData[0];
              if (category is Map<String, dynamic>) {
                final categoryName = category['category_name'];
                categoryNames.add(categoryName);
                final categoryItems = categoryData
                    .where((item) => item is Map<String, dynamic>)
                    .cast<Map<String, dynamic>>()
                    .toList();
                categoryItemsMap[categoryName] = categoryItems;
              }
            }
          }
        }

        setState(() {
          menuItems = flattenedMenuItems;
          categories = categoryNames;
          categoryMenuItems = categoryItemsMap;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'https://menu.scoopup.app';

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu'),
          bottom: categories.isNotEmpty
              ? TabBar(
                  isScrollable: true,
                  tabs: categories.map((category) {
                    return Container(
                      width: 100, // Adjust the width as needed
                      child: Tab(text: category),
                    );
                  }).toList(),
                )
              : null,
        ),
        body: TabBarView(
          children: categories.map((category) {
            return ListView.builder(
              itemCount: categoryMenuItems[category]?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final menuItem = categoryMenuItems[category]![index];
                final imageUrl = '$baseUrl${menuItem['logom']}';

                return Card(
                  margin: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 4.0,
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        child: Image.network(
                          imageUrl,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                'OMR ${menuItem['price']}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
