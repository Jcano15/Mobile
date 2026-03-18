import 'dart:convert';
import 'package:http/http.dart' as http;

/// Servicio para comunicarse con la API Node.js en localhost:3000
class ApiService {
  static const String _baseUrl = 'http://localhost:3000/api_v1';

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

  /// Obtiene todos los usuarios de la API — GET /apiUser
  /// Requiere token JWT como Bearer.
  static Future<List<Map<String, dynamic>>> getApiUsers(String token) async {
    final uri = Uri.parse('$_baseUrl/apiUser');
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
      throw Exception(data['error'] ?? 'Error al obtener usuarios');
    }
  }

  /// Crea un nuevo estado de usuario — POST /userStatus
  static Future<void> createUserStatus(String token, String name, String description) async {
    final uri = Uri.parse('$_baseUrl/userStatus');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode != 201) {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? 'Error al crear estado');
    }
  }

  /// Actualiza un estado de usuario — PUT /userStatus/:id
  static Future<void> updateUserStatus(String token, int id, String name, String description) async {
    final uri = Uri.parse('$_baseUrl/userStatus/$id');
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? 'Error al actualizar estado');
    }
  }

  /// Elimina un estado de usuario — DELETE /userStatus/:id
  static Future<void> deleteUserStatus(String token, int id) async {
    final uri = Uri.parse('$_baseUrl/userStatus/$id');
    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? 'Error al eliminar estado');
    }
  }
}
