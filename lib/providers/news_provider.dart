import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NewsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _news = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get news => _news;
  bool get isLoading => _isLoading;

  NewsProvider() {
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url = 'https://remolacha.net/wp-json/wp/v2/posts?search=minerd';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List<dynamic>;
      _news = extractedData.map((item) => item as Map<String, dynamic>).toList();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
