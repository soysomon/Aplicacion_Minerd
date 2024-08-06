import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HoroscopeProvider with ChangeNotifier {
  String _horoscope = '';
  bool _isLoading = false;

  String get horoscope => _horoscope;
  bool get isLoading => _isLoading;

  Future<void> fetchHoroscope(String sign) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
        'https://horoscope-app-api.vercel.app/api/v1/get-horoscope/daily?sign=$sign&day=TODAY');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null) {
          _horoscope =
              data['data']['horoscope_data'] ?? 'No hay horóscopo disponible.';
        } else {
          _horoscope = 'Error al cargar el horóscopo.';
        }
      } else {
        _horoscope = 'Error al cargar el horóscopo.';
      }
    } catch (e) {
      print('Error: $e');
      _horoscope = 'Error al cargar el horóscopo.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
