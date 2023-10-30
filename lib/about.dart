import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About App'),
        backgroundColor: Color(0xFFCE4141), // Brand color
      ),
      body: FAQSection(),
    );
  }
}

class FAQSection extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'What is Scoop Up?',
      'answer':
          'Scoop Up is your go-to destination for exploring a diverse array of restaurants at your fingertips.'
    },
    {
      'question': 'How can I use Scoop Up?',
      'answer':
          'You can effortlessly create an account and log in to access an extensive list of top-rated restaurants available through the app.'
    },
    {
      'question': 'Can I place online orders through Scoop Up?',
      'answer':
          'Yes, you can conveniently place online orders from any of the featured restaurants, making the entire dining experience seamless and enjoyable.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: faqs.map((faq) {
        return Card(
          margin: EdgeInsets.all(10.0),
          child: ExpansionTile(
           iconColor:  Color(0xFFCE4141),
            textColor:  Color(0xFFCE4141),
            
            
            title: Text(
              faq['question']!,
              style: TextStyle(fontWeight: FontWeight.bold,
              
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  faq['answer']!,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
