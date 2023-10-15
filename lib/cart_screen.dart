import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final int restoId;
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onRemoveItem;

  CartScreen({
    required this.restoId,
    required this.cartItems,
    required this.onRemoveItem,
  });

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
                  Text('Price: OMR ${itemPrice.toStringAsFixed(2)}'),
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
                      widget.onRemoveItem(index);
                    },
                  ),
                ],
              ),
            ),
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

  String _getSelectedExtras(List<Map<String, dynamic>> extras) {
    final extraNames = extras.map((extra) => extra['name']).join(', ');
    return '[$extraNames]';
  }
}
