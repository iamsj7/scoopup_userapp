import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_details_screen.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future<List<Map<String, dynamic>>>? userOrders; // Change the data type

  String? authToken;

  @override
  void initState() {
    super.initState();
    userOrders = _loadUserOrders(); // Assign the future here
  }

  Future<List<Map<String, dynamic>>> _loadUserOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');

    if (authToken == null) {
      return [];
    }

    final String baseUrl = 'https://menu.scoopup.app';
    final response = await http.get(
      Uri.parse('$baseUrl/api/v2/client/orders?api_token=$authToken'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == true) {
        final List<Map<String, dynamic>> orders =
            List<Map<String, dynamic>>.from(data['data']);
        return orders;
      }
    }

    return [];
  }

  void _viewOrderDetails(Map<String, dynamic> order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(orderData: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: userOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text('No orders available.'),
            );
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text('Order ID: ${order['id']}'),
                  subtitle: Text('Created At: ${order['created_at']}'),
                  trailing: Text('Total Price: ${order['order_price']} OMR'),
                  onTap: () => _viewOrderDetails(order),
                );
              },
            );
          }
        },
      ),
    );
  }
}
