import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_screen.dart';

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
  List<Map<String, dynamic>> cartItems = [];

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

        for (var categoryData in categoriesData) {
          if (categoryData is List<dynamic>) {
            if (categoryData.isNotEmpty) {
              final category = categoryData[0];
              if (category is Map<String, dynamic>) {
                final categoryName = category['category_name'];
                final categoryItems = categoryData
                    .where((item) => item is Map<String, dynamic>)
                    .cast<Map<String, dynamic>>()
                    .toList();
                categoryMenuItems[categoryName] = categoryItems;
              }
            }
          }
        }

        setState(() {
          categories = categoryMenuItems.keys.toList();
        });
      }
    }
  }

  void _onMenuItemSelected(Map<String, dynamic> menuItem) {
    Map<String, dynamic>? selectedVariant;
    List<Map<String, dynamic>> selectedExtras = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(menuItem['name']),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Description: ${menuItem['description']}'),
                  Text('Price: OMR ${menuItem['price']}'),
                  if (menuItem['has_variants'] == 1) ...[
                    Text('Variants:'),
                    for (var variant in menuItem['variants'])
                      RadioListTile(
                        value: variant,
                        groupValue: selectedVariant,
                        onChanged: (value) {
                          setState(() {
                            selectedVariant = value;
                          });
                        },
                        title: Text(variant['options']),
                        subtitle: Text('Price: OMR ${variant['price']}'),
                      ),
                  ],
                  if (menuItem['extras'].isNotEmpty) ...[
                    Text('Extras:'),
                    for (var extra in menuItem['extras'])
                      CheckboxListTile(
                        value: selectedExtras.contains(extra),
                        onChanged: (bool? value) {
                          if (value != null) {
                            setState(() {
                              if (value) {
                                selectedExtras.add(extra);
                              } else {
                                selectedExtras.remove(extra);
                              }
                            });
                          }
                        },
                        title: Text(extra['name']),
                        subtitle: Text('Price: OMR ${extra['price']}'),
                      ),
                  ],
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _addItemToCart(menuItem, selectedVariant, selectedExtras);
                    Navigator.of(context).pop();
                  },
                  child: Text('Add to Cart'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addItemToCart(
    Map<String, dynamic> menuItem,
    Map<String, dynamic>? selectedVariant,
    List<Map<String, dynamic>> selectedExtras,
  ) {
    final int itemId = menuItem['id'];
    final double itemPrice =
        selectedVariant != null ? selectedVariant['price'] : menuItem['price'];
    final String itemName = menuItem['name'];

    Map<String, dynamic> cartItem = {
      'id': itemId,
      'name': itemName,
      'quantity': 1,
      'price': itemPrice,
      'variant': selectedVariant,
      'extrasSelected': selectedExtras,
    };

    setState(() {
      cartItems.add(cartItem);
    });
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
                      width: 100,
                      child: Tab(text: category),
                    );
                  }).toList(),
                )
              : null,
          actions: [
            // Add a cart icon that navigates to the CartScreen
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      restoId: widget.restoId,
                      cartItems: cartItems,
                      onRemoveItem: (int index) {
                        // You can implement item removal logic here
                      },
                    ),
                  ),
                );
              },
            ),
          ],
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
                  child: InkWell(
                    onTap: () {
                      _onMenuItemSelected(menuItem);
                    },
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
