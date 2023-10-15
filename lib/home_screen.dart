import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

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
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            bannerData != null
                ? Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                bannerData!['title'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Add button functionality here
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent.withOpacity(0.7),
                                  onPrimary: Colors.white,
                                ),
                                child: Text('Click Me'),
                              ),
                            ],
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 200,
                            maxHeight: 200,
                          ),
                          child: Image.network(
                            bannerData!['imageURL'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  )
                : CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Shortcuts',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 120.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildShortcutCard('Our Picks', Icons.star, Colors.blue),
                  _buildShortcutCard('Past Order', Icons.history, Colors.green),
                  _buildShortcutCard(
                      'Offers', Icons.local_offer, Colors.orange),
                  _buildShortcutCard(
                      'Coupons', Icons.local_activity, Colors.red),
                  _buildShortcutCard(
                      'Near By', Icons.location_on, Colors.purple),
                  _buildShortcutCard(
                      'Your Category', Icons.category, Colors.amber),
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
          SizedBox(height: 4.0),
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
        Padding(
          padding: const EdgeInsets.all(16.0),
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
