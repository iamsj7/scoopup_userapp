import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  OrderDetailsScreen({required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${orderData['id_formated']}'),
        backgroundColor:
            Color(0xFFCE4141), // Set app bar color to your brand color
      ),
      body: ListView(
        children: <Widget>[
          _buildSection(
            title: 'Order Status',
            children: <Widget>[
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x30CE4141), // Tinted transparent color
                  ),
                  child: Icon(Icons.timeline,
                      color: Color(0xFFCE4141)), // Icon color
                ),
                title: Text('Status: ${orderData['last_status'][0]['name']}'),
              ),
              if (orderData['time_created'] != null)
                ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x30CE4141), // Tinted transparent color
                    ),
                    child: Icon(Icons.access_time,
                        color: Color(0xFFCE4141)), // Icon color
                  ),
                  title: Text('Last Update: ${orderData['time_created']}'),
                ),
            ],
          ),
          _buildSection(
            title: 'Restaurant Information',
            children: <Widget>[
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x30CE4141), // Tinted transparent color
                  ),
                  child:
                      Icon(Icons.store, color: Color(0xFFCE4141)), // Icon color
                ),
                title: Text(orderData['restorant']['name'] ?? 'N/A'),
                subtitle: Text(orderData['restorant']['address'] ?? 'N/A'),
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x30CE4141), // Tinted transparent color
                  ),
                  child:
                      Icon(Icons.phone, color: Color(0xFFCE4141)), // Icon color
                ),
                title:
                    Text('Phone: ${orderData['restorant']['phone'] ?? 'N/A'}'),
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x30CE4141), // Tinted transparent color
                  ),
                  child:
                      Icon(Icons.info, color: Color(0xFFCE4141)), // Icon color
                ),
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
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x30CE4141), // Tinted transparent color
                      ),
                      child: Icon(Icons.fastfood,
                          color: Color(0xFFCE4141)), // Icon color
                    ),
                    title: Text('${item['qty']} X ${item['name']}'),
                    subtitle: Text('Price: ر.ع.${item['price']}'),
                  ),
                  ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x30CE4141), // Tinted transparent color
                      ),
                      child: Icon(Icons.dashboard,
                          color: Color(0xFFCE4141)), // Icon color
                    ),
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
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x30CE4141), // Tinted transparent color
                  ),
                  child: Icon(Icons.location_on,
                      color: Color(0xFFCE4141)), // Icon color
                ),
                title: Text('Delivery Address'),
                subtitle: Text(orderData['whatsapp_address'] ?? 'N/A'),
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x30CE4141), // Tinted transparent color
                  ),
                  child: Icon(Icons.comment,
                      color: Color(0xFFCE4141)), // Icon color
                ),
                title: Text('Comment'),
                subtitle: Text(orderData['comment'] ?? 'N/A'),
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x30CE4141), // Tinted transparent color
                  ),
                  child:
                      Icon(Icons.phone, color: Color(0xFFCE4141)), // Icon color
                ),
                title: Text('Contact Phone'),
                subtitle: Text(orderData['phone'] ?? 'N/A'),
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x30CE4141), // Tinted transparent color
                  ),
                  child: Icon(Icons.attach_money,
                      color: Color(0xFFCE4141)), // Icon color
                ),
                title:
                    Text('Order Total: ر.ع.${orderData['order_price'] ?? 0.0}'),
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x30CE4141), // Tinted transparent color
                  ),
                  child: Icon(Icons.payment,
                      color: Color(0xFFCE4141)), // Icon color
                ),
                title: Text(
                    'Payment Method: ${orderData['payment_method'] ?? 'N/A'}'),
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x30CE4141), // Tinted transparent color
                  ),
                  child: Icon(Icons.check_circle,
                      color: Color(0xFFCE4141)), // Icon color
                ),
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
                color: Color(
                    0xFFCE4141), // Set section title color to your brand color
              ),
            ),
          ),
          Divider(
            color: Color(
                0xFFCE4141), // Set section divider color to your brand color
          ),
          ...children,
        ],
      ),
    );
  }
}
