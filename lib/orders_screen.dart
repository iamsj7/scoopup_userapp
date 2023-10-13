import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_details_screen.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future<List<Map<String, dynamic>>>? userOrders;
  String? authToken;
  final String baseUrl = 'https://menu.scoopup.app'; // Add your base URL

  @override
  void initState() {
    super.initState();
    _loadUserOrders();
  }

  Future<void> _loadUserOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');

    if (authToken == null || !mounted) {
      return;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v2/client/orders?api_token=$authToken'),
    );

    if (!mounted) {
      return;
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == true) {
        final List<Map<String, dynamic>> orders =
            List<Map<String, dynamic>>.from(data['data']);
        if (mounted) {
          setState(() {
            userOrders = Future.value(orders);
          });
        }
      }
    }
  }

  void _viewOrderDetails(Map<String, dynamic> order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(orderData: order),
      ),
    );
  }

  Future<void> _refreshUserOrders() async {
    _loadUserOrders();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Orders refreshed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshUserOrders,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshUserOrders,
        child: FutureBuilder<List<Map<String, dynamic>>>(
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
              return ListView.separated(
                itemCount: orders.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final restaurant = order['restorant'];
                  final lastStatus = order['last_status'][0]['name'];
                  final createdAt =
                      DateTime.parse(order['created_at']).toLocal();
                  final formattedDate =
                      DateFormat.yMMMMd().add_jm().format(createdAt);
                  final logoUrl = '$baseUrl${restaurant['logom']}';

                  return Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Image.network(
                        logoUrl,
                        width: 60,
                      ),
                      title: Row(
                        children: [
                          Text(restaurant['name']),
                          SizedBox(width: 8),
                          Text(
                            lastStatus,
                            style: TextStyle(
                              color: lastStatus == 'Delivered'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order ID: ${order['id']}'),
                          Text('Created At: $formattedDate'),
                        ],
                      ),
                      onTap: () => _viewOrderDetails(order),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
