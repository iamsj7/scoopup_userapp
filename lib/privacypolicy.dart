import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: Color(0xFFCE4141), // Brand color

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal identification information:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may collect personal identification information from Users in various ways, including, but not limited to, when Users create an account within the App. Users may be asked for, as appropriate, name, email address, and phone number. Users may, however, visit our App anonymously. We will collect personal identification information from Users only if they voluntarily submit such information to us. Users can always refuse to supply personally identification information, except that it may prevent them from engaging in certain App-related activities.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Non-personal identification information:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may collect non-personal identification information about Users whenever they interact with our App. Non-personal identification information may include the browser name, the type of device, and technical information about Users\' means of connection to our App, such as the operating system and the Internet service providers utilized and other similar information.',
              style: TextStyle(fontSize: 16.0),
            ),
            // Add other sections similarly

            SizedBox(height: 16.0),
            Text(
              'How we protect your information::',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'We adopt appropriate data collection, storage, and processing practices and security measures to protect against unauthorized access, alteration, disclosure, or destruction of your personal information and data stored on our App.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),

             SizedBox(height: 16.0),
            Text(
              'Sharing your personal information:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'We do not sell, trade, or rent Users personal identification information to others. We may share generic aggregated demographic information not linked to any personal identification information regarding visitors and users with our business partners, trusted affiliates, and advertisers for the purposes outlined above.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),

             SizedBox(height: 16.0),
            Text(
              'Contacting us:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'If you have any questions about this Privacy Policy, the practices of this App, or your dealings with this App, please contact us at [your contact information].',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}


