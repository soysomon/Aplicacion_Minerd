import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/center_model.dart';

class CenterApiService {
  final String apiUrl = 'https://adamix.net/minerd/minerd/centros.php';

  Future<List<EducationalCenter>> fetchCenters(String regional) async {
    final response = await http.get(Uri.parse('$apiUrl?regional=$regional'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data['exito']) {
        return (data['datos'] as List)
            .map((json) => EducationalCenter.fromJson(json))
            .toList();
      } else {
        throw Exception(data['mensaje']);
      }
    } else {
      throw Exception('Failed to load centers');
    }
  }
}
