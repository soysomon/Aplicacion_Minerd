import 'dart:convert';
import 'package:http/http.dart' as http;

class CentroApi {
  static const String baseUrl = 'https://adamix.net/minerd/minerd/centros.php';

  Future<List<Centro>> fetchCentros({required String regional}) async {
    final response = await http.get(Uri.parse('$baseUrl?regional=$regional'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data['exito']) {
        List<dynamic> centrosJson = data['datos'];
        return centrosJson.map((json) => Centro.fromJson(json)).toList();
      } else {
        throw Exception('Error: ${data['mensaje']}');
      }
    } else {
      throw Exception('Failed to load centros');
    }
  }
}

class Centro {
  final String id;
  final String codigo;
  final String nombre;
  final String coordenadas;
  final String distrito;
  final String regional;
  final String dMunicipal;

  Centro({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.coordenadas,
    required this.distrito,
    required this.regional,
    required this.dMunicipal,
  });

  factory Centro.fromJson(Map<String, dynamic> json) {
    return Centro(
      id: json['idx'] ?? '',
      codigo: json['codigo'] ?? '',
      nombre: json['nombre'] ?? '',
      coordenadas: json['coordenadas'] ?? '',
      distrito: json['distrito'] ?? '',
      regional: json['regional'] ?? '',
      dMunicipal: json['d_dmunicipal'] ?? '',
    );
  }
}
