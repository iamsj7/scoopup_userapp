import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final int restoId;
  final List<Map<String, dynamic>> cartItems;

  CartScreen({required this.restoId, required this.cartItems});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = widget.cartItems[index];
          // You can customize the cart item UI as per your requirements
          return ListTile(
            title: Text(cartItem['name'] ?? 'Item Name Not Available'),
            subtitle: Text('Price: OMR ${cartItem['price']}'),
            trailing: Text('Qty: ${cartItem['quantity']}'),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total Price: OMR ${_calculateTotalPrice()}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement the logic to place the order here
              },
              child: Text('Place Order'),
            ),
          ],
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
}
