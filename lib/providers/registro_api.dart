import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistroApi {
  static const String baseUrl = 'https://adamix.net/minerd/def';

  Future<Map<String, dynamic>> registrarTecnico({
    required String cedula,
    required String nombre,
    required String apellido,
    required String clave,
    required String correo,
    required String telefono,
    required String fechaNacimiento,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registro.php'),
      body: {
        'cedula': cedula,
        'nombre': nombre,
        'apellido': apellido,
        'clave': clave,
        'correo': correo,
        'telefono': telefono,
        'fecha_nacimiento': fechaNacimiento,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register tecnico');
    }
  }

  Future<Map<String, dynamic>> cambiarClave({
    required String token,
    required String claveAnterior,
    required String claveNueva,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cambiar_clave.php'),
      body: {
        'token': token,
        'clave_anterior': claveAnterior,
        'clave_nueva': claveNueva,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cambiar la clave: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> iniciarSesion({
    required String cedula,
    required String clave,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/iniciar_sesion.php'),
      body: {
        'cedula': cedula,
        'clave': clave,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> recuperarClave({
    required String cedula,
    required String correo,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recuperar_clave.php'),
      body: {
        'cedula': cedula,
        'correo': correo,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to recover password');
    }
  }
}
