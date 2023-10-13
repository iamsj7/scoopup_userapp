import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  OrderDetailsScreen({required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${orderData['id_formated']}'),
        backgroundColor: Colors.indigo, // Set app bar color
      ),
      body: ListView(
        children: <Widget>[
          _buildSection(
            title: 'Order Status',
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.timeline),
                title: Text('Status: ${orderData['last_status'][0]['name']}'),
              ),
              if (orderData['time_created'] != null)
                ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text('Last Update: ${orderData['time_created']}'),
                ),
            ],
          ),
          _buildSection(
            title: 'Restaurant Information',
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.store),
                title: Text(orderData['restorant']['name'] ?? 'N/A'),
                subtitle: Text(orderData['restorant']['address'] ?? 'N/A'),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title:
                    Text('Phone: ${orderData['restorant']['phone'] ?? 'N/A'}'),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                    'FB: ${orderData['restorant']['fb_username'] ?? 'N/A'}'),
              ),
            ],
          ),
          _buildSection(
            title: 'Order Items',
            children: orderData['items'].map<Widget>((item) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.fastfood),
                    title: Text('${item['qty']} X ${item['name']}'),
                    subtitle: Text('Price: ر.ع.${item['price']}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.dashboard),
                    title:
                        Text('Size: ${item['pivot']['variant_name'] ?? 'N/A'}'),
                  ),
                ],
              );
            }).toList(),
          ),
          _buildSection(
            title: 'Bill Details',
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Delivery Address'),
                subtitle: Text(orderData['whatsapp_address'] ?? 'N/A'),
              ),
              ListTile(
                leading: Icon(Icons.comment),
                title: Text('Comment'),
                subtitle: Text(orderData['comment'] ?? 'N/A'),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Contact Phone'),
                subtitle: Text(orderData['phone'] ?? 'N/A'),
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title:
                    Text('Order Total: ر.ع.${orderData['order_price'] ?? 0.0}'),
              ),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text(
                    'Payment Method: ${orderData['payment_method'] ?? 'N/A'}'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle),
                title: Text(
                    'Payment Status: ${orderData['payment_status'] ?? 'N/A'}'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo, // Set section title color
              ),
            ),
          ),
          Divider(
            color: Colors.indigo, // Set section divider color
          ),
          ...children,
        ],
      ),
    );
  }
}
