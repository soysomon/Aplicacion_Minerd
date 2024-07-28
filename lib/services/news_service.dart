import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  static Future<List<Map<String, String>>> fetchNews() async {
    final response = await http.get(Uri.parse('https://remolacha.net/wp-json/wp/v2/posts?search=minerd'));

    if (response.statusCode == 200) {
      List newsData = json.decode(response.body);
      return newsData.map<Map<String, String>>((news) {
        return {
          'title': news['title']['rendered'] ?? 'No Title',
          'description': news['excerpt']['rendered'] ?? 'No Description',
          'imageUrl': news['jetpack_featured_media_url'] ?? '',
          'link': news['link'] ?? '#',
        };
      }).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
