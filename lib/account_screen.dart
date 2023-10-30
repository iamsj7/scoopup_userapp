import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoopup_userapp/myaddress_screen.dart';
import 'package:scoopup_userapp/offers.dart';
import 'package:scoopup_userapp/orders_screen.dart';
import 'package:scoopup_userapp/vouchers.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String name = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    // Load user information when the screen is initialized
    loadUserInformation();
  }

  Future<void> loadUserInformation() async {
    // Retrieve the API token from shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String apiToken = prefs.getString('authToken') ?? '';

    final response = await http.get(
      Uri.parse(
          'https://menu.scoopup.app/api/v2/client/auth/data?api_token=$apiToken'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      if (userData['status'] == true) {
        // Update user information
        setState(() {
          name = userData['data']['name'];
          email = userData['data']['email'];
          phone = userData['data']['phone'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        backgroundColor: Color(0xFFCE4141), // Brand color
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Display user information in a Material Card with a circular avatar
          Card(
            elevation: 8,
             color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(10)), // Tinted color
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Circular avatar with the user's name initial
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty
                            ? name[0]
                            : 'A', // Display 'A' if name is empty
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // Add some spacing
                  // User information displayed right-aligned
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: $name',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        Text(
                          'Email: $email',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        Text(
                          'Phone: $phone',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add a ListView for other account-related pages
          ListView(
            shrinkWrap: true,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  _buildAccountListItem('My Orders', Icons.shopping_cart),
                  _buildAccountListItem('My Address', Icons.location_on),
                  _buildAccountListItem('Offers', Icons.local_offer),
                  _buildAccountListItem('Vouchers', Icons.confirmation_number),
                  _buildAccountListItem('Get Help', Icons.help_outline),
                  _buildAccountListItem('Privacy Policy', Icons.lock),
                  _buildAccountListItem('About App', Icons.info),
                ],
              ),
              // Add more ListTiles for other account-related pages
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountListItem(String title, IconData icon) {
    return ListTile(
      title: Text(title),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0x40CE4141), // Transparent tint of brand color
        ),
        child: Center(
          child: Icon(
            icon,
            color: Color(0xFFCE4141), // Brand color
          ),
        ),
      ),
      onTap: () {
        // Add navigation logic for each item here
        if (title == 'My Orders') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OrderScreen()));
        }
        if (title == 'My Address') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyAddressScreen()));
        }
        if (title == 'Offers') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyHomePage()));
        }
        if (title == 'Vouchers') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => vouchers()));
        }
        
        // Add more navigation logic for other items
      },
    );
  }
}
