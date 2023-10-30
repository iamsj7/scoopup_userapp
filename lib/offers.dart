import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {

  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final expandedHeight = MediaQuery.of(context).size.height * 0.2;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            leading: GestureDetector(
              onTap: () => {},
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            flexibleSpace: Image.network(
              "https://source.unsplash.com/random/400x225?sig=1&licors",
              fit: BoxFit.cover,
            ),
            expandedHeight: MediaQuery.of(context).size.height * 0.2,
            backgroundColor: const Color(0xFFFFF4F4),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 1000)),
        ],
      ),
    );
  }
}
