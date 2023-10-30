import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scoopup_userapp/city_screen.dart';
import 'package:scoopup_userapp/offers.dart';
import 'package:scoopup_userapp/onboarding.dart';
import 'package:scoopup_userapp/orders_screen.dart';
import 'package:scoopup_userapp/vouchers.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? bannerData;
  List<String> offerImages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose of any resources, e.g., cancel ongoing HTTP requests
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
          'https://raw.githubusercontent.com/iamsj7/scoopup_userapp/main/banner.json'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final offerImages = List<String>.from(data['offerImages']);
      if (mounted) {
        setState(() {
          bannerData = data;
          this.offerImages = offerImages;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            bannerData != null
                ? Container(
                    height: 200.0,
                    decoration: const BoxDecoration(
                      color: Color(0x40CE4141),
                      
                    ),
                    
                    child: Row(
                      children: <Widget>[
                        
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10,bottom: 20),
                                child: IconButton(
                                  alignment: Alignment.topLeft,
                                                  icon: Icon(Icons.menu), 
                                                  // Icon for the menu
                                                  onPressed: () {
                                                    Scaffold.of(context).openDrawer(); 
                                                     },
                                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  bannerData!['title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFCE4141),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CityScreen()));
                                    // Add button functionality here
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shadowColor: Color(0xFFCE4141),
                                  ),
                                  child: const Text(
                                    'Start Order',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFCE4141),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 200,
                            maxHeight: 200,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(right: 50),
                            child: Image.network(
                              bannerData!['imageURL'],
                              fit: BoxFit.fill,
                              height: 120,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const CircularProgressIndicator(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Shortcuts',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // ignore: sized_box_for_whitespace
            Container(
              height: 120.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildShortcutCard(
                      'Our Picks', Icons.star, Color(0xFFCE4141)),
                  GestureDetector(
                      child: _buildShortcutCard(
                          'Past Order', Icons.history, Color(0xFFCE4141)),
                      onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Onboarding()))
                          }),
                  GestureDetector(
                      child: _buildShortcutCard(
                          'Offers', Icons.local_offer, Color(0xFFCE4141)),
                      onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyHomePage()))
                          }),
                  GestureDetector(
                      child: _buildShortcutCard(
                          'Coupons', Icons.local_activity, Color(0xFFCE4141)),
                      onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const vouchers()))
                          }),
                  _buildShortcutCard(
                      'Near By', Icons.location_on, Color(0xFFCE4141)),
                  _buildShortcutCard(
                      'Your Category', Icons.category, Color(0xFFCE4141)),
                ],
              ),
            ),
            _buildExploreOffersSection(offerImages),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutCard(String title, IconData icon, Color tint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.1),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              color: tint,
              size: 36,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            title,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExploreOffersSection(List<String> offerImages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Explore Offers',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CarouselSlider(
          items: offerImages.map((imageURL) {
            return Container(
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(imageURL),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 200.0,
            viewportFraction: 0.8,
            aspectRatio: 16 / 9,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
        ),
      ],
    );
  }
}
