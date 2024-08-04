import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo_remolacha.png',
          height: 30,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (newsProvider.news.isEmpty) {
            return Center(child: Text('No hay noticias disponibles.'));
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Novedades Educativas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: newsProvider.news.length,
                      itemBuilder: (context, index) {
                        final news = newsProvider.news[index];
                        final imageUrl = news['jetpack_featured_media_url'] ?? '';
                        return GestureDetector(
                          onTap: () {
                            _showNewsDetail(context, news);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: imageUrl.isNotEmpty
                                      ? FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/logo_remolacha.png',
                                    image: imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/logo_remolacha.png',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      );
                                    },
                                  )
                                      : Image.asset(
                                    'assets/images/logo_remolacha.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Text(
                                    news['title']['rendered'] ?? 'No Title',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 6.0,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Noticias Locales',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: newsProvider.news.length,
                    itemBuilder: (context, index) {
                      final news = newsProvider.news[index];
                      final imageUrl = news['jetpack_featured_media_url'] ?? '';
                      return GestureDetector(
                        onTap: () {
                          _showNewsDetail(context, news);
                        },
                        child: Card(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: imageUrl.isNotEmpty
                                    ? FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/logo_remolacha.png',
                                  image: imageUrl,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/logo_remolacha.png',
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    );
                                  },
                                )
                                    : Image.asset(
                                  'assets/images/logo_remolacha.png',
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        news['title']['rendered'] ?? 'No Title',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Helvetica',
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Author Name · ${news['date']?.toString() ?? 'Remolacha.net'}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        news['excerpt']['rendered']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No Description',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _showNewsDetail(BuildContext context, Map<String, dynamic> news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(news: news),
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> news;

  NewsDetailScreen({required this.news});

  @override
  Widget build(BuildContext context) {
    final imageUrl = news['jetpack_featured_media_url'] ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                imageUrl.isNotEmpty
                    ? FadeInImage.assetNetwork(
                  placeholder: 'assets/images/logo_remolacha.png',
                  image: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/logo_remolacha.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250,
                    );
                  },
                )
                    : Image.asset(
                  'assets/images/logo_remolacha.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news['title']['rendered'] ?? 'No Title',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 6.0,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/logo_remolacha.png'),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Remolacha.net',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            news['date']?.toString() ?? '...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Html(
                    data: news['content']['rendered'] ?? 'No Content',
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          // Implement share functionality
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          // Implement comment functionality
                        },
                      ),
                      Spacer(),
                      Text(
                        '${news['comments_count']?.toString() ?? '0'} comments',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
