import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String date;
  final String content;
  final String imageUrl;
  final String link;

  NewsCard({
    required this.title,
    required this.date,
    required this.content,
    required this.imageUrl,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(imageUrl),
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(date),
          Text(content),
          // Add more widgets as needed
        ],
      ),
    );
  }
}
