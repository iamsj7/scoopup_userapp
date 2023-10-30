import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoopup_userapp/home_screen.dart';
import 'package:scoopup_userapp/main.dart';
import 'dart:convert';
import 'package:scoopup_userapp/resto_screen.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  
  List<Map<String, dynamic>> cities = [];
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); 
    var size, height, width;// Add GlobalKey

  @override
  void initState() {
    super.initState();
    fetchCities();
  }

  Future<void> fetchCities() async {
    final response = await http.get(
      Uri.parse('https://menu.scoopup.app/api/v2/client/vendor/cities'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('data')) {
        if (_scaffoldKey.currentState?.mounted == true) {
          setState(() {
            cities = List<Map<String, dynamic>>.from(data['data']);
          });
        }
      }
    }
  }

  void _onCityCardTap(int cityId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantScreen(cityId: cityId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      
      key: _scaffoldKey,
      appBar: AppBar(  
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
           Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) =>
                 MyApp()));
          },
        ),
        
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Color(0xFFCE4141)),
          title: Row(
                
            children: [
              SizedBox(width: width/4),
              const Text(
                'Cities',
                style: TextStyle(
                  color: Color(0xFFCE4141),
                  fontSize: 26,
                  fontFamily: "Nunito Sans",
                  fontWeight: FontWeight.w600,
                  
                ),
              ),
          
            ],
          ),
          
        
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile =
              constraints.maxWidth <= 768; // Define your breakpoint

          return ListView.builder(
            itemCount: cities.length,
            itemBuilder: (BuildContext context, int index) {
              final city = cities[index];
              final imageUrl = city['logo'] as String?;
              return GestureDetector(
                onTap: () => _onCityCardTap(city['id']),
                child: Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ClipPath(
                    clipper: MyCustomClipper(), // Use custom clipper
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                      ),
                      height: isMobile ? 200.0 : 400.0, // Adjust the height
                      child: Stack(
                        children: <Widget>[
                          if (imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.0)),
                              child: Image.network(
                                imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              city['name'],
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = 15.0;
    path.moveTo(0, size.height - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
        size.width, size.height, size.width - radius, size.height);
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
