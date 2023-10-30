import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoopup_userapp/resto_screen.dart';
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
              title: Text(
                menuItem['name'],
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Description: ${menuItem['description']}'),
                    Text('Price: OMR ${menuItem['price']}'),
                    if (menuItem['has_variants'] == 1) ...[
                      const Text('Variants:'),
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
                      const Text('Extras:'),
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
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _addItemToCart(menuItem, selectedVariant, selectedExtras);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.red),
                  ),
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
    final double itemPrice = selectedVariant != null
        ? selectedVariant['price'].toDouble()
        : menuItem['price'].toDouble();
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

  void _removeCartItem(int index) {
    if (index >= 0 && index < cartItems.length) {
      setState(() {
        cartItems.removeAt(index);
      });
    }
  }

  void _clearCart() {
    setState(() {
      cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'https://menu.scoopup.app';

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Color(0xFFCE4141)),
          title: const Center(
            child: Text(
              
              'Resturant',
              style: TextStyle(
                color: Color(0xFFCE4141),
                fontSize: 24,
                fontFamily: "Nunito Sans",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          bottom: categories.isNotEmpty
              ? TabBar(
                  labelColor: Colors.red,
                  indicatorColor: Colors.red,
                  isScrollable: true,
                  tabs: categories.map((category) {
                    return Container(
//                       decoration: ShapeDecoration(

// color: Colors.transparent,
// shape: RoundedRectangleBorder(
// side: BorderSide(width: 1, color: Color(0xFFF97077)),
// borderRadius: BorderRadius.circular(10),
// ),
// ),

                      width: 100,
                      child: Tab(text: category),
                    );
                  }).toList(),
                )
              : null,
          actions: [
            // Add a cart icon that navigates to the CartScreen
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      restoId: widget.restoId,
                      cartItems: cartItems,
                      onRemoveItem: _removeCartItem,
                      onClearCart: _clearCart,
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
                  margin: const EdgeInsets.all(9.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5.0,
                  child: InkWell(
                    onTap: () {
                      _onMenuItemSelected(menuItem);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 17, bottom: 17, left: 17),
                          child: Container(
                            
                            decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(15.0),
                              color: Colors.black,
                            
                            ),
                            width: 150,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                imageUrl,
                                height: 130,
                               fit: BoxFit.cover,
                              ),
                            ),
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
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  'OMR ${menuItem['price']}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
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
