import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (newsProvider.news.isEmpty) {
            return Center(child: Text('No hay noticias disponibles.'));
          } else {
            return CarouselSlider.builder(
              itemCount: newsProvider.news.length,
              itemBuilder: (context, index, realIndex) {
                final news = newsProvider.news[index];
                return NewsCard(
                  title: news['title']['rendered'],
                  date: news['date'],
                  content: news['content']['rendered'],
                  imageUrl: news['jetpack_featured_media_url'],
                  link: news['link'],
                );
              },
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
              ),
            );
          }
        },
      ),
    );
  }
}
