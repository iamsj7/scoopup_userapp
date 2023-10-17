import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  final int restoId;
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onRemoveItem;
  final Function() onClearCart;

  CartScreen({
    required this.restoId,
    required this.cartItems,
    required this.onRemoveItem,
    required this.onClearCart,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _selectedDeliveryType = 'pickup';

  TextEditingController addressIdController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController deliveryAreaNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          DropdownButton<String>(
            value: _selectedDeliveryType,
            onChanged: (String? newValue) {
              setState(() {
                _selectedDeliveryType = newValue!;
              });
            },
            items: <String>['pickup', 'delivery']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          if (_selectedDeliveryType == 'delivery')
            Column(
              children: <Widget>[
                TextField(
                  controller: addressIdController,
                  decoration: InputDecoration(labelText: 'Address ID'),
                ),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(labelText: 'Comment'),
                ),
                TextField(
                  controller: deliveryAreaNameController,
                  decoration: InputDecoration(labelText: 'Delivery Area Name'),
                ),
              ],
            ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = widget.cartItems[index];
                final itemName = cartItem['name'] ?? 'Item Name Not Available';
                final itemPrice = cartItem['price'];
                final variantName = cartItem['variant'] != null
                    ? cartItem['variant']['options']
                    : 'No Variant';
                final extrasSelected = cartItem['extrasSelected'];

                return Card(
                  margin: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(itemName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: OMR ${itemPrice.toStringAsFixed(3)}'),
                        Text('Variant: $variantName'),
                        if (extrasSelected.isNotEmpty)
                          Text('Extras: ${_getSelectedExtras(extrasSelected)}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Qty: ${cartItem['quantity']}'),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            _removeItem(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Total Price: OMR ${_calculateTotalPrice().toStringAsFixed(3)}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _clearCart();
        },
        child: Icon(Icons.delete),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _placeOrder();
                },
                child: Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotalPrice() {
    double total = 0;
    for (var cartItem in widget.cartItems) {
      total += cartItem['price'] * cartItem['quantity'];
    }
    return total;
  }

  String _getSelectedExtras(List<Map<String, dynamic>> extras) {
    final extraNames = extras.map((extra) => extra['name']).join(', ');
    return '[$extraNames]';
  }

  void _removeItem(int index) {
    if (index >= 0 && index < widget.cartItems.length) {
      widget.onRemoveItem(index);
    }
  }

  void _clearCart() {
    widget.onClearCart();
  }

  Future<void> _placeOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String apiToken = prefs.getString('authToken') ?? '';

    final List<Map<String, dynamic>> items = widget.cartItems.map((cartItem) {
      // Check if the variant is null, and provide an empty list if it is
      final variant = cartItem['variant'];
      final variantId = variant != null ? variant['id'] : null;
      final extrasSelected = cartItem['extrasSelected'] ?? [];

      return {
        "id": cartItem['id'],
        "qty": cartItem['quantity'],
        "extrasSelected": extrasSelected,
        "variant": variantId,
      };
    }).toList();
    final Map<String, dynamic> orderData = {
      "vendor_id": widget.restoId,
      "delivery_method": _selectedDeliveryType,
      "payment_method": "cod",
      "items": items,
      "timeslot": "1320_1350",
      "stripe_token": null,
    };

    if (_selectedDeliveryType == 'delivery') {
      orderData['address_id'] = addressIdController.text;
      orderData['comment'] = commentController.text;
      orderData['customFields'] = {
        "delivery_area_name": deliveryAreaNameController.text,
      };
    }

    final String apiUrl =
        'https://menu.scoopup.app/api/v2/client/orders?api_token=$apiToken';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application.json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        _showOrderSuccessMessage();
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Network Error: $e');
    }
  }

  void _showOrderSuccessMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order Placed Successfully'),
          content: Text('Thank you for your order!'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the order success dialog
                Navigator.of(context).pop();

                // Clear the cart
                _clearCart();

                // Navigate back to the menu screen
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
