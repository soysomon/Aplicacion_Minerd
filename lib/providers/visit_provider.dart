import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/visit.dart';

class VisitProvider with ChangeNotifier {
  List<Visit> _visits = [];
  bool _isLoading = true;

  List<Visit> get visits => _visits;
  bool get isLoading => _isLoading;

  Future<void> fetchVisits(String token) async {
    final url = 'https://adamix.net/minerd/def/situaciones.php';
    try {
      final response = await http.post(Uri.parse(url), body: {'token': token});

      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);

        if (extractedData['exito']) {
          _visits = (extractedData['datos'] as List).map((item) {
            return Visit.fromJson(item);
          }).toList();
        } else {
          throw Exception('Error: ${extractedData['mensaje']}');
        }

        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to fetch visits: ${response.statusCode}');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to fetch visits: $error');
    }
  }

  Future<void> reportVisit({
    required String token,
    required String cedulaDirector,
    required String codigoCentro,
    required String motivo,
    required String fotoEvidencia,
    required String comentario,
    required String notaVoz,
    required String latitud,
    required String longitud,
    required String fecha,
    required String hora,
  }) async {
    final url = 'https://adamix.net/minerd/minerd/registrar_visita.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'token': token,
          'cedula_director': cedulaDirector,
          'codigo_centro': codigoCentro,
          'motivo': motivo,
          'foto_evidencia': fotoEvidencia,
          'comentario': comentario,
          'nota_voz': notaVoz,
          'latitud': latitud,
          'longitud': longitud,
          'fecha': fecha,
          'hora': hora,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['exito']) {
          notifyListeners();
        } else {
          throw Exception('Error: ${responseData['mensaje']}');
        }
      } else {
        throw Exception('Failed to report visit: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to report visit: $error');
    }
  }

  Future<Visit> fetchVisitDetails(String token, String situacionId) async {
    final url = 'https://adamix.net/minerd/def/situacion.php';
    try {
      final response = await http.post(Uri.parse(url), body: {'token': token, 'situacion_id': situacionId});

      if (response.statusCode == 200) {
        final visitData = json.decode(response.body);

        if (visitData['exito']) {
          return Visit.fromJson(visitData['datos']);
        } else {
          throw Exception('Error: ${visitData['mensaje']}');
        }
      } else {
        throw Exception('Failed to fetch visit details: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch visit details: $error');
    }
  }


Future<void> deleteAllVisits() async {
    _visits.clear();
    notifyListeners();
  }
}