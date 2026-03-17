import 'dart:convert';
import 'package:http/http.dart' as http;

/// Servicio para comunicarse con la API Node.js en localhost:3000
class ApiService {
  static const String _baseUrl = 'http://localhost:3000';

  /// Login — POST /apiUserLogin
  /// Retorna el token JWT si las credenciales son correctas, o lanza excepción.
  static Future<String> login(String apiUser, String apiPassword) async {
    final uri = Uri.parse('$_baseUrl/apiUserLogin');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'api_user': apiUser, 'api_password': apiPassword}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['token'] as String;
    } else {
      throw Exception(data['error'] ?? 'Error al iniciar sesión');
    }
  }

  /// Verifica si el token aún es válido — POST /apiUserVerifyToken
  /// Retorna los datos del usuario si el token es válido.
  static Future<Map<String, dynamic>> verifyToken(String token) async {
    final uri = Uri.parse('$_baseUrl/apiUserVerifyToken');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['user'] as Map<String, dynamic>;
    } else {
      throw Exception(data['error'] ?? 'Token inválido');
    }
  }

  /// Obtiene todos los estados de usuario — GET /userStatus
  /// Requiere token JWT como Bearer.
  static Future<List<Map<String, dynamic>>> getUserStatuses(String token) async {
    final uri = Uri.parse('$_baseUrl/userStatus');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? 'Error al obtener estados');
    }
  }
}
