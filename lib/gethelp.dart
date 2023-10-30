import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GetHelp extends StatelessWidget {
  final List<Map<String, String>> socialMediaAccounts = [
    {'name': 'Twitter', 'icon': 'images/xlogo.png', 'url': 'https://twitter.com/'},
   // {'name': 'Facebook', 'icon': 'icons/facebook.png', 'url': 'https://facebook.com'},
    {'name': 'Instagram', 'icon': 'images/insta.png', 'url': 'https://www.instagram.com/oktaiotech/'},
    {'name': 'Website', 'icon': 'images/website.png', 'url': 'https://oktaio.com'},
  ];
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Media'),
        backgroundColor: Color(0xFFCE4141), // Brand color
      ),
      body: ListView.builder(
        itemCount: socialMediaAccounts.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
               _launchURL(socialMediaAccounts[index]['url']!);
              // Add functionality to open social media URLs
            },
            child: Card(
              elevation: 3.0,
              margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      socialMediaAccounts[index]['icon']!,
                      width: 30,
                      height: 50,
                    ),
                    SizedBox(width: 10),
                    Text(
                      socialMediaAccounts[index]['name']!,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



 