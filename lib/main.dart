import 'package:flutter/material.dart';
import 'package:scoopup_userapp/account_screen.dart';
import 'package:scoopup_userapp/city_screen.dart';
import 'package:scoopup_userapp/home_screen.dart';
import 'package:scoopup_userapp/orders_screen.dart';
import 'package:scoopup_userapp/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    CityScreen(),
    AccountScreen(), // Use your AccountScreen here
  ];

  String? authToken; // Store the login token
  String? userName; // Store the user's name
  String? userEmail; // Store the user's email

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    if (token != null) {
      setState(() {
        authToken = token;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void handleLogin(Map<String, dynamic> userData) {
    // Handle the login and store the token, user's name, and email
    setState(() {
      authToken = userData['token'];
      userName = userData['name'];
      userEmail = userData['email'];
      _selectedIndex = 0; // Navigate to the home screen after login
    });
  }

  void handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    setState(() {
      authToken = null;
      userName = null;
      userEmail = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter REST App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: authToken != null
          ? Scaffold(
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(userName ?? 'Your Name'),
                      accountEmail: Text(userEmail ?? 'your@email.com'),
                    ),
                    ListTile(
                      title: Text('Logout'),
                      onTap: handleLogout,
                    ),
                  ],
                ),
              ),
              body: _screens[_selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.location_city),
                    label: 'City',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.delivery_dining),
                    label: 'Orders',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            )
          : LoginScreen(handleLogin: handleLogin),
    );
  }
}
